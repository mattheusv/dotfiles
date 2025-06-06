local nvim_lsp = require('lspconfig')
local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
local null_ls = require("null-ls")
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

local function exists(list, element)
    for _, value in ipairs(list) do
        if value == element then
            return true
        end
    end
    return false
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
    buf_set_keymap('n', '<leader>rn', '<cmd>:Lspsaga rename<CR>', opts)
    buf_set_keymap('n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
    buf_set_keymap('n', 'gdp', [[<cmd>:Lspsaga peek_definition<CR>]], opts)
    buf_set_keymap('n', '<leader>gd', '<Cmd>vsplit<cr>:lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'td', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]], opts)
    buf_set_keymap('n', 'tdp', [[<cmd>:Lspsaga peek_type_definition<CR>]], opts)
    buf_set_keymap('n', '<space>a', '<cmd>:Lspsaga code_action<CR>', opts)
    buf_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
    buf_set_keymap('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    buf_set_keymap('n', '<leader>wd', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]], opts)
    buf_set_keymap('n', '<leader>ws', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]], opts)
    buf_set_keymap('n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
    buf_set_keymap('n', 'K', '<Cmd>:Lspsaga hover_doc<CR>', opts)
    buf_set_keymap('i', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

    buf_set_keymap('n', '<MiddleMouse>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<RightMouse>', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
    buf_set_keymap('n', '<2-RightMouse>', '<Cmd>:e#<CR>', opts)

    -- Set a map and auto formatting if lsp has support
    if client.supports_method("textDocument/formatting") then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", opts)

        if not vim.tbl_contains({ "clangd" }, client.name) then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("Formatting", { clear = true }),
                callback = function()
                    vim.lsp.buf.format()
                end
            })
        end
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

        -- Clear existing highlights when the cursor moves
        vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

        vim.api.nvim_create_autocmd("CursorHold", {
            group = "LspDocumentHighlight",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = "LspDocumentHighlight",
            buffer = bufnr,
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
        pyright = {},
        clangd = {},
        bashls = {},
        dockerls = {},
        yamlls = {},
        vimls = {},
        lua_ls = {
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- Depending on the usage, you might want to add additional paths here.
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                })
            end,
            settings = {
                Lua = {}
            }
        },
        perlls = {},
        jsonls = {},
        zls = {
            settings = {
                enable_autofix = false,
            },
        },
        typos_lsp = {},
    }

    local cap = cmp_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
    for server, config in pairs(servers) do
        config = config or {}
        config.on_attach = on_attach
        config.capabilities = config.capabilities or cap

        nvim_lsp[server].setup(config)
    end
end

local function setup_mason()
    require('mason-tool-installer').setup {
        ensure_installed = {
            'gopls',
            'rust-analyzer',
            'python-lsp-server',
            'clangd',
            'bash-language-server',
            'dockerfile-language-server',
            'docker-compose-language-service',
            'yaml-language-server',
            'vim-language-server',
            'lua-language-server',
            'json-lsp',
            'zls',
        }
    }
end

local function setup_lspsage()
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

local function setup_python_formatting()
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.black.with({
                command = "black",
                extra_args = {
                    "--fast",
                    "--line-length=120",
                },
            }),
            -- null_ls.builtins.formatting.isort,
        },
    })

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

local function setup_c_postgres_formatting()
    -- TODO: Only create the autocmd if pgindent is available on the system
    -- TODO: Just create this autocmd on postgres source code directory.

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

function lsp.setup()
    set_options()
    setup_servers()
    setup_mason()
    setup_lspsage()
    setup_python_formatting()
    setup_c_postgres_formatting()
end

function lsp.setup_java()
    local home = os.getenv('HOME')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

    local config = {
        cmd = {
            'jdtls',
            '-Xmx8g',
            '-XX:+UseG1GC',
            '-XX:+UseStringDeduplication',
            '-data', workspace_dir
        },
        root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
        on_attach = on_attach,
        settings = {
            java = {
                maxConcurrentBuilds = 2,
                autobuild = false,
                edit = {
                    validateAllOpenBuffersOnChanges = false,
                },
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-22",
                            path = home .. "/.asdf/installs/java/openjdk-22.0.1/",
                        },
                        {
                            name = "JavaSE-17",
                            path = home .. "/.asdf/installs/java/openjdk-17/",
                        },
                    }
                },
                jdt = {
                    ls = {
                        lombokSupport = {
                            enable = false,
                        },
                    },
                },
            }
        },
        init_options = {
            bundles = {
                vim.fn.glob(
                    home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar", 1),
            },
        },
    }
    require('jdtls').start_or_attach(config)
end

return lsp
