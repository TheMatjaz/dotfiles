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
# v1.2 2016-08-23
#    - Re-added clocks on the right prompt
#    - Current system load on the right prompt
# v1.3 2017-10-22
#    - Moved current directory, Git and Mercurial info to new line
#    - Changed git statuses to full words for clarity
#    - Simplified the clock
#    - Theme code simplification
#
# Use with a dark background and 256-color terminal!
# Suggested theme: `base16 atelierforest dark`
#
# ╭──matjaz on MatBook
# ├──on git branch master, staged, modified, untracked, stashes
# ├──on hg branch default ✔
# ├──in /private/tmp/some
# ╰○                                                 [1.41/4] [14:15:19]
#
# Borrowing shamelessly from these oh-my-zsh themes:
# bira, robbyrussel, bureau, amuse
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# https://github.com/tonyseek/oh-my-zsh-virtualenv-prompt
# ==========


function color_in_gray {
    echo "%{$FG[245]%}$1%{$reset_color%}"
}

separator=', '

# Git prompt global variables, used also for Mercurial
# ----------------------------------------------------
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="$separator%{$fg_bold[green]%}clean%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="$separator%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="$separator%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="$separator%{$fg_bold[cyan]%}staged%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="$separator%{$fg_bold[yellow]%}modified%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$separator%{$fg_bold[red]%}untracked%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED="$separator%{$fg_bold[red]%}diverged%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="$separator%{$fg[gray]%}stashes%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="$separator%{$fg_bold[red]%}unmerged%{$reset_color%}"

# Mercurial prompt variables
# --------------------------
YS_VCS_PROMPT_PREFIX=ZSH_THEME_GIT_PROMPT_PREFIX
YS_VCS_PROMPT_SUFFIX=ZSH_THEME_GIT_PROMPT_SUFFIX
YS_VCS_PROMPT_DIRTY=ZSH_THEME_GIT_PROMPT_DIRTY
YS_VCS_PROMPT_CLEAN=ZSH_THEME_GIT_PROMPT_CLEAN

function hg_branch_name_and_status_symbol
{
    if [ -d '.hg' ]; then
        local hg_prompt="$(hg branch 2>/dev/null) "
        if [ -n "$(hg symbols 2>/dev/null)" ]
        then
            hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_DIRTY
        else
            hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_CLEAN
        fi
        hg_prompt=$hg_prompt$ZSH_THEME_GIT_PROMPT_SUFFIX
        echo "\n├──$(color_in_gray 'on hg branch') $hg_prompt"
    fi
}


function git_status_symbols {
    index=$(command git status --porcelain --branch 2> /dev/null)
    local symbols=""
    if $(git diff-index --quiet HEAD -- 2> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
    if $(echo "$index" | grep '^## .*ahead' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_AHEAD"
    fi
    if $(echo "$index" | grep '^## .*behind' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_BEHIND"
    fi
    if $(echo "$index" | grep '^## .*diverged' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_DIVERGED"
    fi
    if $(echo "$index" | grep '^UU ' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
    if $(echo "$index" | grep '^[AMRD]. ' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$index" | grep '^.[MTD] ' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$index" | command grep -E '^\?\? ' &> /dev/null)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1)
    then
        symbols="$symbols$ZSH_THEME_GIT_PROMPT_STASHED"
    fi
    echo $symbols
}


function git_branch_name_and_status_symbol
{
    if [ -d '.git' ]
    then
        local git_branch="$(git symbolic-ref --short HEAD 2> /dev/null)"
        echo "\n├──$(color_in_gray 'on git branch') $git_branch$(git_status_symbols)$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}


function host_name_prompt {
    echo "$(color_in_gray 'on') %{$FG[033]%}${SHORT_HOST:-$HOST}%{$reset_color%}"
}


function root_or_user_name_prompt
{
    if [[ $UID -eq 0 ]]
    then
        echo "%{$FG[202]%}r☢☢t%{$reset_color%}"
    else
        echo "%{$FG[040]%}%n%{$reset_color%}"
    fi
}


function current_virtualenv_prompt
{
    if [ -n "$VIRTUAL_ENV" ]
    then
        if [ -f "$VIRTUAL_ENV/__name__" ]; then
            local name=$(<$VIRTUAL_ENV/__name__)
        elif [ `basename $VIRTUAL_ENV` = "__" ]; then
            local name=$(basename $(dirname $VIRTUAL_ENV))
        else
            local name=$(basename $VIRTUAL_ENV)
        fi
        echo "$(color_in_gray 'within') $name"
    fi
}


function current_time
{
    string="[$(date '+%H:%M:%S')]"
    echo "$(color_in_gray $string)"
}


function current_system_load
{
    # Avoiding index-based cuts so it works with BSD uptime and GNU uptime
    color_in_gray "[$(uptime | sed -E 's/.* ([0-9]+.[0-9]+),? [0-9]+.[0-9]+,? [0-9]+.[0-9]+$/\1/')/$(getconf _NPROCESSORS_ONLN)]"
}

function current_dir
{
    echo "$(color_in_gray 'in') %{$terminfo[bold]$FG[226]%}${PWD/#$HOME/~}%{$reset_color%}"
}

PROMPT='
╭──$(root_or_user_name_prompt) $(host_name_prompt) $(git_branch_name_and_status_symbol) $(hg_branch_name_and_status_symbol) $(current_virtualenv_prompt)
├──$(current_dir)
╰○ '
RPROMPT='$(current_system_load) $(current_time)'
