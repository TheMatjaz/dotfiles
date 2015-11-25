#!/usr/bin/env bash
# Install command-line tools using package managers.


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
