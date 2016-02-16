#!/bin/bash
# -----------------------------------------------------------------------------
# Matjaž's dotfiles required packages installer script for Debian or Ubuntu
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
# You can execute it also as stand-alone anywhere on a Debian or Ubuntu
# operative system. There are no parameters.
#
# >> WHAT IT DOES
# Install packages (programs) for which the Matjaž's dotfiles are the
# configuration files. It calls the system's package manager apt-get.
# -----------------------------------------------------------------------------

prompt="[ DOTFILES ][ DEPENDENCIES ]"


# Terminates the script if the current operative system is not Debian or Ubuntu
function verify_operative_system() {
    if [ $(uname) != "Linux" ] ; then
        echo "$prompt The current operative system is not Linux; terminating."
        exit 101
    fi
    if [ ! -f /etc/debian_version ] ; then
        echo "$prompt The current operative system is not a Debian or Ubuntu; terminating."
        exit 100
    fi
}


# Performs an initial OS check as above
verify_operative_system


# Install the useful packages that are configured by the dotfiles
echo "$prompt Updating apt-get. It may ask you for the root password."
sudo apt-get update
echo "$prompt Installing the packages required by the dotfiles."
sudo apt-get -y install build-essential git git-flow htop mc emacs zsh sqlite3 python3-pip coreutils findutils moreutils screen gpg


# Install Oh My ZSH if not already installed
if [ -d $HOME/.oh-my-zsh ]; then
    echo "$prompt Oh My ZSH installation found; skipping install."
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

