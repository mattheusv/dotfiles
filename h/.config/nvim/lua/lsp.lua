local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
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

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
    local opts = { noremap = true, silent = true }

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Completion setup
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

    -- Mappings.
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
    buf_set_keymap('n', '<leader>gd', '<Cmd>vsplit<cr>:lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'td', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]], opts)
    buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
    buf_set_keymap('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    buf_set_keymap('n', '<leader>wd', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]], opts)
    buf_set_keymap('n', '<leader>ws', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]], opts)
    buf_set_keymap('n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('i', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

    buf_set_keymap('n', '<MiddleMouse>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<RightMouse>',[[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
    buf_set_keymap('n', '<2-RightMouse>', '<Cmd>:e#<CR>', opts)


    -- Set a map and auto formatting if lsp has suport
    if client.supports_method("textDocument/formatting") then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", opts)

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Formatting", { clear = true }),
            callback = function()
                vim.lsp.buf.format()
            end
        })
    end

    -- Set autocommands and maps to document highlight
    if client.supports_method("textDocument/documentHighlight") then
        vim.api.nvim_exec([[
            highlight LspReferenceRead cterm=bold ctermbg=red guibg=#464646
            highlight LspReferenceText cterm=bold ctermbg=red guibg=#464646
            highlight LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
            ]],
            false
        )

        vim.api.nvim_create_autocmd("CursorHold", {
            group = vim.api.nvim_create_augroup("DocumentHighlightHold", { clear = true }),
            callback = function()
                vim.lsp.buf.document_highlight()
            end
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = vim.api.nvim_create_augroup("DocumentHighlightMoved", { clear = true }),
            callback = function()
                vim.lsp.buf.clear_references()
            end
        })
    end

    if vim.tbl_contains({ "go" }, filetype) then
        setup_vimgo()
    end

end

local function gopls_config()
    local settings = {
        gopls = {
            allExperiments = true,
            analyses = {
                unusedparams = true,
                shadow = false,
            },
            gofumpt = true,
            staticcheck = true,
        },
    }

    local gopls_remote = os.getenv("GOPLS_REMOTE")
    if gopls_remote == "1" then
        return {
            cmd = { "gopls", "-remote", "localhost:8888" }
        }
    end
    return {
        settings = settings,
    }
end

local function setup_servers()
    local servers = {
        gopls = gopls_config(),
        rust_analyzer = {},
        jedi_language_server = {},
        tsserver = {},
        clangd = {},
        bashls = {},
        dockerls = {},
        yamlls = {},
        vimls = {},
        lua_ls = {},
        perlpls = {},
        jsonls = {},
        zls = {
            settings = {
                enable_autofix = false,
            },
        },
    }

    local cap = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
    for server, config in pairs(servers) do
        config = config or {}
        config.on_attach = on_attach
        config.capabilities = config.capabilities or cap

        nvim_lsp[server].setup(config)
    end
end

function lsp.setup()
    set_options()
    setup_servers()
end

function lsp.setup_java() 
    local home = os.getenv('HOME')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = home .. '/dev/tools/jdtls-workspace' .. project_name

    local config = {
        cmd = {
            'java', 
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-Xmx4g',
            '--add-modules=ALL-SYSTEM',
            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            '-jar', home .. '/dev/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar',
            '-configuration', home .. '/dev/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux',
            '-data', workspace_dir
        },
        on_attach = on_attach
    }
    require('jdtls').start_or_attach(config)
end

return lsp
