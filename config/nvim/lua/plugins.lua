-- function! BuildComposer(info)
--   if a:info.status != 'unchanged' || a:info.force
--       !cargo build --release --locked
--   endif
-- endfunction

local vim = vim
local function plug(path, config)
  vim.validate {
    path = {path, 's'};
    config = {config, vim.tbl_islist, 'an array of packages'};
  }
  vim.fn["plug#begin"](path)

  for _, v in ipairs(config) do
    if type(v) == 'string' then
      vim.fn["plug#"](v)
    elseif type(v) == 'table' then
      local p = v[1]
      assert(p, 'Must specify package as first index.')
      v[1] = nil
      vim.fn["plug#"](p, v)
      v[1] = p
    end
  end
  vim.fn["plug#end"]()
end

plug(tostring(os.getenv("HOME")) .. '/.config/nvim/plugged', {
    -- Comment stuff
    'tpope/vim-commentary',

    -- Git integration
    'tpope/vim-fugitive',
    'airblade/vim-gitgutter',
    'rhysd/git-messenger.vim',

    -- Status/tabline
    'itchyny/lightline.vim',

    -- Display the indention levels
    'Yggdroot/indentLine',

    -- Fuzzy finder
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',

    --" Color Theme
    'morhetz/gruvbox',
    -- {'nvim-treesitter/nvim-treesitter'; do= ':TSUpdate'},

    'preservim/nerdtree',
    'ryanoasis/vim-devicons',
    'kyazdani42/nvim-web-devicons',

    -- Manage editoconfig files
    'editorconfig/editorconfig-vim',

    -- Surround parentheses, brackets, quotes, XML tags, and more
    'tpope/vim-surround',

    -- {'euclio/vim-markdown-composer'; do= function('BuildComposer') },

    --*****************************************************************************
    --" Custon Plugs
    --*****************************************************************************"

    -- LSP
    'neovim/nvim-lspconfig',
    'nvim-lua/completion-nvim',

    -- Python
    'tmhedberg/SimpylFold',
    -- 'raimon49/requirements.txt.vim', {'for': 'requirements'},

    --" Golang
    -- 'fatih/vim-go', {'do': ':GoInstallBinaries'},
    'sebdah/vim-delve',

    -- Fish
    'dag/vim-fish',


})

--
-- local packer_exists = pcall(vim.cmd, [[ packadd packer.nvim ]])
-- if not packer_exists then
--   local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
--   local repo_url = "https://github.com/wbthomason/packer.nvim"

--   vim.fn.mkdir(dest, "p")

--   print("Downloading packer")
--   vim.fn.system(string.format("git clone %s %s", repo_url, dest .. "packer.nvim"))
--   vim.cmd([[packadd packer.nvim]])
--   vim.cmd("PackerSync")
--   print("packer.nvim installed")
-- end

-- -- vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile ]])

-- return require('packer').startup(function(use)
--     -- Basic plugins
--     use {'wbthomason/packer.nvim', opt = true}
--     use {'tpope/vim-commentary'}
--     use {'tpope/vim-fugitive'}
--     use {'airblade/vim-gitgutter'}
--     use {'rhysd/git-messenger.vim'}
--     use {'itchyny/lightline.vim'}
--     use {'Yggdroot/indentLine'}
--     use { 'nvim-telescope/telescope.nvim',
--         requires = {
--             {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-fzy-native.nvim'}
--         },
--     }

--     -- use {'morhetz/gruvbox'} -- FIXME using with packer make colors not working correctly
--     use {'tjdevries/gruvbuddy.nvim', requires = {'tjdevries/colorbuddy.vim'}}

--     use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
--     use {'editorconfig/editorconfig-vim'}
--     use {'tpope/vim-surround'}
--     use {'euclio/vim-markdown-composer'} -- TODO add first cargo build

--     -- Development plugins
--     use {'neovim/nvim-lspconfig'}
--     use {'nvim-lua/completion-nvim'}
--     use {'tmhedberg/SimpylFold'}
--     use {'fatih/vim-go', run = ':GoInstallBinaries'}
--     use {'sebdah/vim-delve'}
-- end)
