call plug#begin()

"*****************************************************************************
"" Basic Plugs
"*****************************************************************************"

" NERDTree
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'

" Comment stuff
Plug 'tpope/vim-commentary'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

" Status/tabline
Plug 'itchyny/lightline.vim'

" Search tool
Plug 'vim-scripts/grep.vim'

" Display the indention levels
Plug 'Yggdroot/indentLine'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

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
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

"SimpylFold config
let g:SimpylFold_docstring_preview=1

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

nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Clear highlight
nnoremap <silent> <esc> :noh<return><esc>

" Delete lines without copy
noremap <S-d> "_d

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

""Split Terminal
nnoremap <leader>th :terminal<CR>
nnoremap <leader>tv :vertical terminal<CR>

"" Tabs
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>x :bn<CR>

"" Close buffer
noremap <leader>c :bp<cr>:bd #<cr>

"" Search for files
nnoremap <c-p> :Files<cr>
nnoremap <silent> <leader>b :Buffers<CR>

" Enable folding with the leader + spacebar
nnoremap <leader><space> za

"NERDTree
nnoremap <C-g> :NERDTreeFind<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nmap <silent> <F5> :NERDTreeRefreshRoot<CR>

"grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>

" Tagbar FZF
nmap <Leader>t :BTags<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>

" Git Gutter Hunks
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

"*****************************************************************************
"" coc.nvim Mappings
"*****************************************************************************

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" coc snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" coc.nvim keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for format selected region
xmap <leader>i  <Plug>(coc-format-selected)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>

" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" Use K to show documentation in preview window
nnoremap <silent> <S-K> :call <SID>show_documentation()<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]g <Plug>(coc-diagnostic-next-error)

"*****************************************************************************
"" coc.nvim configuration
"*****************************************************************************"

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

let g:coc_snippet_next = '<s-tab>'

" Global extensions
let g:coc_global_extensions = [
    \ "coc-prettier",
    \ "coc-json",
    \ "coc-python",
    \ "coc-snippets",
    \ "coc-yaml",
    \ "coc-tsserver",
    \ "coc-tslint-plugin",
    \ "coc-html",
    \ "coc-rls",
\]

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"*****************************************************************************
"" coc.nvim Functions
"*****************************************************************************

" coc check back space for auto completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" coc show documentation func
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"*****************************************************************************
"" Languages Custom configs
"*****************************************************************************

" Python
let python_highlight_all = 1
let g:python3_host_prog = '~/.config/nvim/venv/bin/python3'

" go
" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:syntastic_go_checkers = ['golint', 'govet']
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
let g:syntastic_go_checkers = ['go']

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <leader>t :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END

"*****************************************************************************
"" Plugins Custom configs
"*****************************************************************************


"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"" vim-scripts/grep.vim
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules venv'

"" junegunn/fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
set grepprg=ag\ --nogroup\ --nocolor
