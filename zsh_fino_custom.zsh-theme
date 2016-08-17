# -----------------------------------------------------------------------------
# Matjaž's dotfiles ZSH custom theme configuration file
#
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
# -----------------------------------------------------------------------------
#
# fino-mat.zsh-theme
# Variation of the Fino theme by Matjaž <dev@matjaz.it> matjaz.it
# v1.0 2015-09-11
#    - Original version    
# v1.1 2016-03-18
#    - Added Python Virtualenv prompt
#    - Added root name customization
#    - Some fixes
#
# Use with a dark background and 256-color terminal!
# Suggested theme: `base16 atelierforest dark`
#
# Example prompt (obviously missing colours):
# ╭──user on hostname in ~/some/directory on branch ✘ ● inside venv
# ╰○ echo "Hello, World!"
#
# Borrowing shamelessly from these oh-my-zsh themes:
# bira, robbyrussel, bureau, amuse
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# https://github.com/tonyseek/oh-my-zsh-virtualenv-prompt
# ==========


function color_in_gray {
    echo "%{$FG[239]%}$1%{$reset_color%}"
}

# Git prompt global variables, used also for Mercurial
# ----------------------------------------------------
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ✘"
ZSH_THEME_GIT_PROMPT_PREFIX=" $(color_in_gray 'on') %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%} ●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%} ●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%} ●%{$reset_color%}"

# Mercurial prompt variables
# --------------------------
YS_VCS_PROMPT_PREFIX=ZSH_THEME_GIT_PROMPT_PREFIX
YS_VCS_PROMPT_SUFFIX=ZSH_THEME_GIT_PROMPT_SUFFIX
YS_VCS_PROMPT_DIRTY=ZSH_THEME_GIT_PROMPT_DIRTY
YS_VCS_PROMPT_CLEAN=ZSH_THEME_GIT_PROMPT_CLEAN

function hg_branch_name_and_status_symbol {
    if [ -d '.hg' ]; then
        local hg_prompt="$ZSH_THEME_GIT_PROMPT_PREFIX$(hg branch 2>/dev/null)"
        if [ -n "$(hg symbols 2>/dev/null)" ]; then
            hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_DIRTY
        else
            hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_CLEAN
        fi
        hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_SUFFIX
        echo $hg_prompt
    fi
}


function git_status_symbols {
    index=$(command git status --porcelain -b 2> /dev/null)
    local symbols=""
    if $(echo "$index" | grep '^[AMRD]. ' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$index" | grep '^.[MTD] ' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$index" | command grep -E '^\?\? ' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$index" | grep '^UU ' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_STASHED"
    fi
    if $(echo "$index" | grep '^## .*ahead' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_AHEAD"
    fi
    if $(echo "$index" | grep '^## .*behind' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_BEHIND"
    fi
    if $(echo "$index" | grep '^## .*diverged' &> /dev/null); then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_DIVERGED"
    fi
    echo $symbols
}


function versioning_system_char_symbol {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}


function host_name_prompt {
    echo "%{$FG[033]%}${SHORT_HOST:-$HOST}%{$reset_color%}"
}


function root_or_user_name_prompt {
    if [[ $UID -eq 0 ]]; then
        echo "%{$FG[202]%}r☢☢t%{$reset_color%}"
    else
        echo "%{$FG[040]%}%n%{$reset_color%}"
    fi
}

function current_virtualenv_prompt {
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -f "$VIRTUAL_ENV/__name__" ]; then
            local name=$(<$VIRTUAL_ENV/__name__)
        elif [ `basename $VIRTUAL_ENV` = "__" ]; then
            local name=$(basename $(dirname $VIRTUAL_ENV))
        else
            local name=$(basename $VIRTUAL_ENV)
        fi
        echo " $(color_in_gray 'inside') $name"
    fi
}

local current_dir='%{$terminfo[bold]$FG[226]%}${PWD/#$HOME/~}%{$reset_color%}'
local git_info='$(git_prompt_info)$(git_status_symbols)'
local hg_info='$(hg_branch_name_and_status_symbol)'
local char='$(versioning_system_char_symbol) '
local venv='$(current_virtualenv_prompt)'

PROMPT="╭──$(root_or_user_name_prompt) $(color_in_gray 'on') $(host_name_prompt) $(color_in_gray 'in') ${current_dir}${git_info}${hg_info}${venv}
╰$char"
RPROMPT=""
