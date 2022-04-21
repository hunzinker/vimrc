if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'universal-ctags/ctags'
Plug 'cohama/lexima.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-obsession'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rakr/vim-one'
Plug 'derekwyatt/vim-scala'
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'airblade/vim-gitgutter'

" Remove coc
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
set tabstop=2
set shiftwidth=2
set expandtab
set noautoindent
set nosmartindent
set wildmenu
set wildmode=list:longest
set completeopt=longest,menu
set pumheight=20
set ttimeoutlen=300

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

" Commands
com! FormatJSON %!jq '.'

" Key mappings
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>p :PasteToggle<CR>
nmap <leader>l :LongLines<CR>
nmap <leader>f :FZF<CR>
nmap <leader>F :FZF!<CR>
nmap <leader>a :Rg<Space>

" Formatting
nmap =j :FormatJSON<CR>

" Toggle spelling hints
nmap <silent> <leader>ts :set spell!<CR>

" Toggle wrapping in the current buffer
nmap <silent> <leader>wt :set wrap!<CR>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Clear the search highlight
map <silent> \ :silent nohlsearch<CR>

" Ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-Up> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-Down> <Plug>(ale_next_wrap)

"""""""""""
" CoC
"""""""""""


"""""""""""
" End CoC
"""""""""""

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" Remove file
command! -complete=file -nargs=1 Remove :echo 'Remove: '.'<f-args>'.' '.(delete(<f-args>) == 0 ? 'Deleted!' : 'Delete failed')

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

" NERDstuff
let NERDSpaceDelims=1
let NERDTreeWinSize=25
let NERDTreeIgnore=['.DS_Store']

" Ag + fzf
" let g:ackprg = 'ag --nogroup --nocolor --column'
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--color-path="0;33"', <bang>0)

" Airline
let g:airline#extensions#ale#enabled = 1
let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''+Obs'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])

" Ale
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_sign_column_always = 1

" Filetypes
" ---------------------------------------------------------------------------
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    au BufRead,BufNewFile *.rake set ft=ruby
    au BufRead,BufNewFile *.scss set ft=scss ts=2 sw=2 tw=0
    au BufRead,BufNewFile *.css set ts=2 sw=2 tw=0
    au BufRead,BufNewFile *.js,*.handlebars,*.hb,*.us set ft=javascript
    au BufRead,BufNewFile *.txt,*.md call SetWrapping()
    au BufRead,BufNewFile *.json  set ft=json
    au BufRead,BufNewFile *.yaml,*.yml set ft=yaml ts=2 sw=2
    au BufRead,BufNewFile *.sql,*.psql set ft=sql ts=2 sw=2
    au BufRead,BufNewFile *.sbt set ft=scala
    au BufRead,BufNewFile *Jenkinsfile* set ft=groovy ts=2 sw=2

endif

autocmd FileType json syntax match Comment +\/\/.\+$+

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
