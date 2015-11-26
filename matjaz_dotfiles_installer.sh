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
# It's an interactive installer of the Matjaž's dotfiles.
#
# - It downloads the git repository (which may be found on Github:
#   https://github.com/TheMatjaz/dotfiles) to an installation directory
#   (default is ~/Development/Dotfiles)
# - applies those dotfiles to the user by creating symlinks to them from the
#   home directory
# - installs the packages to be configured by the dotfiles by calling
#   new_system_packages_installer.sh
# - allows performing an update of all package managers installed by calling
#   full_system_update.sh
# ------------------------------------------------------------------------------

# Default installation directory if not passed as first parameter.
dotfiles_dir="${1:-$HOME/Development/Dotfiles}"
backup_dir="$dotfiles_dir/.original_dotfiles/"
    }
fi

# Install a set of basic packages on newly set systems, along with Oh My ZSH!
bash $dotfiles_dir/new_system_packages_installer.sh
cd $dotfiles_dir

# Creates a symbolic link to the file specified in the first argument $1
# pointing to the file specified in the second argument $2. Backups any existing
# file at the position $2 to the backup directory.
function symlink_dotfile() {
    local file_in_repo=$dotfiles_dir/$1
    local file_in_home=$HOME/$2
    if [[ -e $file_in_home && ! -L $file_in_home ]]; then
        mkdir -p $backup_dir   # prepare backup directory if not exists
        echo "Backing up existing $file_in_home into $backup_dir"
        mv $file_in_home $backup_dir
    fi
    mkdir -p $(dirname $file_in_home)   # if there is no directory for emacs.d
                                        # and .config for mc and htop
    ln -s -v -f -F $file_in_repo $file_in_home
}

# Create symlinks in the home directory that point to the files in the
# dotfiles repository. Any existing dotfiles get backupped.
echo "Symlinking..."
symlink_dotfile gitconfig .gitconfig
symlink_dotfile gitignore_global .gitignore_global
symlink_dotfile hgrc .hgrc
symlink_dotfile screenrc .screenrc
symlink_dotfile wgetrc .wgetrc
mkdir -p $HOME/.oh-my-zsh/custom/themes/  # it does not exist by default
symlink_dotfile zsh_fino_custom.zsh-theme .oh-my-zsh/custom/themes/zsh_fino_custom.zsh-theme
symlink_dotfile zsh_aliases .zsh_aliases
symlink_dotfile zsh_path .zsh_path
symlink_dotfile zshrc .zshrc
symlink_dotfile mc_ini .config/mc/ini
symlink_dotfile mc_panels.ini .config/mc/panels.ini
symlink_dotfile emacs_init.el .emacs.d/init.el

# Symlink the htop configuration file as well, but place it in ~/.htoprc on Macs
# and in ~/.config/htop/htoprc on Linux.
case $(uname) in
    'Darwin')
        symlink_dotfile htoprc .htoprc
        ;;
    'Linux')
        symlink_dotfile htoprc .config/htop/htoprc
        ;;
    *)
        echo "Cannot symlink htoprc on proper position on this operative system.
Please update this script $(basename $0) or perform the symlink manually."
        ;;
esac

# Move backup made by Oh My ZSH installer to $backup_dir
if [ -e $HOME/.zshrc.pre-oh-my-zsh ]; then
    echo "Moved old zshrc backupped by Oh My ZSH to $backup_dir"
    mkdir -p $backup_dir
    mv $HOME/.zshrc.pre-oh-my-zsh $backup_dir
fi

echo "Dotfiles installation completed."
read -p "Do you want to perform an update+upgrade of all package managers? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash $dotfiles_dir/full_system_updater.sh
else
    echo "You can peform it manually by launching
    bash $dotfiles_dir/full_system_updater.sh"
fi

# Clean some variables
unset backup_dir
unset dotfiles_dir
rm $dotfiles_dir/1

echo "Switching to zsh"
cd
env zsh

# STARTING EXECUTION HERE
# =======================

echo "\
Matjaž's dotfiles installer script
==================================

This script may perform various tasks. For freshly set systems it's raccomended
to run them all [0]. Choose your option:
"

function repl() {
    choise_menu="\
[0] all tasks
[1] pick installation directory different than default
[2] install or update dotfiles repository
[3] install packages that are beeing configured by the dotfiles
[4] create or refresh symlinks to the dotfiles in the home directory
[5] perform a complete update&upgrade of all package managers found
[6] start emacs once to make it install all the packages. Exit it with 'C-x C-c'
[7] get more information about this installer and the dotfiles
[8] exit installer"
    i=0
    while [ $i -e 100 ]; do  # prevent any misfortunate infinite loops
        i=$i+1
        case $(ask_user "What do you want to do? [0/1/.../8]") in
            0) run_all_tasks ;;
            1) pick_installation_directory ;;
            2) install_dotfiles_repo ;;
            3) install_packages_for_dotfiles ;;
            4) install_dotfiles_to_home ;;
            5) run_full_system_update ;;
            6) start_emacs ;;
            7) get_info ;;
            8) exit_installer ;;
            *) echo "Illegal command, try again.";;
        esac
    done
}

repl
