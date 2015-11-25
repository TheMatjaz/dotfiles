#!/bin/bash
# ------------------------------------------------------------------------------
# Matjaž's dotfiles required packages installer script
#
# >> LICENSE
# Copyright (c) 2015, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This Source Code Form is subject to the terms of the BSD 3-clause license. 
# If a copy of the license was not distributed with this file, You can obtain
# one at http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# This script gets executed when running matjaz_dotfiles_installer.sh.
# You can execute it also as stand-alone anywhere on the system. There are no
# parameters.
#
# >> WHAT IT DOES
# Install packages (programs) for which the Matjaž's dotfiles are the
# configuration files. It calls the system's package manager: currently for
# OS X and Debian/Ubuntu only.
# ------------------------------------------------------------------------------


# Find the current operating system
echo "Installing some packages to be set with the dotfiles."
case $(uname) in
    'Darwin')
        echo "OS X detected."
        # Install Homebrew if not already installed
        type brew 2>&1 > /dev/null
        if [ $? != 0 ]; then
            echo "Installing Homebrew, will be used to install the packages."
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            echo "Homebrew already installed, skipping installation."
        fi
        echo "Updating Homebrew local repository."
        brew update
        echo "Installing the packages."
        brew install brew-cask emacs git git-flow htop-osx midnight-commander python3 sqlite wget
        echo "Performing some cleaning."
        brew cleanup --force -s   
        brew cask cleanup
        ;;
    'Linux')
        if [ -f /etc/debian_version ] ; then
            echo "Debian/Ubuntu detected."
            echo "Updating apt-get."
            sudo apt-get update
            echo "Installing the packages."
            sudo apt-get -y install build-essential git git-flow htop mc emacs zsh sqlite3 python3-pip coreutils findutils moreutils screen
            echo "Performing some cleaning."
            sudo apt-get autoremove
            sudo apt-get clean
            sudo apt-get autoclean
        else
            echo "Not implemented for this Linux operative system.
Please update this script $(basename $0)"
            exit 100
        fi
        ;;
    *)
        echo "Not implemented for this operative system.
Please update this script $(basename $0)"
        exit 100
        ;;
esac

# Install Oh My ZSH if not already installed
if [ -d ~/.oh-my-zsh ]; then
    echo "Oh My ZSH installation found, skipping install."
else
    # Download and run Oh My ZSH installer without letting them enter the zsh
    # so the script may continue
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/env zsh/d')"
    echo "It may ask you for a password to set zsh as default shell:"
    sudo chsh -s $(which zsh)
fi

# Install the live syntax highlighting for Oh My ZSH
zshsyntax_dir="~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ -d $zshsyntax_dir/.git ]; then
    echo "Updating existing zsh-syntax-highlighting repository."
    cd $zshsyntax_dir
    git pull
else
    echo "Cloning the zsh-syntax-highlighting repository."
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $zshsyntax_dir || {
        echo "An error occurred during the cloning of the zsh-syntax-highlighting repository.
Please try running this script again."
        exit 1
    }
fi
