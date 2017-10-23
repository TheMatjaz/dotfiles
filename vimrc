" -----------------------------------------------------------------------------
" Matjaž's dotfiles Vim configuration file
"
" Copyright (c) 2015-2017, Matjaž Guštin <dev@matjaz.it> matjaz.it
" This source code form is part of the "Matjaž's dotfiles" project and is 
" subject to the terms of the BSD 3-clause license as expressed in the 
" LICENSE.md file found in the top-level directory of this distribution and at
" http://directory.fsf.org/wiki/License:BSD_3Clause
" -----------------------------------------------------------------------------


" EOL characters and encodings ------------------------------------------------

" Configure the end of line (EOL) characters to be tried when opening a file
" to the sequence '\n', '\r\n', '\r'. If the first does not work, the next
" in the list is tried and so on.
" The same order is also used for writing files, i.e. it uses '\n'
" when saving a file.
set fileformats =unix,dos,mac

" Encoding of the characters for the current buffer. Only display and
" and manipulation, not saving of the file.
set encoding =UTF-8

" Encoding of the characters used for Vimscripts, including vimrc and gvimrc.
" Has to be places after 'set encoding='.
scriptencoding UTF-8

" Encoding of the file when saved.
set fileencoding =UTF-8

" List of encodings considered when opening an existing file.
" They are tried in sequence. If an error is detected, the next encoding is
" tried.
" Starting with the most standard options, then some used but not smart ones.
set fileencodings =
set fileencodings +=UTF-8
set fileencodings +=UTF-16le
set fileencodings +=UTF-16be
set fileencodings +=UTF-32le
set fileencodings +=UTF-32be
set fileencodings +=ISO-8859-1
set fileencodings +=Windows-1252



" Opening files ---------------------------------------------------------------

" On startup, set the home directory as the working one. With this setting,
" when opening a file or saving a file right after Vim starts, the search
" starts in the home directory.
cd ~

" Set working directory to the same directory the currently edited file is in.
set autochdir

" Ignore files matching these patterns when opening files based on a 
" glob pattern.
set wildignore +=*.pyc  " Python bytecode
set wildignore +=*.swp  " Vim swap files
set wildignore +=*.bak  " Generic backup files
set wildignore +=*.class  " Java bytecode
set wildignore +=.DS_Store  " macOS folder metadata

" Maximum number of tab pages that can be opened from the command line.
set tabpagemax =50



" Indentation -----------------------------------------------------------------

" Inherit indentation from pervious line when starting writing in a new line.
set autoindent

" Autoindenting (de)activation switch for pasting.
" Vim does not distinguish a paste from typed text, so the autoindentation 
" could be deactivated with this key stroke, the text could be pasted and
" the autoindentation reactivated with the same key stroke.
set pastetoggle=<F2>

" Enable filetype-specific indentation rules.
filetype indent on

" Convert tabs to spaces when typed. Spaces are better to define a strict 
" 80-columns rule.
set expandtab

" Amount of spaces a tab is equivalent to. This variable is used to set all
" other tab-to-spaces settings that follow.
let tabsize = 4

" Number of visual spaces per tab.
execute "set tabstop =" . tabsize

"Insert tabstop number of spaces when the tab key is pressed.
set smarttab 

" Number of spaces in tab when shifting text by a tab.
execute "set shiftwidth =" . tabsize
execute "set softtabstop =" . tabsize

" When shifting lines, round the indentation to the nearest multiple of 
" shiftwidth.
set shiftround



" Whitespace characters display -----------------------------------------------

" Show soft wraping of the line with this string to indicate
" a visual continuation on the next line.
" Note: a space is the last character in the string.
set showbreak =↪\ 

" Show whitespace characters with the following characters instead.
set list
set listchars =
set listchars +=tab:⇥\ 
set listchars +=extends:›
set listchars +=precedes:‹
set listchars +=nbsp:␣
set listchars +=trail:•
set listchars +=eol:↲

" Set the color the whitespace characters are shown.
" NonText is used for "eol", "extends" and "precedes".
highlight NonText term=bold ctermfg=lightgray gui=bold guifg=lightgray

" SpecialKey is used for "nbsp", "tab" and "trail".
highlight SpecialKey term=bold ctermfg=lightgray gui=bold guifg=lightgray



" Autosaving and on-save operations -------------------------------------------

" Remove all trailing whitespace in each line on save.
" The exception is trailed escaped spaces "\ ", which are kept.
" So a line like "helloo \      " becomes "helloo \ "
autocmd BufWritePre * %s/(?<!\\)\s+$//e

" Remove lines with only whitespace at end of file on save.
autocmd BufWritePre * %s/\($\r?\n\s*\)\+\%$//e

" Autosave files when no operation is done for some time.
" When the cursor does not do anything for 'updatetime' milliseconds,
" an 'update' command is issued, which saves the buffers only
" if they have been modified. The CursorHoldI makes the same operation happen
" also in insert mode.
set updatetime =5000
autocmd CursorHold,CursorHoldI * silent write

