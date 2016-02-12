#!/bin/bash
# ------------------------------------------------------------------------------
# System packages updater
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This Source Code Form is subject to the terms of the BSD 3-clause license. 
# If a copy of the license was not distributed with this file, You can obtain
# one at http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on the system. There are no parameters. It may
# ask you for root password to run apt-get or other package managers.
#
# >> WHAT IT DOES
# It runs all possible upgrades for a Debian or Ubuntu operative system.
# ------------------------------------------------------------------------------

prompt="[ DOTFILES ]"

if [ -f /etc/debian_version ] ; then
    echo "$prompt The current operative system is not a Debian or Ubuntu; terminating."
    exit 100
fi


# apt-get update and upgrade
echo "$prompt Updating apt-get."
sudo apt-get update
sudo apt-get -y dist-upgrade
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
    echo "$prompt Updating gem. May ask for root password."
    sudo gem update --system
    sudo gem update
else
    echo "$prompt Missing gem; skipping."
fi

