#!/bin/bash
# -----------------------------------------------------------------------------
# System packages updater
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
#
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on the system. There are no parameters. It may
# ask you for root password to run apt-get or other package managers.
#
# >> WHAT IT DOES
# It runs all possible upgrades for a Debian or Ubuntu operative system.
# -----------------------------------------------------------------------------

prompt="[ DOTFILES ][ UPDATER ]"


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


# Performs the OS check as above
verify_operative_system


# apt-get update and upgrade
echo "$prompt Updating apt-get repositories and packages. May ask for root password.

This updater runs 'apt-get upgrade' instead of 'apt-get dist-upgrade'.
If you know what you are upgrading and that it will not break your system, 
run 'apt-get dist-ugprade' yourself."
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get autoremove
sudo apt-get clean
sudo apt-get autoclean


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
    echo "$prompt Missing pip3; skipping."
fi


# Ruby gems
which gem 2>&1 > /dev/null
if [ $? = 0 ]; then  # if gem exists
    echo "$prompt Updating gem itself. May ask for root password."
    sudo gem update --system
    echo "$prompt Updating gems. May ask for root password."
    sudo gem update
else
    echo "$prompt Missing gem; skipping."
fi

