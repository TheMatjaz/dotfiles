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
case $(uname) in
    'Darwin')
        
        # Install Homebrew if not already installed
        type brew 2>&1 > /dev/null
        if [ $? != 0 ]; then
            echo "Installing Homebrew."
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        # Make sure we’re using the latest Homebrew.
        brew update

        # Upgrade any already-installed formulae.
        brew upgrade --all

        # Install packages that have already been in use on other OS X systems
        brew install \
             brew-cask diff-pdf doxygen ecj emacs figlet frotz gcc git \
             git-flow gnuplot htop-osx hugo keybase maven midnight-commander \
             nmap pandoc pgformatter python3 sqlite tree wget coreutils \
             findutils moreutils imagemagick --with-webp rename speedtest_cli

        #sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

        # Remove outdated versions from the cellar.
        brew cleanup --force -s   
        brew cask cleanup
        ;;
    'Linux')
        if [ -f /etc/debian_version ] ; then
            # based on Debian, so has apt-get
            echo "Updating apt-get"
            # Keep-alive: update existing `sudo` time stamp until the script has finished.
            sudo -v
            while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

            apt-get update
            apt-get -y upgrade
            apt-get -y install \
                    build-essential git-core git-flow htop mc emacs zsh sqlite3 python3-pip
            apt-get autoremove
            apt-get clean
            apt-get autoclean
        else
            echo 'Not implemented for this operative system. Please update the script.'
            exit 100
        fi
        ;;
    *)
        echo 'Not implemented for this operative system. Please update the script.'
        exit 100
        ;;
esac

type pip3 2>&1 > /dev/null
if [ $? = 0 ]; then
    echo "Installing pip3 packages"
    pip3 install --update pip3
    pip3 install grip Markdown numpy
else
    echo "Missing pip3, skipping."
fi
