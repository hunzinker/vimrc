"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Script
" Ken Seal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" finish if the filetype was detected
if did_filetype()
    finish
endif

" Ruby and python scripts without .rb and .py extensions
" need special attention. Read the first line of the file
" to set the filetype.
"
" Ruby & Python ftplugins
" setlocal shiftwidth=2
" setlocal tabstop=2
if getline(1) =~ '^#!.*ruby'
    setfiletype ruby
elseif getline(1) =~ '^#!.*python'
    setfiletype python
endif

