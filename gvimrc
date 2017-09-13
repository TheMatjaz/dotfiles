" -----------------------------------------------------------------------------
" Matjaž's dotfiles Vim GUI configuration file
"
" Copyright (c) 2015-2017, Matjaž Guštin <dev@matjaz.it> matjaz.it
" This source code form is part of the "Matjaž's dotfiles" project and is 
" subject to the terms of the BSD 3-clause license as expressed in the 
" LICENSE.md file found in the top-level directory of this distribution and at
" http://directory.fsf.org/wiki/License:BSD_3Clause
" -----------------------------------------------------------------------------


" Text appearance -------------------------------------------------------------

" Text font.
" The fonts are tried in a sequence. The first one found will be used.
set guifont=Source\ Code\ Pro:h10,Menlo:h10,Inconsolata:h10,Consolas:h10

" Font size quick change.
if has("unix")
    function! FontSizePlus ()
      let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endfunction

    function! FontSizeMinus ()
      let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endfunction
else
    function! FontSizePlus ()
      let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
    endfunction

    function! FontSizeMinus ()
      let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
    endfunction
endif

if has("gui_running")
    nmap <S-F12> :call FontSizeMinus()<CR>
    nmap <F12> :call FontSizePlus()<CR>
endif



" Window ----------------------------------------------------------------------

" Increase size of GUI window as much as possible.
set lines=999 columns=999

" Maximize the GUI window on Windows.
" Note, the ~x works on Windows when the system language is English and may
" not work with different languages.
if has("win32")
    autocmd GUIEnter * simalt ~x
endif
