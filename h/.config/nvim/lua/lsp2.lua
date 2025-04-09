local null_ls = require("null-ls")
local cmp = require('cmp')
local luasnip = require("luasnip")
local telescope = require('telescope.builtin');
local lsp = {}

local function set_options()
    -- LSP options
    vim.o.completeopt = "menuone,noinsert,noselect"
    vim.g.diagnostic_insert_delay = true

    vim.g.python_highlight_all = true
    vim.g.python3_host_prog = '~/.config/nvim/venv/bin/python3'
end

local function setup_vimgo()
    vim.g.go_list_type = "quickfix"
    vim.g.go_fmt_command = "goimports"
    vim.g.go_fmt_fail_silently = true
    vim.g.go_highlight_types = true
    vim.g.go_highlight_fields = true
    vim.g.go_highlight_functions = true
    vim.g.go_highlight_methods = true
    vim.g.go_highlight_operators = true
    vim.g.go_highlight_build_constraints = true
    vim.g.go_highlight_structs = true
    vim.g.go_highlight_generate_tags = true
    vim.g.go_highlight_space_tab_error = false
    vim.g.go_highlight_array_whitespace_error = false
    vim.g.go_highlight_trailing_whitespace_error = false
    vim.g.go_highlight_extra_types = true
    vim.g.go_rename_command = "gopls"
    vim.g.go_echo_go_info = false

    vim.api.nvim_command("command! -bang A call go#alternate#Switch(<bang>0, 'edit')")
    vim.api.nvim_command("command! -bang AS call go#alternate#Switch(<bang>0, 'vsplit')")
end

local function setup_pyright()
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("Formatting", { clear = true }),
        pattern = "*.py",
        callback = function()
            if vim.bo.filetype == "python" then
                vim.lsp.buf.format()
            end
        end
    })
end

local function setup_postgres_formatting()
    -- TODO: Only create the autocmd if pgindent is available on the system
    -- TODO: Just create this autocmd on postgres source code directory.
    -- TODO: include pgperltidy formatting for perl files.

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("PgFormatting", { clear = true }),
        pattern = "*.c",
        callback = function()
            local filepath = vim.api.nvim_buf_get_name(0)
            if vim.bo.filetype == "c" and filepath:match("pgdev") then
                vim.cmd("silent! execute '!pgindent ' .. shellescape('" .. filepath .. "')")
            end
        end
    })
end


local function setup_cmp()
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = {
            ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-c>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
        },
        sources = {
            { name = "path" },
            { name = "vsnip" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
        },
    })
end

local function setup_document_highlight(buffer)
    local highlights = {
        { name = "LspReferenceRead",  opts = { link = "", bold = true, bg = "#464646" } },
        { name = "LspReferenceText",  opts = { link = "", bold = true, bg = "#464646" } },
        { name = "LspReferenceWrite", opts = { link = "", bold = true, bg = "#464646" } },
    }
    for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl.name, hl.opts)
    end

    -- Clear existing highlights when the cursor moves
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        callback = vim.lsp.buf.document_highlight,
        buffer = buffer,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        callback = vim.lsp.buf.clear_references,
        buffer = buffer,
    })
end

local function on_attach()
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
                return
            end

            -- Set nvim-cmp
            if client:supports_method('textDocument/completion') then
                setup_cmp()
            end

            -- Set autocommands to document highlight
            if client:supports_method('textDocument/documentHighlight') then
                setup_document_highlight(ev.buf)
            end

            if client.name == "gopls" then
                setup_vimgo()
            end

            if client.name == "pyright" then
                setup_pyright()
            end

            if client.name == "clangd" then
                setup_postgres_formatting()
            end
        end,
    })
end

local function set_keymaps()
    -- Builtin keymaps
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('i', '<c-space>', vim.lsp.completion.get)

    -- Telescope keymaps
    vim.keymap.set('n', 'gd', telescope.lsp_definitions)
    vim.keymap.set('n', 'td', telescope.lsp_type_definitions)
    vim.keymap.set('n', 'gr', telescope.lsp_references)
    vim.keymap.set('n', '<leader>s', telescope.lsp_document_symbols)
    vim.keymap.set('n', '<leader>wd', telescope.diagnostics)
    vim.keymap.set('n', '<leader>ws', telescope.lsp_dynamic_workspace_symbols)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations)

    -- Lspsaga keymaps
    vim.keymap.set('n', 'gdp', [[<cmd>:Lspsaga peek_definition<CR>]])
    vim.keymap.set('n', 'tdp', [[<cmd>:Lspsaga peek_type_definition<CR>]])
    vim.keymap.set('n', '<space>a', '<cmd>:Lspsaga code_action<CR>')
    vim.keymap.set('n', 'K', '<Cmd>:Lspsaga hover_doc<CR>')
    vim.keymap.set('n', '<leader>rn', '<cmd>:Lspsaga rename<CR>')
end

local function enable_servers()
    vim.lsp.enable({
        'bashls',
        'clangd',
        'gopls',
        -- 'jdtls' is configured using ftplugin
        'jsonls',
        'lua_ls',
        'perlls',
        'pyright',
        'rust-analyzer',
        'typos_lsp',
        'zls',
    })
end

local function setup_mason()
    require('mason-tool-installer').setup {
        ensure_installed = {
            'bash-language-server',
            'clangd',
            'gopls',
            -- 'jdtls' is configured using ftplugin
            'json-lsp',
            'lua-language-server',
            -- 'perlls' is not supported by mason
            'python-lsp-server',
            'rust-analyzer',
            'typos-lsp',
            'zls',
        }
    }
end

local function setup_lspsaga()
    require('lspsaga').setup({
        lightbulb = {
            enable = false,
        },
        symbol_in_winbar = {
            hide_keyword = true,
            color_mode = false,
        },
    })
end

local function setup_nullls()
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.black.with({
                command = "black",
                extra_args = {
                    "--fast",
                    "--line-length=120",
                },
            }),
        },
    })
end

function lsp.setup()
    set_options()
    set_keymaps()
    on_attach()
    enable_servers()

    setup_mason()
    setup_lspsaga()
    setup_nullls()
end

return lsp