" Automatically reload files when modified by an external source (not by Vim).
set autoread

" Display a confirmation dialog when closing an unsaved file.
set confirm



" Autorestore session ---------------------------------------------------------

" Return the path of the session file based on the OS.
" Used in the SaveSession and RestoreSession functions.
function! SessionFilePath()
    if has("win32")
        return "$HOME/_vim/session.vim"
    elseif has("unix")
        return "$HOME/.vim/session.vim"
    else
        echoerr "Unknown operating system. Could not set backup location."
    endif
endfunction

" Save the session in the home dotfile folder of Vim.
function! SaveSession()
    execute "mksession! " . SessionFilePath()
endfunction

" Restore the session created with SaveSession()
function! RestoreSession()
    if filereadable(SessionFilePath())
        execute "source " . SessionFilePath()
        if bufexists(1)
            for l in range(1, bufnr('$'))
                if bufwinnr(l) == -1
                    execute 'sbuffer ' . l
                endif
            endfor
        endif
    endif
endfunction

" Autosave the session when closing Vim.
autocmd VimLeave * call SaveSession()

" Auto load the session when entering Vim.
" TODO: why VimLeavePre??
autocmd BufEnter,VimLeavePre * call RestoreSession()



" Backup files ----------------------------------------------------------------

" Backup automatically files into the tmp directory instead of in the same
" folder as the original file as 'filename~'.
" Taken from https://superuser.com/a/193638
if has("win32")
    if isdirectory("$HOME/_vim/swap") == 0
      :silent !md "$HOME/_vim/swap"
    endif
    if isdirectory("$HOME/_vim/undo") == 0
      :silent !md "$HOME/_vim/undo"
    endif
    if isdirectory("$HOME/_vim/backup") == 0
      :silent !md "$HOME/_vim/backup"
    endif
    set directory ="$HOME/_vim/swap//"
    set undodir ="$HOME/_vim/undo//"
    set backupdir ="$HOME/_vim/backup//"
    " Make a backup before overwriting a file. 
    " The backup is removed after the file was successfully written.
    set writebackup
elseif has("unix")
    " Generic Unix settings
    :silent !mkdir -p "$HOME/.vim/swap" > /dev/null 2>&1
    :silent !mkdir -p "$HOME/.vim/undo" > /dev/null 2>&1
    :silent !mkdir -p "$HOME/.vim/backup" > /dev/null 2>&1
    set directory ="$HOME/.vim/swap//"
    set undodir ="$HOME/.vim/undo//"
    set backupdir ="$HOME/.vim/backup//"
    " Make a backup before overwriting a file. 
    " The backup is removed after the file was successfully written.
    set writebackup
else
    echoerr "Unknown operating system. Could not set backup location."
endif

" Alternatively, to fully deactivate backup and swap files, use the
" following commands.
"set nobackup
"set noswap


" Interactivity ---------------------------------------------------------------

" Visual line navigation.
" When a line is soft-wrapped, Vim by default won't let you move down one line
" to the wrapped portion. This option allows doing so.
noremap j gj
noremap k gk

" Moar commands and search history remembered.
set history =500

" Moar chances to call an undo when required.
set undolevels =500

" Leave Insert mode after 15 seconds of inactivity.
"autocmd CursorHoldI * stopinsert autocmd InsertEnter * let updaterestore=&updatetime | set updatetime =15000 autocmd InsertLeave * let &updatetime=updaterestore

" Enable mouse support for scrolling and resizing.
set mouse =a

" Context menu when right-clicking.
set mousemodel =popup

" Middle-click paste.
noremap! <s-insert> <middlemouse>

" The shell used to execute commands.
set shell =/bin/bash

" Allow backspacing over indention, line breaks and insertion start.
set backspace =indent,eol,start



" Text rendering --------------------------------------------------------------

" Always try to show a paragraph’s last line.
set display +=lastline

" Avoid breaking/wrapping lines in the middle of the words.
set linebreak

" Number of screen lines to keep above and below the cursor.
set scrolloff =3

" Number of screen columns to keep to the left and right of the cursor.
set sidescrolloff =5

" Number of columns per line.
" Used in automatic line breaking rules and in the ruler generation.
set textwidth =80

" Enable soft line wrapping.
" It does not change the text, only displays long lines in multiple lines.
set wrap linebreak nolist

" Indicators for too long lines (vertical ruler and highlighting).
" Draw a vertical rule in the column textwidth+1 (81) and one in the column
" textwidth+21 (101).
let &colorcolumn ="+1,+21"  "Potentially: .join(range(21, 500), ",+")

" Define the color of the rulers.
highlight ColorColumn ctermbg=0 guibg=lightgray

" Color used for highlighting the characters exceeding the second ruler.
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9

" Define characters exceeding the second ruler length to be highlighted.
match OverLength /%>100v.+/



