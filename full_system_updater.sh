#!/bin/bash
# -----------------------------------------------------------------------------
# System packages updater for Apple OS X
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on an OS X system system. There are no 
# parameters. It may ask you for root password about at the end of the 
# execution to update Ruby gems.
#
# >> WHAT IT DOES
# It runs all possible upgrades of any package manager it can find on OS X.
# -----------------------------------------------------------------------------

prompt="[ DOTFILES ][ UPDATER ]"

# Terminates the script if the current operative system is not OS X
function verify_operative_system() {
    if [ $(uname) != "Darwin" ] ; then
        echo "$prompt The current operative system is not Apple OS X; terminating."
        exit 101
    fi    
}


# Performs the OS check as above
verify_operative_system


# App Store
echo "$prompt Updating OS X system-software from App Store."
softwareupdate --install --all


# HomeBrew
which brew 2>&1 > /dev/null
if [ $? = 0 ]; then
    echo "$prompt Updating Homebrew."
    brew update
    brew missing
    echo "$prompt Upgrading Homebrew."
    brew upgrade --all
    echo "$prompt Cleaning up Homebrew."
    brew cleanup --force -s # '-s'= remove even the latest version cache
    brew cask cleanup || echo "$prompt Homebrew Cask not installed; skipping cleanup."
else
    echo "$prompt Missing Homebrew; skipping."
fi


# Python3 update all pip3 packages
which pip3 2>&1 > /dev/null
if [ $? = 0 ]; then  # if pip exists
    echo "$prompt Updating pip3 itself. May ask for root password."
    sudo -H pip3 install --upgrade pip
    if [[ -z $(pip3 freeze --local) ]]; then
        echo "$prompt No pip packages installed so far."
    else
        echo "$prompt Updating all pip3 packages."
        pip3 freeze --local \
            | grep -v '^\-e' \
            | cut -d = -f 1  \
            | xargs -n1 sudo -H pip3 install --upgrade
    fi
else
    echo "$prompt Missing pip3, skipping."
fi


# Ruby gems
which gem 2>&1 > /dev/null
if [ $? = 0 ]; then  # if gem exists
    echo "$prompt Updating gem itself. May ask for root password."
    sudo gem update --system
    echo "$prompt Updating gems. May ask for root password."
    sudo gem update
else
    echo "$prompt Missing gem, skipping."
fi


# Node.js packages
which npm 2>&1 > /dev/null
if [ $? = 0 ]; then  # if Node exists
    echo "$prompt Updating Node.js packages."
    npm update -g
else
    echo "$prompt Missing Node.js, skipping."
fi
