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

colorscheme desert

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

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Command-T settings
let g:CommandTMaxHeight = 20
let g:CommandTCancelMap='<C-x>'

" Tagbar settings
let g:tagbar_width = 30

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

" Prevents autocommands from loading twice
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " Set filetype to Ruby for Yaml, Rake
    autocmd BufRead,BufNewFile *.yml,*.rake  set filetype=ruby

    " Set filetype to CSS for Sass
    autocmd BufRead,BufNewFile *.scss   set filetype=css

    " Set filetype for JavaScript
    autocmd BufRead,BufNewFile *.js,*.handlebars  set filetype=javascript

    " Setup coffeescript
    autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

    " Set filetype for JSON
    autocmd BufRead,BufNewFile *.json  set filetype=json

    " Recalculate the trailing whitespace warning when idle and after saving
    autocmd CursorHold,BufWritePost * unlet! b:statusline_trailing_space_warning
endif

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
