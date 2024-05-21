require("neoconf").setup({})

local editor = {}

local function set_globals()
    vim.g.mapleader = ","
    vim.g.netrw_banner = false
    vim.g.nowrap = true
    vim.g.diagnostic_insert_delay = true
    vim.g.nobackup = true
    vim.g.nowritebackup = true
    vim.g.noswapfile = true
    vim.g.python3_host_prog = '~/.config/nvim/venv/bin/python3'
    vim.g.markdown_fenced_languages = { 'go', 'rust', 'python', 'vim' }

    -- Plugins options
    vim.g.SimpylFold_docstring_preview = true

    vim.g.markdown_composer_autostart = false

    vim.g.python_highlight_all = true

    vim.g.indentLine_enabled = 1
    vim.g.indentLine_concealcursor = 0
    vim.g.indentLine_char = '┆'
    vim.g.indentLine_faster = 1
end

local function set_options()
    -- Basic setup
    vim.o.splitbelow = true
    vim.o.splitright = true
    vim.o.fileformats = "unix,dos,mac"

    vim.o.tabstop = 4
    vim.o.softtabstop = 0
    vim.o.shiftwidth = 4
    vim.o.swapfile = false
    -- Buffer options (I dont' know why works different)
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 0
    vim.bo.shiftwidth = 4
    vim.bo.swapfile = false

    vim.o.expandtab = true
    vim.o.hidden = true
    vim.o.hlsearch = true
    vim.o.incsearch = true
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.o.backup = false
    vim.o.writebackup = false
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    vim.o.foldmethod = "indent"
    vim.o.foldlevel = 99
    vim.o.exrc = true
    vim.o.secure = true
    vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
    vim.o.cmdheight = 2
    vim.o.updatetime = 300
    vim.o.shortmess = vim.o.shortmess .. "c"
    vim.o.mouse = "a"
    vim.o.inccommand = "split"

    -- Visual options
    vim.o.termguicolors = true
    vim.o.cursorline = true
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.o.colorcolumn = "120"
end

local function set_abbreviations()
    -- TODO find a better way to do this
    vim.api.nvim_command("cnoreabbrev W! w!")
    vim.api.nvim_command("cnoreabbrev Q! q!")
    vim.api.nvim_command("cnoreabbrev Qall! qall!")
    vim.api.nvim_command("cnoreabbrev Wq wq")
    vim.api.nvim_command("cnoreabbrev Wa wa")
    vim.api.nvim_command("cnoreabbrev wQ wq")
    vim.api.nvim_command("cnoreabbrev WQ wq")
    vim.api.nvim_command("cnoreabbrev W w")
    vim.api.nvim_command("cnoreabbrev Q q")
    vim.api.nvim_command("cnoreabbrev Qa qa")
    vim.api.nvim_command("cnoreabbrev Qall qall")
    vim.api.nvim_command("cnoreabbrev D d")
    vim.api.nvim_command("cnoreabbrev X x")
end

local function set_colors()
    vim.o.bg = "dark"
    vim.cmd("colorscheme couleurs")
end

local function set_autogroups()
    local group = vim.api.nvim_create_augroup("my_autogroup", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "*",
        callback = function()
            vim.api.nvim_command(":syntax sync fromstart")
        end
    })
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = group,
        pattern = "*",
        callback = function()
            vim.api.nvim_command([[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
        end
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown,gitcommit",
        callback = function()
            vim.o.spell = true
        end
    })
end

local function configure_statusbar()
    vim.g.lightline = {
        active = {
            left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'relativepath', 'modified' } }
        },
        right = { { 'lineinfo' }, { 'percent' }, { 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' } },
        component_function = { gitbranch = 'FugitiveHead' }
    }
end

local function configure_telescope_maps()
    local actions = require('telescope.actions')
    require('telescope').setup {
        defaults = {
            file_sorter = require('telescope.sorters').get_fzy_sorter,
            mappings = {
                i = {
                    ["<c-j>"] = actions.move_selection_next,
                    ["<c-k>"] = actions.move_selection_previous,
                    ["<esc>"] = actions.close,
                },
            },
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true,
            }
        }
    }
    require('telescope').load_extension('fzy_native')
end

