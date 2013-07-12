set nocompatible

call pathogen#incubate()
call pathogen#helptags()

syntax on

filetype on
filetype plugin on
filetype plugin indent on

set encoding=utf-8

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
set backupdir=~/.vim_backup

if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

set directory=~/.vim_swap
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

if has("mouse")
    set mouse=a
endif

" Statusline ----------------------------------------------------------------
set statusline=%f

" Display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      " help file flag
set statusline+=%y      " filetype
set statusline+=%r      " read only flag
set statusline+=%m      " modified flag

set statusline+=%{fugitive#statusline()}

" Display a warning if the file has trailing whitespace
set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

" Display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      " left/right separator
set statusline+=%c,     " cursor column
set statusline+=%l/%L   " cursor line/total lines
set statusline+=\ %P    " percent through file
set laststatus=2
" End Statusline ------------------------------------------------------------

" Theme
" ---------------------------------------------------------------------------
colorscheme desert
set background=dark

" Map <Leader>
let mapleader = ','

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Key mappings
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap T :TagbarToggle<CR>
nmap N :NERDTreeToggle<CR>

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

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Command-T settings
let g:CommandTMaxHeight = 20
let g:CommandTCancelMap='<C-x>'

" Tagbar settings
let g:tagbar_width = 30
let g:tagbar_sort=0

" NERDstuff
let NERDSpaceDelims=1
let NERDTreeWinSize=35
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

" Wrap markdown and compile on save using the markdown preview bundle
function! s:setMarkdown()
    call s:setWrapping()
    autocmd! BufWritePost *.{md,markdown,mdown,mkd,mkdn} :MDP
endfunction

" Hooks for previewing or running .coffee -> .js
function! s:setCoffee()
    map <buffer> <silent><leader>b :CoffeeCompile vertical<cr>
    map <buffer> <silent><leader>d :CoffeeRun<cr>
endfunction

" Filetypes
" ---------------------------------------------------------------------------
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    autocmd BufRead,BufNewFile *.yml,*.rake set filetype=ruby
    autocmd BufRead,BufNewFile *.scss set filetype=css
    autocmd BufRead,BufNewFile *.js,*.handlebars set filetype=javascript
    autocmd BufRead,BufNewFile *.hamlc set filetype=haml
    autocmd BufRead,BufNewFile *.txt call s:setWrapping()
    autocmd BufRead,BufNewFile *.coffee call s:setCoffee()
    autocmd BufRead,BufNewFile *.json  set filetype=json

    " Recalculate the trailing whitespace warning when idle and after saving
    autocmd CursorHold,BufWritePost * unlet! b:statusline_trailing_space_warning
endif

" Detect trailing whitespace
" ---------------------------------------------------------------------------
" Return '[\s]' if trailing white space is detected
" Return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction
