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
end

local function set_colors()
    vim.o.bg = "dark"
    vim.cmd("colorscheme gruvbox")
end


function nvim_create_autogroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command("augroup END")
  end
end


local function set_autogroups()
    local autocmds = {
      general = {
        {
          "BufEnter",
          "*",
          [[:syntax sync fromstart]],
        },
        {
          "BufReadPost",
          "*",
          [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
        },
        {
            "BufWrite",
            "*.rs",
            [[:Format]],
        },
      },
    }

    nvim_create_autogroups(autocmds)
end


local function configure_statusbar()
    vim.g.lightline = {
        active = {
            left = {{ 'mode', 'paste' }, { 'gitbranch', 'readonly', 'relativepath', 'modified' }}
        },
        right = {{'lineinfo'}, {'percent'}, {'fileformat', 'fileencoding', 'filetype', 'charvaluehex'}},
        component_function = { gitbranch = 'FugitiveHead' }
    }
end

local function configure_telescope_maps()
    local actions = require('telescope.actions')
    require('telescope').setup{
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
    local opts = {noremap = true, silent = true}

    -- Base maps
    vim.api.nvim_set_keymap("n", "<leader>.", [[<Cmd> lcd %:p:h<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<esc>", [[<Cmd> noh<return><esc>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>h", [[<Cmd> split<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>v",  [[<Cmd> vsplit<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<C-k>", [[<C-W>k]], opts)
    vim.api.nvim_set_keymap("n", "<C-j>", [[<C-W>j]], opts)
    vim.api.nvim_set_keymap("n", "<C-h>", [[<C-W>h]], opts)
    vim.api.nvim_set_keymap("n", "<C-l>", [[<C-W>l]], opts)
    vim.api.nvim_set_keymap('x', 'K', [[:move '<-2<CR>gv-gv]], opts)
    vim.api.nvim_set_keymap('x', 'J', [[:move '>+1<CR>gv-gv]], opts)
    vim.api.nvim_set_keymap("v", "<", [[<gv]], opts)
    vim.api.nvim_set_keymap("v", ">", [[>gv]], opts)

    -- Buffer maps
    vim.api.nvim_set_keymap("n", "<leader>c",  [[<Cmd> bp<cr>:bd #<cr>]], opts)
    vim.api.nvim_set_keymap("n", "<c-p>", [[<Cmd> lua require('telescope.builtin').git_files({show_untracked=false})<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>rg", [[<Cmd> lua require('telescope.builtin').live_grep()<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>q", [[<Cmd> lua require('telescope.builtin').buffers()<CR>]], opts)
    configure_telescope_maps()

    -- Git maps
    vim.api.nvim_set_keymap("n", "<leader>gs", [[<Cmd> G<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>gd", [[<Cmd> Gdiffsplit<CR>]], opts)
    vim.api.nvim_set_keymap("n", "<leader>gk", [[<Cmd> !gitk<CR>]], opts)
    vim.api.nvim_set_keymap("n", "]h", [[<Cmd> GitGutterNextHunk<CR>]], opts)
    vim.api.nvim_set_keymap("n", "[h",  [[<Cmd> GitGutterPrevHunk<CR>]], opts)
end

local function configure_commands()
    vim.api.nvim_command("command! CopyBuffer let @+ = expand('%:s')")
end

local function configure_treesitter()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
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
end

return editor
