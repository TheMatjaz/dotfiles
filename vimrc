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
set fileformats=unix,dos,mac

" Encoding of the characters for the current buffer. Only display and
" and manipulation, not saving of the file.
set encoding=UTF-8

" Encoding of the characters used for Vimscripts, including vimrc and gvimrc.
" Has to be places after 'set encoding='.
scriptencoding UTF-8

" Encoding of the file when saved.
set fileencoding=UTF-8

" List of encodings considered when opening an existing file.
" They are tried in sequence. If an error is detected, the next encoding is
" tried.
" Starting with the most standard options, then some used but not smart ones.
set fileencodings=UTF-8,UTF-16le,UTF-16be,UTF-32le,UTF-32be,ISO-8859-1,Windows-1252



" Working directory -----------------------------------------------------------

" On startup, set the home directory as the working one. With this setting,
" when opening a file or saving a file right after Vim starts, the search
" starts in the home directory.
cd ~

" Set working directory to the same directory the currently edited file is in.
set autochdir



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
execute "set tabstop=" . tabsize

"Insert tabstop number of spaces when the tab key is pressed.
set smarttab 

" Number of spaces in tab when shifting text by a tab.
execute "set shiftwidth=" . tabsize
execute "set softtabstop=" . tabsize

" When shifting lines, round the indentation to the nearest multiple of 
" shiftwidth.
set shiftround



" Whitespace characters display -----------------------------------------------

" Show soft wraping of the line with this string to indicate
" a visual continuation on the next line.
" Note: a space is the last character in the string.
set showbreak=↪\ 

" Show whitespace characters with the following characters instead.
set list
set listchars=tab:⇥\ ,extends:›,precedes:‹,nbsp:␣,trail:•,eol:↲

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
autocmd BufWritePre * %s/\($\r?\n\s*\)\+\%$//

" Autosave files when no operation is done for some time.
" When the cursor does not do anything for 'updatetime' seconds (defaults
" to 4 s), an 'update' command is issued, which saves the buffers only
" if they have been modified. The CursorHoldI makes the same operation happen
" also in insert mode.
autocmd CursorHold,CursorHoldI * update

" Automatically reload files when modified by an external source (not by Vim).
set autoread

" Display a confirmation dialog when closing an unsaved file.
set confirm



" Autosave and autorestore session --------------------------------------------

" Return the path of the session file based on the OS.
" Used in the SaveSession and RestoreSession functions.
function! SessionFilePath()
    if has("win32")
        return "$HOME/vim/session.vim"
    elseif has("unix")
        return "~/.vim/session.vim"
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
    set backup
    set backupdir=C:/Temp/vim/backups
    set backupskip=C:/Temp/*
    set directory=C:/Temp/vim/swaps
    set writebackup
elseif has("unix")
    " Generic Unix settings
    set backup
    set backupdir=~/.tmp/vim/backups,~/tmp/vim/backups,/var/tmp/vim/backups,/tmp/vim/backups
    set backupskip=/tmp/*,/private/tmp/*
    set directory=~/.tmp/vim/swaps,~/tmp/vim/swaps,/var/tmp/vim/swaps,/tmp/vim/swaps
    set writebackup
else
    echoerr "Unknown operating system. Could not set backup location."
endif



" Interactivity ---------------------------------------------------------------

" Visual line navigation.
" When a line is soft-wrapped, Vim by default won't let you move down one line
" to the wrapped portion. This option allows doing so.
noremap j gj
noremap k gk

" Moar commands and search history remembered.
set history=500

" Moar chances to call an undo when required.
set undolevels=500

" Leave Insert mode after 15 seconds of inactivity.
autocmd CursorHoldI * stopinsert autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=15000 autocmd InsertLeave * let &updatetime=updaterestore

" Enable mouse support for scrolling and resizing.
set mouse=a

" Context menu when right-clicking.
set mousemodel=popup

" Middle-click paste.
noremap! <s-insert> <middlemouse>

" The shell used to execute commands.
set shell=/bin/bash



" Text rendering --------------------------------------------------------------

" Always try to show a paragraph’s last line.
set display+=lastline

" Avoid breaking/wrapping lines in the middle of the words.
set linebreak

" Number of screen lines to keep above and below the cursor.
set scrolloff=3

" Number of screen columns to keep to the left and right of the cursor.
set sidescrolloff=5

" Number of columns per line.
" Used in automatic line breaking rules and in the ruler generation.
set textwidth=80

" Enable soft line wrapping.
" It does not change the text, only displays long lines in multiple lines.
set wrap linebreak nolist

" Indicators for too long lines (vertical ruler and highlighting).
" Draw a vertical rule in the column textwidth+1 (81) and one in the column
" textwidth+21 (101).
let &colorcolumn="+1,+21" " .join(range(21, 500), ",+")

" Define the color of the rulers.
highlight ColorColumn ctermbg=0 guibg=lightgray

" Define characters exceeding the second ruler length to be highlighted.
match OverLength /\%>100v.\+/

" Color used for highlighting the characters exceeding the second ruler.
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9



" Terminal --------------------------------------------------------------------
" Change the terminal's title to the current file name instead of just 'Vim'
set title

" Don't use the terminal bell sound, flash the editor instead.
"set noerrorbells
"set visualbell



" Look and feel ---------------------------------------------------------------

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

" Color theme
"Plugin 'chriskempson/base16-vim'
"colorscheme base16-default-dark

" Show line numbers.
set number

" Shows the last command entered in the very bottom right of Vim.
set showcmd

" Highlight cursorline ONLY in the active window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Highlight matching parenthesis
set showmatch

 " Don't hide mouse when typing.
set nomousehide

" Visual autocomplete for command menu.
set wildmenu

" Enable spellchecking.
set spell



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


" HELL BELOW THIS LINE ==============

set wildignore=*.swp,*.bak,*.pyc,*.class


"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

"https://dougblack.io/words/a-good-vimrc.html












" Check http://vim.wikia.com/wiki/VimTip1592 for automatic tab-to-space conversion

set statusline=%F%m%r%h%w\ [FF=%{&ff}]\ [T=%Y]\ [A=\%03.3b]\ [H=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

set statusline=
"set statusline +=%1*\ %n\ %*            "buffer number
"set statusline +=%5*%{&ff}%*            "file format
"set statusline +=%3*%y%*                "file type
"set statusline +=%4*\ %<%F%*            "full path
"set statusline +=%2*%m%*                "modified flag
"set statusline +=%1*%=%5l%*             "current line
"set statusline +=%2*/%L%*               "total lines
"set statusline +=%1*%4v\ %*             "virtual column number
"set statusline +=%2*0x%04B\ %*          "character under cursor
" Powerline may be a good option





