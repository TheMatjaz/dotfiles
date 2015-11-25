#!/bin/bash
# ------------------------------------------------------------------------------
# System packages updater
#
# >> LICENSE
# Copyright (c) 2015, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This Source Code Form is subject to the terms of the BSD 3-clause license. 
# If a copy of the license was not distributed with this file, You can obtain
# one at http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on the system. There are no parameters. It will
# ask you for root password about at the end of the execution to update
# Ruby gems.
#
# >> WHAT IT DOES
# It runs all possible upgrades of any package manager it can find. Currently
# for OS X and Debian/Ubuntu.
# ------------------------------------------------------------------------------

# Find the current operating system as seen: http://stackoverflow.com/a/3792848
case $(uname) in
    'Darwin')
        echo "Updating Apple App Store software."
        softwareupdate -i -a
        # If HomeBrew is installed, run its updates
        type brew 2>&1 > /dev/null
        if [ $? = 0 ]; then
            echo "Updating Homebrew."
            brew update
            brew missing
            brew upgrade --all
            brew cleanup --force -s # '-s'= remove even the latest version cache
        else
            echo "Missing Homebrew, skipping."
        fi
        type brew-cask 2>&1 > /dev/null
        if [ $? = 0 ]; then
            echo "Cleaning up Homebrew Cask."
            brew cask cleanup
        else
            echo "Missing Homebrew Cask, skipping."
        fi
        ;;
    'Linux')
        if [ -f /etc/debian_version ] ; then
            # based on Debian, so has apt-get
            echo "Updating apt-get"
            sudo apt-get update
            sudo apt-get -y dist-upgrade
            sudo apt-get autoremove
            sudo apt-get clean
            sudo apt-get autoclean
        else
            echo 'Not implemented for this Linux.
Please update this script $(basename $0)'
            exit 100
        fi
        ;;
    *)
        echo 'Not implemented for this operative system.
Please update this script $(basename $0)'
        exit 100
        ;;
esac

# Python3 update all pip3 packages
type pip3 --help 2&>1 > /dev/null
if [ $? = 0 ]; then
    if [ -z $(pip3 freeze --local) ]; then
        echo "No pip packages installed so far. Updating only pip3 itself."
    else
        echo "Updating pip3 packages."
        pip3 freeze --local \
            | grep -v '^\-e' \
            | cut -d = -f 1  \
            | xargs -n1 pip3 install --upgrade
    fi
    pip3 install --upgrade pip || {
        echo "Running pip3 upgrade again with sudo"
        sudo pip3 install --upgrade pip
    }
else
    echo "Missing pip3, skipping."
fi

# Ruby gems
type gem --help 2&>1 > /dev/null
if [ $? = 0 ]; then
    echo "Updating gem."
    sudo gem update --system
    sudo gem update
else
    echo "Missing gem, skipping."
fi

