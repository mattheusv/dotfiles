call plug#begin()

"*****************************************************************************
"" Basic Plugs
"*****************************************************************************"

" Comment stuff
Plug 'tpope/vim-commentary'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

" Status/tabline
Plug 'itchyny/lightline.vim'

" Display the indention levels
Plug 'Yggdroot/indentLine'

" Fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

"" Color Theme
Plug 'morhetz/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Manage editoconfig files
Plug 'editorconfig/editorconfig-vim'

" Surround parentheses, brackets, quotes, XML tags, and more
Plug 'tpope/vim-surround'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
      !cargo build --release --locked
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" File tree
Plug 'preservim/nerdtree'

" Nice icons
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

"*****************************************************************************
"" Custon Plugs
"*****************************************************************************"

" LSP
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'

" Python
Plug 'tmhedberg/SimpylFold'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

"" Golang
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'sebdah/vim-delve'

" Fish
Plug 'dag/vim-fish'

call plug#end()

lua require('init')
