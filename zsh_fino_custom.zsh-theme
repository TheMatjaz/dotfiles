# fino-mat.zsh-theme
# Variation of the Fino theme by Matjaž <dev@matjaz.it> matjaz.it
# v1.0 2015-09-11
#
# Use with a dark background and 256-color terminal!
# Suggested theme: * base16 atelierforest dark *
# Meant for people with git, mercurial, nvm. Tested only on OS X 10.10.
#
# Example propmt (obviously missing colours):
# ╭──unser on hostname in ~/some/directory/here on master ✘ ● ●
# ╰± git status                                             [01:53:05]
#
# You can set your computer name in the ~/.box-name file, if you want.
# Borrowing shamelessly from these oh-my-zsh themes:
# bira, robbyrussel, bureau, amuse
# and from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# ==========

### Node.js NVM global variables
ZSH_THEME_NVM_PROMPT_PREFIX=" %B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Mercurial prompt global variables
YS_VCS_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%} "
YS_VCS_PROMPT_DIRTY="%{$FG[202]%} ✘"
YS_VCS_PROMPT_CLEAN="%{$fg_bold[green]%} ✔%{$reset_color%}"

### Git prompt global variables
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ✘"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%} ●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%} ●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%} ●%{$reset_color%}"

### Returns the Mercurial branch prompt
function fun_hg_info {
  # make sure this is a hg dir
  if [ -d '.hg' ]; then
    local hg_prompt="${YS_VCS_PROMPT_PREFIX}$(hg branch 2>/dev/null)"
    if [ -n "$(hg symbols 2>/dev/null)" ]; then
      hg_prompt=$hg_prompt$YS_VCS_PROMPT_DIRTY
    else
      hg_prompt=$hg_prompt$YS_VCS_PROMPT_CLEAN
    fi
      hg_prompt=$hg_prompt$YS_VCS_PROMPT_SUFFIX
      echo $hg_prompt && return
  fi
}

### Returns the symbols representing the status of the git branch
function fun_git_symbols {
  index=$(command git status --porcelain -b 2> /dev/null)
  symbols=""
  
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

### Returns the character indicating which CVS is in current use, if any.
function fun_prompt_char {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '☿' && return
  echo '○'
}

### Returns the hostname
function box_name {
  [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

### Returns a lighting symbol, if user is root
function root_char {
  if [[ $UID -eq 0 ]]; then
    echo '%{%fg_bold{yellow}%}⚡%{$reset_color%} '
  fi
}

### Returns the prompt of the battery status
#function battery_prompt {
#  battery_status=''
#  if [[ "$OSTYPE" = darwin* ]] ; then
#    battery_status='with $(battery_pct)%% '
#  fi
#  echo $battery_status
#}

local current_dir='${PWD/#$HOME/~}'
local time='$(date "+%H:%M:%S")'
local git_info='$(git_prompt_info)$(fun_git_symbols)'
local hg_info='$(fun_hg_info)'
local char='$(fun_prompt_char)'

### PROMPT shows:
# root_char, username, hostname, path, git, hg, ruby, nvm
# prompt char
PROMPT="╭──$(root_char)%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}on%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info}${hg_info}$(nvm_prompt_info)
╰${char}%{$reset_color%} "

### RPROMT shows '[time]'
RPROMPT=" %{$FG[239]%}[${time}]%{$reset_color%}"
