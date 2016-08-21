#!/bin/bash
# -----------------------------------------------------------------------------
# Matjaž's dotfiles required packages installer script for Apple OS X.
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# This script gets executed when running matjaz_dotfiles_installer.sh.
# You can execute it also as stand-alone anywhere on an OS X system. 
# There are no parameters.
#
# >> WHAT IT DOES
# Install packages (programs) for which the Matjaž's dotfiles are the
# configuration files. It calls the system's package manager Homebrew for OS X.
# -----------------------------------------------------------------------------

prompt="[ DOTFILES ][ DEPENDENCIES ]"

# Terminates the script if the current operative system is not OS X
function verify_operative_system() {
    if [ $(uname) != "Darwin" ] ; then
        echo "$prompt The current operative system is not Apple OS X; terminating."
        exit 101
    fi    
}


# Performs the OS check as above
verify_operative_system


# Install Homebrew and Homebrew Cask if not already installed
type brew 2>&1 > /dev/null
if [ $? != 0 ]; then
    echo "$prompt Installing Homebrew, will be used to install the packages."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "$prompt Found Homebrew, skipping installation."
fi
echo "$prompt Updating Homebrew local repository."
brew update
echo "$prompt Installing the packages."
## Brew cask itself
brew tap caskroom/cask

## Formulas to build from source with options
brew install emacs --with-cocoa
brew install aspell --with-lang-it --with-lang-sl --with-lang-en --with-lang-de
brew install git --without-completions
brew install wget --with-iri
brew install htop --with-ncurses
brew install midnight-commander --without-nls
brew install sqlite --with-json1 --with-functions

## Other formulas
brew install \
     autojump \
     brew-cask-completion \
     brew-rmtree \
     gcc \
     git-flow \
     gnu-sed \
     gnu-time \
     gnuplot \
     gnutls \
     hugo \
     imagemagick \
     keybase \
     libssh2 \
     mobile-shell \
     nmap \
     openssl \
     pandoc \
     pyenv \
     python3 \
     safe-rm \
     speedtest_cli \
     task \
     tig \
     tmux \
     trash \
     tree \
     w3m \
     zsh-completions \
     zsh-syntax-highlighting \

## Brew casks
brew cask install \ 
    accessmenubarapps \
    appcleaner \
    avira-antivirus \
    diffmerge \
    evernote \
    fluid \
    firefox \
    freedome \
    jdownloader \
    little-snitch \
    macs-fan-control \
    presentation \
    skitch \
    texmaker \
    virtualbox \
    xquartz \

echo "$prompt Performing some cleaning."
brew cleanup --force -s   
brew cask cleanup


# Install Oh My ZSH if not already installed
if [ -d $HOME/.oh-my-zsh ]; then
    echo "$prompt Oh My ZSH installation found, skipping install."
else
    # Download and run Oh My ZSH installer without letting it enter the zsh
    # so the script may continue. It's done by cutting off the "env zsh" line.
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/env zsh/d')"
    echo "$prompt Setting zsh as default shell. It may ask you for the root password."
    sudo chsh -s $(which zsh)
fi


# Install the live syntax highlighting for Oh My ZSH
zshsyntax_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ -d $zshsyntax_dir/.git ]; then
    echo "$prompt Found zsh-syntax-highlighting plugin, updating it."
    cd $zshsyntax_dir
    git checkout master
    git pull
    git checkout -
else
    echo "$prompt Installing the zsh-syntax-highlighting plugin."
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $zshsyntax_dir || {
        echo "$prompt An error occurred during the cloning of the zsh-syntax-highlighting repository. Please try running this script again."
        exit 1
    }
fi
