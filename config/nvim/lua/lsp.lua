local nvim_lsp = require('lspconfig')
local completion = require('completion')
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
  local opts = {noremap = true, silent = true}
  local opts_expr = {expr = true, noremap = true, silent = true}

  completion.on_attach(client)

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- FIXME convert to pure lua
  vim.api.nvim_command([[inoremap <expr> <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"]])
  vim.api.nvim_command([[inoremap <expr> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

  -- Mappings.
  buf_set_keymap("i", "<c-space>", "completion#trigger_completion()", opts_expr)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
  buf_set_keymap('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  buf_set_keymap('n', '<leader>ws', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)


  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands and maps to document highlight
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    buf_set_keymap("n", "<space>h", "<Cmd> lua vim.lsp.buf.document_highlight()<CR>", opts)
  end

  vim.api.nvim_command("command! -nargs=0 Format :lua vim.lsp.buf.formatting_sync(nil, 1000)")
  vim.api.nvim_command("command! RestartLSP lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd 'edit'")

  if vim.tbl_contains({"rust"}, filetype) then
    vim.cmd [[autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()]]
  end

  if vim.tbl_contains({"go"}, filetype) then
      setup_vimgo()
  end

end

local function setup_servers()
    local gopls_debug_cfg = {
        -- cmd = {"gopls", "-remote", "localhost:8888"},
    }

    local html_capabilities = vim.lsp.protocol.make_client_capabilities()
    html_capabilities.textDocument.completion.completionItem.snippetSupport = true

    local servers = {
        gopls =  gopls_debug_cfg,
        rust_analyzer = {},
        jedi_language_server = {},
        tsserver = {},
        clangd = {},
        bashls = {},
        dockerls = {},
        html = {capabilities = html_capabilities},
        yamlls = {},
        vimls = {},
        sumneko_lua = {
            cmd = {"lua-language-server"}, -- Installed bin with `paru lua-language-server`
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {"vim"}
                    },
                }
            }
        },
    }
    for server, config in pairs(servers) do
        config = config or {}
        config.on_attach = on_attach

        nvim_lsp[server].setup(config)
    end
end

function lsp.setup()
    set_options()
    setup_servers()
end

return lsp
