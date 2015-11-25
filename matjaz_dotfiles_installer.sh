#!/bin/bash
# ------------------------------------------------------------------------------
# Matjaž's dotfiles installer script
#
# >> LICENSE
# Copyright (c) 2015, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This Source Code Form is subject to the terms of the BSD 3-clause license. 
# If a copy of the license was not distributed with this file, You can obtain
# one at http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on the system. There are no parameters.
#
# >> WHAT IT DOES
# It downloads the Matjaž's dotfiles git repository (which may be found on
# Github: https://github.com/TheMatjaz/dotfiles) to ~/Development/Dotfiles and
# applies those dotfiles to the user, by creating symlinks to them from the
# home directory. Also installs the packages to be configured by the dotfiles
# by calling new_system_packages_installer.sh
# ------------------------------------------------------------------------------

fi

# Create dotfiles directory and clone repository into it
dotfiles_dir="$HOME/Development/Dotfiles/"
backup_dir="$HOME/Development/Dotfiles/.original_dotfiles/"
mkdir -p $backup_dir || {
    echo "Cannot create the $dotfiles_dir directory"
    exit 1
}
cd $dotfiles_dir
echo "A folder $dotfiles_dir has been created to store all the dotfiles in it."
if [ -d .git ]; then
    echo "Updating existing dotfiles repository."
else
    echo "Cloning the dotfiles repository."
    git clone https://github.com/TheMatjaz/dotfiles.git . || {
        echo "An error occurred during the cloning of the dotfiles repository.\
Please try running this script again."
        exit 1
    }
fi

# Install a set of basic packages on newly set systems, along with Oh My ZSH!
bash new_system_packages_installer.sh

# Creates a symbolic link to the file specified in the first argument $1
# pointing to the file specified in the second argument $2. Backups any existing
# file at the position $2 to the backup directory.
function symlink_dotfile() {
    local file_in_repo=$dotfiles_dir$1
    local file_in_home=$2
    if [[ -e $file_in_home && ! -L $file_in_home ]]; then
        echo "Backing up existing $file_in_home into $backup_dir"
        mv $file_in_home $backup_dir
    #elif [ ! -e $file_in_home ]; them
    #     touch_with_create_path($file_in_home)
    fi
    ln -s -v -f -F $file_in_repo $file_in_home
}

# Create symlinks in the home directory that point to the files in the
# dotfiles repository. Any existing dotfiles get backupped.
echo "Symlinking..."
symlink_dotfile gitconfig ~/.gitconfig
symlink_dotfile gitignore_global ~/.gitignore_global
symlink_dotfile hgrc ~/.hgrc
symlink_dotfile screenrc ~/.screenrc
symlink_dotfile wgetrc ~/.wgetrc
symlink_dotfile zsh_fino_custom.zsh-theme ~/.oh-my-zsh/custom/themes/zsh_fino_custom.zsh-theme
symlink_dotfile zsh_aliases ~/.zsh_aliases
symlink_dotfile zsh_path ~/.zsh_path
symlink_dotfile zshrc ~/.zshrc
symlink_dotfile mc_ini ~/.config/mc/ini
symlink_dotfile mc_panels.ini ~/.config/mc/panels.ini
symlink_dotfile emacs_init.el ~/.emacs.d/init.el

# Symlink the htop configuration file as well, but place it in ~/.htoprc on Macs
# and in ~/.config/htop/htoprc on Linux.
case $(uname) in
    'Darwin')
        symlink_dotfile htoprc ~/.htoprc
        ;;
    'Linux')
        symlink_dotfile htoprc ~/.config/htop/htoprc
        ;;
    *)
        echo 'Cannot symlink htoprc on proper position on this operative system. Please update this script or perform the symlink yourself.'
    ;;
esac




unset backup_dir
unset dotfiles_dir
