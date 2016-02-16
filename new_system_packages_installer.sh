#!/bin/bash
# ------------------------------------------------------------------------------
# Matjaž's dotfiles required packages installer script for Apple OS X.
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This Source Code Form is subject to the terms of the BSD 3-clause license. 
# If a copy of the license was not distributed with this file, You can obtain
# one at http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# This script gets executed when running matjaz_dotfiles_installer.sh.
# You can execute it also as stand-alone anywhere on an OS X system. 
# There are no parameters.
#
# >> WHAT IT DOES
# Install packages (programs) for which the Matjaž's dotfiles are the
# configuration files. It calls the system's package manager Homebrew for OS X.
# ------------------------------------------------------------------------------

prompt="[ DOTFILES ]"

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
brew install brew-cask emacs git git-flow htop-osx midnight-commander python3 sqlite wget
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
