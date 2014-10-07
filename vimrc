set nocompatible

call pathogen#incubate()
call pathogen#helptags()

syntax on

filetype on
filetype plugin on
filetype plugin indent on

set encoding=utf-8

set shellpipe=>

set backspace=indent,eol,start
set sidescroll=10
set textwidth=78
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

" Colors
if $TERM == "xterm-256color" || $TERM == "screen-256color"
    set t_Co=256
endif

" Theme
" ---------------------------------------------------------------------------
colorscheme desert256
set background=dark

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
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>p :PasteToggle<CR>
map <leader>a :Ack<Space>

" Toggle spelling hints
nmap <silent> <leader>ts :set spell!<cr>

" Toggle wrapping in the current buffer
nmap <silent> <leader>wt :set wrap!<cr>

" Remove whitespace - requires trailer trash plugin
nmap <leader><Space> :TrailerTrim<CR>

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
map <silent> \ :silent nohlsearch<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Tagbar settings
let g:tagbar_width=25
let g:tagbar_sort=0

" NERDstuff
let NERDSpaceDelims=1
let NERDTreeWinSize=25
let NERDTreeIgnore=['.DS_Store']

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map={'mode': 'active','passive_filetypes': ['scss', 'sass']}

" SuperTab
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1

" File type utility functions
" ---------------------------------------------------------------------------
" Turn wrapping on for text based languages (markdown, txt...)
function! s:setWrapping()
    setlocal wrap linebreak nolist spell textwidth=72
endfunction

" Hooks for previewing or running .coffee -> .js
function! s:setCoffee()
    set tabstop=2 shiftwidth=2
    map <buffer> <silent><leader>b :CoffeeCompile vertical<cr>
    map <buffer> <silent><leader>d :CoffeeRun<cr>
endfunction

" Filetypes
" ---------------------------------------------------------------------------
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    autocmd BufRead,BufNewFile *.yml,*.rake set filetype=ruby
    autocmd BufRead,BufNewFile *.scss set filetype=scss tabstop=2 shiftwidth=2 textwidth=0
    autocmd BufRead,BufNewFile *.css set tabstop=2 shiftwidth=2 textwidth=0
    autocmd BufRead,BufNewFile *.js,*.handlebars,*.hb,*.us set filetype=javascript
    autocmd BufRead,BufNewFile *.hamlc set filetype=haml
    autocmd BufRead,BufNewFile *.txt call s:setWrapping()
    autocmd BufRead,BufNewFile *.coffee call s:setCoffee()
    autocmd BufRead,BufNewFile *.json  set filetype=json
endif

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