" Performance
set lazyredraw          " redraw only when we need to and not at standard too-frequent rate.
set complete-=i "Limit the files searched for auto-completes. complete=.,w,b,u,t,i. This breaks down to:
"
"    .: Scan the current buffer
"    w: Scan buffers from other windows
"    b: Scan buffers from the buffer list
"    u: Scan buffers that have been unloaded from the buffer list
"    t: Tag completion
"    i: Scan the current and included files
" -=i removes the 'i' flag






" Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default. foldlevelstart is the starting fold level for opening a new buffer. If it is set to 0, all folds will be closed. Setting it to 99 would guarantee folds are always open. So, setting it to 10 here ensures that only very nested blocks of code are folded when opening a buffer.
set foldnestmax=10      " Folds can be nested. Setting a max on the number of folds guards against too many folds. If you need more than 10 fold levels you must be writing some Javascript burning in callback-hell and I feel very bad for you.
" space open/closes folds
nnoremap <space> za "I change the mapping of <space> pretty frequently, but this is its current command. za opens/closes the fold around the current block. As an interesting aside, I've heard the z character is used to represent folding in Vim because it looks like a folded piece of paper.
set foldmethod=indent   " fold based on indent level. Other acceptable values are marker, manual, expr, syntax, diff. Run :help foldmethod to find out what each of those do.




" move to beginning/end of line
"nnoremap B ^
"nnoremap E $

" $/^ doesn't do anything
"nnoremap $ <nop>
"nnoremap ^ <nop>

" User Interface Options

set laststatus=2  " Always display the status bar.
set ruler  " Always show cursor position.
set wildmenu  " Display command line’s tab complete options as a menu.
set tabpagemax=50  " Maximum number of tab pages that can be opened from the command line.
"set colorscheme wombat256mod  " Change color scheme.
set cursorline  " Highlight the line currently under cursor.


" Miscellaneous

set backspace=indent,eol,start  " Allow backspacing over indention, line breaks and insertion start.
set formatoptions+=j  " Delete comment characters when joining lines.
set hidden  " Hide files in the background instead of closing them.
set nomodeline  " Ignore file’s mode lines; use vimrc configurations instead.

set wildignore+=.pyc,.swp  " Ignore files matching these patterns when opening files based on a glob pattern.


" Unknown
syntax enable

set diffexpr=MyDiff()
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

