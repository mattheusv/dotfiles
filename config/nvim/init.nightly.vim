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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

"" Color Theme
Plug 'morhetz/gruvbox'

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

"*****************************************************************************
"" Custon Plugs
"*****************************************************************************"

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" Python
Plug 'tmhedberg/SimpylFold'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

"" Golang
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'sebdah/vim-delve'

call plug#end()


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"

let mapleader=','

set nowrap

set splitbelow
set splitright

set fileformats=unix,dos,mac

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set nowritebackup
set noswapfile

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable load .nvimrc files to specific projects
set exrc
set secure

" Enable nvim copy allways to clipboard
set clipboard+=unnamedplus

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

set mouse=a

" Live Substitution
set inccommand=split

"" Autocmd to fix syntax highlight
"" https://vim.fandom.com/wiki/Fix_syntax_highlighting
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END


"*****************************************************************************
"" Visual Settings
"*****************************************************************************

let g:netrw_banner = 0

set termguicolors

" Line number
set number
set relativenumber

" Highlighting in cursor line
set cursorline

" Visual color
colorscheme gruvbox
set bg=dark

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

" lightline.vim
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] 
      \ ],
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Qall qall
cnoreabbrev D d

"*****************************************************************************
"" Mappings
"*****************************************************************************

" Git Maps
nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gk :!gitk<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Clear highlight
nnoremap <silent> <esc> :noh<return><esc>

"" Split Buffers
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Move between splits
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Move lines
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

"" Close buffer
noremap <leader>c :bp<cr>:bd #<cr>

"" Search for files
nnoremap <c-p> :GFiles<cr>
nnoremap <silent> <leader>q :Buffers<CR>

" Tagbar FZF
nmap <Leader>t :BTags<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>

" Git Gutter Hunks
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

"*****************************************************************************
"" LSP
"*****************************************************************************
let g:diagnostic_insert_delay = 1

inoremap <expr> <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <c-space> completion#trigger_completion()

set completeopt=menuone,noinsert,noselect

lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.rust_analyzer.setup{}
lua require'lspconfig'.jedi_language_server.setup{}
lua require'lspconfig'.tsserver.setup{}

autocmd BufEnter * lua require'completion'.on_attach()

nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> td <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <s-k> <cmd>lua vim.lsp.buf.hover()<CR>
nmap <silent> [g <cmd> lua vim.lsp.diagnostic.goto_prev()<CR>
nmap <silent> ]g <cmd> lua vim.lsp.diagnostic.goto_next()<CR>

command! -nargs=0 Format :lua vim.lsp.buf.formatting_sync(nil, 1000)


"*****************************************************************************
"" Languages Custom configs
"*****************************************************************************

" Python
let python_highlight_all = 1
let g:python3_host_prog = '~/.config/nvim/venv/bin/python3'

" Go
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1
let g:go_rename_command = "gopls"
let g:go_echo_go_info = 0

augroup go
    au!
    au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
    au FileType go nmap <Leader>rt :GoTestFunc<CR>
    au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
    au FileType go nmap <leader>t :GoDecls<CR>
    au FileType go nmap <leader>T :GoDeclsDir<CR>
    au FileType go nnoremap <S-C-K> :GoInfo<CR>
augroup END

" Rust
autocmd BufWrite *.rs : Format

"*****************************************************************************
"" Plugins Custom configs
"*****************************************************************************

"" junegunn/fzf.vim
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

"SimpylFold config
let g:SimpylFold_docstring_preview=1

" vim-markdown-composer
let g:markdown_composer_autostart = 0
