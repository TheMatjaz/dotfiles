#!/bin/bash
# -----------------------------------------------------------------------------
# Matjaž's dotfiles installer script
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
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
# -----------------------------------------------------------------------------

# Default installation directory if not passed as first parameter.
dotfiles_dir="${1:-$HOME/Development/Dotfiles}"
backup_dir="$dotfiles_dir/.original_dotfiles/"
initial_dir=$PWD

# Prompts a confirmation question to get the user's choice and returns it.
# Call it with a string as prompt string, otherwise it uses the default one.
function ask_user() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    echo $response
}

function get_info() {
    echo "
Matjaž's dotfiles
Copyright (c) 2015, Matjaž Guštin <dev@matjaz.it> http://matjaz.it
Project page with more info: https://github.com/TheMatjaz/dotfiles
BSD 3-clause license

This is an installer for the dotfiles (configuration files for many programs
and shells found in *nix systems) for my usage. The installer works on OS X
or Linux. It also installs the necessary packages that are beeing configured
by the dotfiles themselves."
}

function pick_installation_directory() {
    echo "The installation directory is set to:
    $dotfiles_dir"
    case $(ask_user "Is it ok for you? [Y/n]") in
        [nN]|[nN][oO])
            dotfiles_dir=$(ask_user "Type a correctly formatted path for the installation directory, even if it does not exist yet:
    ") ;;
        *)
            echo "Installation directory unchanged." ;;
    esac
}

# Create dotfiles directory and clone repository into it or update it, if it
# already exists
function install_dotfiles_repo() {
    which git 2>&1 > /dev/null
    if [ $? != 0 ]; then  # no git installed
        echo "Git not found. Please install it first, the repository cannot be cloned without it. The following command should do the trick (it's basically running the option [3] - just without Git)
    bash -c '$(wget https://raw.github.com/TheMatjaz/dotfiles/master/new_system_packages_installer.sh -O -)'
or use curl, if you don't have wget:
    bash -c '$(curl -fsSL https://raw.github.com/TheMatjaz/dotfiles/master/new_system_packages_installer.sh)'
"
        exit 1
    fi
    mkdir -p $dotfiles_dir || {
        echo "An error occured during the creation of the repository directory. Is the path correctly formatted?
    $dotfiles_dir
Try running [1]"
        return
    }
    echo "Dotfiles will be stored in $dotfiles_dir"
    if [ -d $dotfiles_dir/.git ]; then
        echo "Found existing dotfiles repository. Updating it."
        cd $dotfiles_dir
        git checkout master
        git pull
        git checkout - # return to previous branch
    else
        echo "Cloning the dotfiles repository from GitHub."
        git clone https://github.com/TheMatjaz/dotfiles.git $dotfiles_dir || {
            echo "An error occurred during the cloning of the dotfiles repository. Please try running this script again."
            return
        }
    fi
}

# Install a set of basic packages on newly set systems, along with Oh My ZSH!
function install_packages_for_dotfiles() {
    bash $dotfiles_dir/new_system_packages_installer.sh
    cd $dotfiles_dir
}

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
function install_dotfiles_to_home() {
    if [ ! -d $dotfiles_dir/.git ]; then
        echo "Dotfiles repository not found. Have you installed it? Try running [2]"
        return
    fi
    echo "Creating symlinks in home directory poiting to the dotfiles repository."
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
    symlink_dotfile gpg_conf .gnupg/gpg.conf

    # Symlink the htop configuration file as well, but place it in ~/.htoprc on
    # OS X and in ~/.config/htop/htoprc on Linux.
    case $(uname) in
        'Darwin')
            symlink_dotfile htoprc .htoprc
            ;;
        'Linux')
            symlink_dotfile htoprc .config/htop/htoprc
            ;;
        *)
            echo "Cannot symlink htoprc on proper position on this operative system. Please update this script $0 or perform the symlink manually."
            ;;
    esac

    # Move backup made by Oh My ZSH installer to $backup_dir
    if [ -e $HOME/.zshrc.pre-oh-my-zsh ]; then
        echo "Move old .zshrc backupped by Oh My ZSH to $backup_dir"
        mkdir -p $backup_dir  # since it may have not been created previously
                              # if no backup were done before
        mv $HOME/.zshrc.pre-oh-my-zsh $backup_dir
    fi
}

function run_full_system_update() {
    bash $dotfiles_dir/full_system_updater.sh
}

function start_emacs() {
    which emacs 2>&1 > /dev/null
    if [ $? == 0 ]; then  # if emacs exists
        echo "Making emacs start so it can evaluate the emacs_init.el file to download all required packages and set the correct configuration."
        emacsclient --tty --alternate-editor="" $dotfiles_dir/emacs_init.el
    else
        echo "Emacs not installed. Try running [3]"
        return
    fi
}

# Clean some variables, files and return to initial directory where the script
# was called
function finalize() {
    unset backup_dir
    unset dotfiles_dir
    cd $initial_dir
    unset initial_dir
}

function exit_installer() {
    echo "Have an awesome day!"
    finalize
    exit 0
}

function run_all_tasks() {
    pick_installation_directory
    install_dotfiles_repo
    install_packages_for_dotfiles
    install_dotfiles_to_home
    run_full_system_update
    start_emacs
    exit_installer
}



# STARTING EXECUTION HERE
# =======================

echo "
Matjaž's dotfiles installer script
==================================

This script may perform various tasks. For freshly set systems it's raccomended
to run them all [0]. Choose your option:"

function repl() {
    local choise_menu="
-------------
[0] all tasks
[1] pick installation directory different than default
[2] install or update dotfiles repository
[3] install packages that are beeing configured by the dotfiles
[4] create or refresh symlinks to the dotfiles in the home directory
[5] perform a complete update&upgrade of all package managers found
[6] start emacs once to make it install all the packages. Exit it with 'C-x C-c'
[7] get more information about this installer and the dotfiles
[8] exit installer
"
    local i=0
    while [ $i -le 100 ]; do  # prevent any misfortunate infinite loops
        ((i++))
        echo "$choise_menu"
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

