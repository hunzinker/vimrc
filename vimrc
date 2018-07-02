if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'cohama/lexima.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'csexton/trailertrash.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-endwise'
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim'
Plug 'derekwyatt/vim-scala'

call plug#end()

set nocompatible

syntax on

filetype on
filetype plugin on
filetype plugin indent on

set encoding=utf-8

set shellpipe=>

set backspace=indent,eol,start
set sidescroll=10
set textwidth=79
set tabstop=4
set shiftwidth=4
set expandtab
set noautoindent
set nosmartindent
set wildmenu
set wildmode=list:longest
set completeopt=longest,menu
set pumheight=20

" Buffers
set hidden
set clipboard=unnamed
set wildignore+=*.DS_Store
set splitbelow splitright

" Searching
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" UI
set formatoptions=tcq
set showmode
set showcmd
set number
set nowrap
set scrolloff=3
set sidescrolloff=3
set ruler
set nostartofline
set noerrorbells
set novisualbell
set ttyfast
set laststatus=2
set foldlevelstart=0
set foldmethod=marker
set formatoptions=tcq

" Backups
set history=1000
set undolevels=1000
set backupdir=~/.vim/backup

if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

set directory=~/.vim/swap
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Mouse
if has("mouse")
    set mouse=a
endif

if !has("nvim")
    set ttymouse=xterm2
endif

" Colors
if $TERM == "xterm-256color" || $TERM == "screen-256color"
    set t_Co=256
endif

" Cursor
let &t_SI = "\e[5 q"
let &t_EI = "\e[0 q"


" Theme
" ---------------------------------------------------------------------------
colorscheme one
set background=dark
let g:airline_theme="one"

call one#highlight('Pmenu', 'cccccc', '', 'none')
call one#highlight('PmenuSel', '3e4452', '', 'none')

if has("nvim")
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Map <Leader>
let mapleader = ','

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Key mappings
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>] :TagbarToggle<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>e :NERDTreeFind<CR>
nmap <leader>d :EnDeclarationSplit v<CR>
nmap <leader>t :EnTypeCheck<CR>
nmap <leader>b :EnDocBrowser<CR>
nmap <leader>p :PasteToggle<CR>
nmap <leader>l :LongLines<CR>
nmap <leader>f :CtrlP<CR>
nmap <leader>a :Ack<Space>
nmap <leader>t= :Tabularize /=<CR>
vmap <leader>t= :Tabularize /=<CR>
nmap <leader>t: :Tabularize /:\zs<CR>
vmap <leader>t: :Tabularize /:\zs<CR>

" Toggle spelling hints
nmap <silent> <leader>ts :set spell!<CR>

" Toggle wrapping in the current buffer
nmap <silent> <leader>wt :set wrap!<CR>

" Remove whitespace - requires trailer trash plugin
nmap <leader><space> :TrailerTrim<CR>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Block movement
nmap <tab> %
vmap <tab> %

" Bubble single lines
nmap <C-Up> ]e
nmap <C-Down> [e

" Bubble multiple lines in visual mode
vmap <C-Up> ]egv
vmap <C-Down> [egv

" Clear the search highlight
map <silent> \ :silent nohlsearch<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Emacs style command line bindings
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <Esc><C-B> <S-Left>
cnoremap <Esc><C-F> <S-Right>

" Tagbar settings
let g:tagbar_width=25
let g:tagbar_sort=0

" NERDstuff
let NERDSpaceDelims=1
let NERDTreeWinSize=25
let NERDTreeIgnore=['.DS_Store']

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map={'mode': 'active','passive_filetypes':['scss','sass']}
let g:syntastic_yaml_checkers = ['yamllint']

" SuperTab
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1

" Ag
let g:ackprg = 'ag --nogroup --nocolor --column'

" Filetypes
" ---------------------------------------------------------------------------
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    au BufRead,BufNewFile *.rake set filetype=ruby
    au BufRead,BufNewFile *.scss set filetype=scss tabstop=2 shiftwidth=2 tw=0
    au BufRead,BufNewFile *.css set tabstop=2 shiftwidth=2 tw=0
    au BufRead,BufNewFile *.js,*.handlebars,*.hb,*.us set filetype=javascript
    au BufRead,BufNewFile *.txt,*.md call SetWrapping()
    au BufRead,BufNewFile *.json  set filetype=json
    au BufRead,BufNewFile *.yaml,*.yml set filetype=yaml tabstop=2 shiftwidth=2

endif

" File type utility functions
" ---------------------------------------------------------------------------
" Turn wrapping on for text based languages (markdown, txt...)
function! SetWrapping()
    setlocal wrap linebreak nolist spell
endfunction

" Toggle paste
" ---------------------------------------------------------------------------
function! TogglePaste()
    if &paste
        :set nopaste
    else
        :set paste
    endif
endfunction
command! -bar PasteToggle :call TogglePaste()

" Toggle Highlight Long Lines
" ----------------------------------------------------------------------------
function! ToggleLongLineHighlight()
    if exists('w:long_line_match')
      silent! call matchdelete(w:long_line_match)
      unlet w:long_line_match
    elseif &textwidth > 0
      let w:long_line_match = matchadd('Search', '\%>'.&tw.'v.\+', -1)
    else
      let w:long_line_match = matchadd('Search', '\%>80v.\+', -1)
    endif
endfunction
command! -bar LongLines :call ToggleLongLineHighlight()
