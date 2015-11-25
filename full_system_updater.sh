#!/bin/zsh
# This script runs all possible upgrades on a Unix-like system. Run it as root.

# Find current OS and act accordingly, updating their package manager
# http://stackoverflow.com/a/3792848

# Make sure only root can run our script
#if [[ $EUID -ne 0 ]]; then
#    echo "This script must be run as root" 1>&2
#    exit 1
#fi

# Find the current operating system
case $(uname) in
    'Darwin')
        # Mac App store update
        echo "Updating Apple App Store software."
        softwareupdate -i -a
        # If HomeBrew is installed, run its updates
        type brew 2>&1 > /dev/null
        if [ $? = 0 ]; then
            echo "Updating Homebrew."
            brew update
            brew missing
            brew upgrade --all
            brew cleanup --force -s # '-s' = remove even the latest version cache
            # here add clean all unused dependencies
            #list="/tmp/brew_installed_formulas.db"
            #rm -r $list
            #touch $list
            #sqlite3 $list "CREATE TABLE brew_formulas (formula_name text PRIMARY KEY, used_by int);"
            #for formula in $(brew list); do
            #    sqlite3 $list "INSERT INTO brew_formulas (formula_name) VALUES ('$formula');"
            #    for dependency in $(brew uses --installed $formula); do
            #        sqlite3 $list "UPDATE brew_formulas SET (used_by) = (used_by + 1) WHERE formula_name = '$dependency';"
            #    done
            #done
            #grep -v 'used' < $list
        else
            echo "Missing Homebrew, skipping."
        fi
        type brew-cask 2>&1 > /dev/null
        if [ $? = 0 ]; then
            echo "Cleaning up Homebrew Cask."
            brew cask cleanup
            # here add clean all unused dependencies
        else
            echo "Missing Homebrew Cask, skipping."
        fi
        ;;
    'Linux')
        if [ -f /etc/debian_version ] ; then
            # based on Debian, so has apt-get
            echo "Updating apt-get"
            apt-get update
            apt-get -y upgrade
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