local function configure_maps()
    local opts = { noremap = true, silent = true }

    -- Base maps
    vim.api.nvim_set_keymap("n", "<leader>.", [[<Cmd> lcd %:p:h<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<esc>", [[<Cmd> noh<return><esc>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>h", [[<Cmd> split<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>v", [[<Cmd> vsplit<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<C-k>", [[<C-W>k]], opts)
    vim.api.nvim_set_keymap("n", "<C-j>", [[<C-W>j]], opts)
    vim.api.nvim_set_keymap("n", "<C-h>", [[<C-W>h]], opts)
    vim.api.nvim_set_keymap("n", "<C-l>", [[<C-W>l]], opts)
    vim.api.nvim_set_keymap('x', 'K', [[:move '<-2<CR>gv-gv]], opts)
    vim.api.nvim_set_keymap('x', 'J', [[:move '>+1<CR>gv-gv]], opts)
    vim.api.nvim_set_keymap("v", "<", [[<gv]], opts)
    vim.api.nvim_set_keymap("v", ">", [[>gv]], opts)
    vim.api.nvim_set_keymap("i", "<c-l>", [[<Cmd> tabnext<CR>]], opts)
    vim.api.nvim_set_keymap("i", "<c-h>", [[<Cmd> tabprevious<CR>]], opts)

    -- Buffer maps
    vim.api.nvim_set_keymap("n", "<leader>c", [[<Cmd> bp<cr>:bd #<cr>]], opts)
    if vim.fn.isdirectory('.git') ~= 0 then
        vim.api.nvim_set_keymap("n", "<c-p>",
            [[<Cmd> lua require('telescope.builtin').git_files({show_untracked=false})<CR>]], opts)
    else
        vim.api.nvim_set_keymap("n", "<c-p>", [[<Cmd> lua require('telescope.builtin').find_files()<CR>]], opts)
    end
    vim.api.nvim_set_keymap("n", "<leader>rg", [[<Cmd> lua require('telescope.builtin').live_grep()<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>q", [[<Cmd> lua require('telescope.builtin').buffers()<CR>]], opts)
    configure_telescope_maps()

    -- Tree maps
    vim.api.nvim_set_keymap("n", "<C-b>", [[:NERDTreeFind<CR>]], opts)
    vim.g.NERDTreeWinPos = "right"

    -- Git maps
    vim.api.nvim_set_keymap("n", "]h", [[<Cmd> GitGutterNextHunk<CR>]], opts)
    vim.api.nvim_set_keymap("n", "[h", [[<Cmd> GitGutterPrevHunk<CR>]], opts)

    -- File manager maps
    vim.api.nvim_set_keymap("n", "<F5>", [[<Cmd> NERDTreeRefreshRoot<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<C-t>", [[<Cmd> NERDTreeMapOpenInTab<CR>]], opts)

    -- telekasten notes maps
    vim.api.nvim_set_keymap("n", "<C-n>", [[<Cmd> lua require('telekasten').panel()<CR>]], opts)
end

local function configure_commands()
    vim.api.nvim_command("command! CopyBuffer execute('lua Copy_buffer()')")
    vim.api.nvim_command("command! CopyPkg let @+ = expand('%:h')")
    vim.api.nvim_command("command! CopyFile let @+ = expand('%')")
    vim.api.nvim_command("command! SaveSession :mksession! session.vim")
    vim.api.nvim_command("command! OpenSession :source session.vim")
    vim.api.nvim_command("command! Cb :up | %bd | e#")
    vim.api.nvim_command("command! LspDisableFormatting execute('lua lsp_disable_formatting()')")
end

function Copy_buffer()
    local line = vim.fn.line('.')
    local file = vim.fn.expand('%')
    vim.fn.setreg("+", string.format("%s:%s", file, line))
end

function lsp_disable_formatting()
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("Formatting", { clear = true }),
        callback = function()
        end
    })
end

local function configure_treesitter()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
            "c",
            "cpp",
            "lua",
            "rust",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "javascript",
            "typescript",
            "fish",
            "comment",
            "dockerfile",
            "sql",
            "toml",
            "java",
        },
        highlight = {
            enable = true,
        },
    }
end

function editor.setup()
    set_globals()
    set_options()
    set_abbreviations()
    set_autogroups()
    set_colors()
    configure_statusbar()
    configure_maps()
    configure_treesitter()
    configure_commands()

    require('telekasten').setup({
        home = vim.fn.expand("~/notes"),
    })
end

return editor
