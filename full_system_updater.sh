#!/bin/zsh
# This script runs all possible upgrades on a Unix-like system. Run it as root.

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
            apt-get update
            apt-get -y dist-upgrade
            apt-get autoremove
            apt-get clean
            apt-get autoclean
        else
            echo 'Not implemented for this Linux. Please update this script $(basename $0)'
            exit 100
        fi
        ;;
    *)
        echo 'Not implemented for this operative system. Please update this script $(basename $0)'
        exit 100
        ;;
esac

# Python3 update all pip3 packages
type pip3 2>&1 > /dev/null
if [ $? = 0 ]; then
    echo "Updating pip"
    pip3 freeze --local \
        | grep -v '^\-e' \
        | cut -d = -f 1  \
        | xargs -n1 pip3 install -U
else
    echo "Missing pip3, skipping."
fi

# Ruby gems
type gem 2>&1 > /dev/null
if [ $? = 0 ]; then
    echo "Updating gem."
    sudo gem update --system
    sudo gem update
else
    echo "Missing gem, skipping."
fi