" Terminal --------------------------------------------------------------------
" Change the terminal's title to the current file name instead of just 'Vim'
set title

" Don't use the terminal bell sound, flash the editor instead.
"set noerrorbells
"set visualbell



" Cursor ----------------------------------------------------------------------

" Allows cursor change in tmux mode.
" These lines change the cursor from block cursor mode to vertical bar cursor 
" mode when using tmux. Without these lines, tmux always uses block cursor 
" mode.
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Highlight cursorline ONLY in the active window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Always show cursor's position.
set ruler



" Code folding ----------------------------------------------------------------

" Enable code folding
set foldenable

" How much is folded by default when opening a buffer.
" 0 = all folds will be closed, 99 = folds are always open.
" 10 = only very nested blocks of code are folded.
set foldlevelstart =10

" Max number of nested folds.
" This simplifies life when opening the folds, as not more than foldnestmax
" will be one in another.
set foldnestmax =10

" Space opens/closes folds.
nnoremap <space> za

" Folding is based on indentation level.
" Other acceptable values are marker, manual, expr, syntax, diff.
" Run :help foldmethod to find out what each of those do.
set foldmethod =indent



" Look and feel ---------------------------------------------------------------

" Color theme
"Plugin 'chriskempson/base16-vim'
"colorscheme base16-default-dark

" Show line numbers.
set number

" Shows the last command entered in the very bottom right of Vim.
set showcmd

" Highlight matching parenthesis
set showmatch

 " Don't hide mouse when typing.
set nomousehide

" Visual autocomplete for command menu.
set wildmenu

" Enable spellchecking.
set spell

" Redraw only when we need to and not at standard too-frequent rate.
"set lazyredraw

" Always display the status bar.
set laststatus =2

" Switch on syntax highlighting.
syntax enable



" Search ----------------------------------------------------------------------

" Search as characters are typed.
set incsearch

" Highlight search matches.
set hlsearch

" Make searches case INsensitive.
set ignorecase

" Shortcut to turn off search highlight.
" Vim will keep highlighted matches from searches until you either run a new 
" one or manually stop highlighting the old search with :nohlsearch.
" For a faster removal of the highlighting, this shortcut is used instead.
nnoremap <leader><space> :nohlsearch<CR>

" Limit the files searched for auto-completes.
" complete =.,w,b,u,t,i. This breaks down to:
"     .: Scan the current buffer
"     w: Scan buffers from other windows
"     b: Scan buffers from the buffer list
"     u: Scan buffers that have been unloaded from the buffer list
"     t: Tag completion
"     i: Scan the current and included files
"set complete -=i



" Utility functions -----------------------------------------------------------

function! Capitalize(string)
    let result = substitute(a:string,'\(\<\w\+\>\)', '\u\1', 'g')
    return result
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\r\n'")
endfunction

function! GitBranchName()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?' | '.l:branchname.':':' | '
endfunction



" Status line -----------------------------------------------------------------

set statusline =

" Buffer number.
set statusline +=\ Buffer\ #%n
" Current Git branch.
set statusline +=%{GitBranchName()}
" Path to the file in the buffer, as typed or relative to current directory.
set statusline +=%f
" Flag for modified file.
set statusline +=%m

" Padding, empty space in the middle.
set statusline+=%=

" File type, encoding and end of line format
set statusline +=\ %Y
set statusline +=\ \|\ %{toupper(&fileencoding?&fileencoding:&encoding)}
set statusline +=\ \|\ %{Capitalize(&fileformat)}
" Current line and column number.
set statusline +=\ \|\ %l:%c
" Total lines in file.
set statusline +=\ \|\ Lines:\ %L
" Time and date.
set statusline +=\ \|\ %{strftime('%a\ %d\ %b,\ %H:%M:%S')}
" Final space on the right side of the screen.
set statusline +=\ 



" Vim Plug --------------------------------------------------------------------

" Specify a directory for plugins.
" Avoid using standard Vim directory names like 'plugin'.
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'https://github.com/plasticboy/vim-markdown.git'

" Initialize plugin system
call plug#end()



" HELL BELOW THIS LINE =======================

" move to beginning/end of line
"nnoremap B ^
"nnoremap E $

" $/^ doesn't do anything
"nnoremap $ <nop>
"nnoremap ^ <nop>

" User Interface Options

"set wildmenu  " Display command line’s tab complete options as a menu.
"set colorscheme wombat256mod  " Change color scheme.



"set formatoptions +=j  " Delete comment characters when joining lines.
"set hidden  " Hide files in the background instead of closing them.
"set nomodeline  " Ignore file’s mode lines; use vimrc configurations instead.





function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            if empty(&shellxquote)
                let l:shxq_sav = ''
                set shellxquote&
            endif
            let cmd = '"' . $VIMRUNTIME . '\diff"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
        let &shellxquote=l:shxq_sav
    endif
endfunction

"set diffexpr=MyDiff()
