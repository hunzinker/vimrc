call pathogen#incubate()
call pathogen#helptags()

syntax on

set encoding=utf-8

set nocompatible

set number

set backspace=2

set nowrap
set sidescroll=10
set textwidth=78
set formatoptions=tcq

set tabstop=4
set shiftwidth=4
set expandtab
set noautoindent
set nosmartindent

if has("mouse")
    set mouse=a
endif

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

set showmode
set showcmd

set hidden

set backupdir=~/.vim_backup
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

set directory=~/.vim_swap
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" statusline setup
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

colorscheme desert

filetype on
filetype plugin on
filetype plugin indent on

" Map <Leader>
let mapleader = ','

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Key mappings
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <F8> :TagbarToggle<CR>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Command-T settings
let g:CommandTMaxHeight = 20

" Tagbar settings
let g:tagbar_width = 30
" autocmd VimEnter * nested :call tagbar#autoopen(1)
" autocmd FileType * nested :call tagbar#autoopen(0)

" NERDstuff
let NERDSpaceDelims=1

" Prevents autocommands from loading twice
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " Set filetype to Ruby for Yaml, Rake
    autocmd BufRead,BufNewFile *.yml,*.rake  set filetype=ruby

    " Set filetype to CSS for Sass
    autocmd BufRead,BufNewFile *.scss   set filetype=css

    " Set filetype for JavaScript
    autocmd BufRead,BufNewFile *.js,*.handlebars  set filetype=javascript

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
