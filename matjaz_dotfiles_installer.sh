#!/bin/bash
# -----------------------------------------------------------------------------
# Matjaž's dotfiles installer script for Debian or Ubuntu.
#
# >> LICENSE
# Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
# This source code form is part of the "Matjaž's dotfiles" project and is 
# subject to the terms of the BSD 3-clause license as expressed in the 
# LICENSE.md file found in the top-level directory of this distribution and at
# http://directory.fsf.org/wiki/License:BSD_3Clause
#
# >> USAGE
# Execute this script anywhere on a Debian or Ubuntu operative system to start
# the setup of Matjaž's dotfiles. There are no parameters.
#
# >> WHAT IT DOES
# It's an interactive installer of the Matjaž's dotfiles for a Debian or Ubuntu
# operative system.
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

prompt="[ DOTFILES ][ INSTALLER ]"
# Default installation directory if not passed as first parameter.
dotfiles_dir="${1:-$HOME/Development/Dotfiles}"
backup_dir="$dotfiles_dir/.original_dotfiles/"
initial_dir=$PWD
username="matjaz"
can_sudo=0


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


# Check if the user executing this command has the privileges to run a sudo
# command and store the result in the can_sudo global variable.
function executer_has_root_privileges() {
    echo "$prompt Checking your root privileges. May ask for password."
    sudo -v
    if [[ $? == 0 ]]; then
        echo "$prompt You appear to have root privileges. Awesome!"
        can_sudo=1
    else
        echo "$prompt You are NOT ABLE TO RUN SUDO COMMANDS. This script will be extremely limited in this case."
        can_sudo=0
    fi
}


# Prompts a confirmation question to get the user's choice and returns it.
# Call it with a string as prompt string, otherwise it uses the default one.
function ask_user() {
    read -r -p "${1:-$prompt Are you sure? [y/N]} " response
    echo $response
}


# Prompty the credits, license and a explanation of what this script is.
function get_info() {
    echo "
Matjaž's dotfiles
Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> http://matjaz.it
Project page with more info: https://github.com/TheMatjaz/dotfiles
BSD 3-clause license

This is an installer for the Matjaž's dotfiles. Dotfiles are configuration 
files for many programs and shells found in Unix/Linux/BSD/OS X systems. 
This installer works only on Debian or Ubuntu, for other installers read the 
repository's README file. It also installs the necessary packages that are 
beeing configured."
}


# Prompts the currently set installation directory of the dotfiles and asks
# the user to eventually change it.
function pick_installation_directory() {
    echo "$prompt The installation directory is set to:
    $dotfiles_dir"
    case $(ask_user "$prompt Is it ok for you? [Y/n]") in
        [nN]|[nN][oO])
            dotfiles_dir=$(ask_user "$prompt Type a CORRECTLY formatted path for the installation directory, even if it does not exist yet:
    ") ;;
        *)
            echo "$prompt Installation directory unchanged." ;;
    esac
}


# Create dotfiles directory, clone the GitHub repository into it or update it,
# if it the directory already exists.
function install_dotfiles_repo() {
    which git 2>&1 > /dev/null
    if [ $? != 0 ]; then
        # no git installed
        echo "$prompt Git not installed."
        if [ can_sudo == 0 ]; then
            echo "$prompt You cannot clone the dotfiles without Git. Ask your sysadmin to install it."
            return 1
        else
            echo "$prompt Updating apt-get and installing. May ask for the root password."
            sudo apt-get update
            sudo apt-get install git
        fi
    fi
    mkdir -p $dotfiles_dir || {
        echo "$prompt An error occured during the creation of the repository directory. Is the path correctly formatted?
    $dotfiles_dir
Try running [d]"
        return 1
    }
    echo "$prompt Dotfiles will be stored in $dotfiles_dir"
    if [ -d $dotfiles_dir/.git ]; then
        echo "$prompt Found existing dotfiles repository. Updating the debian-ubuntu branch."
        cd $dotfiles_dir
        git checkout debian-ubuntu || {
            echo "$prompt An error occurred during the checkout of the debian-ubuntu branch. Please try running this operation again."
            return
        }

        git pull origin debian-ubuntu || {
            echo "$prompt An error occurred during the pulling of the debian-ubuntu branch. Please try running this operation again."
            return
        }
    else
        echo "$prompt Cloning the dotfiles repository from GitHub."
        git clone -b debian-ubuntu https://github.com/TheMatjaz/dotfiles.git $dotfiles_dir || {
            echo "$prompt An error occurred during the cloning of the debian-ubuntu branch of the Matjaž's dotfiles GitHub repository. Please try running this operation again."
            return
        }
    fi
}


# Install a set of basic packages on newly set systems, along with Oh My ZSH!
function install_packages_for_dotfiles() {
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot install the packages for the dotfiles. Ask your sysadmin to do it."
        return 1
    else
        bash $dotfiles_dir/new_system_packages_installer.sh
        cd $dotfiles_dir
    fi
}


# Creates a symbolic link to the file specified in the first argument $1
# pointing to the file specified in the second argument $2. Backups any existing
# file at the position $2 to the backup directory.
function symlink_dotfile() {
    local file_in_repo=$dotfiles_dir/$1
    local file_in_home=$HOME/$2
    if [[ -e $file_in_home && ! -L $file_in_home ]]; then
        mkdir -p $backup_dir   # prepare backup directory if not exists
        echo "$prompt Backing up existing $file_in_home into $backup_dir"
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
        echo "$prompt Dotfiles repository not found. Have you installed it? Try running [e]"
        return
    fi
    echo "$prompt Creating symlinks in home directory poiting to the dotfiles repository."
    symlink_dotfile gitconfig .gitconfig
    symlink_dotfile gitignore_global .gitignore_global
    symlink_dotfile hgrc .hgrc
    symlink_dotfile screenrc .screenrc
    symlink_dotfile wgetrc .wgetrc
    symlink_dotfile zsh_fino_custom.zsh-theme .oh-my-zsh/custom/themes/zsh_fino_custom.zsh-theme
    symlink_dotfile zsh_aliases .zsh_aliases
    symlink_dotfile zsh_path .zsh_path
    symlink_dotfile zshrc .zshrc
    symlink_dotfile mc_ini .config/mc/ini
    symlink_dotfile mc_panels.ini .config/mc/panels.ini
    symlink_dotfile emacs_init.el .emacs.d/init.el
    symlink_dotfile gpg_conf .gnupg/gpg.conf
    symlink_dotfile htoprc .config/htop/htoprc
    symlink_dotfile ssh_conf .ssh/config
    symlink_dotfile sqliterc .sqliterc
    symlink_dotfile psqlrc .psqlrc
    
    # Move backup made by Oh My ZSH installer to $backup_dir
    if [ -e $HOME/.zshrc.pre-oh-my-zsh ]; then
        echo "$prompt Move old .zshrc backupped by Oh My ZSH to $backup_dir"
        mkdir -p $backup_dir  # since it may have not been created previously
                              # if no backup were done before
        mv $HOME/.zshrc.pre-oh-my-zsh $backup_dir
    fi
}


# Starts a complete update and upgrade of all packages in the system.
function run_full_system_update() {
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot update the whole system. Ask your sysadmin to do it."
        return 1
    else
        bash $dotfiles_dir/full_system_updater.sh
    fi
}


# Starts Emacs to let the it apply the Emacs init settings and download
# any Emacs packages from its repository.
function start_emacs() {
    which emacs 2>&1 > /dev/null
    if [ $? == 0 ]; then  # if emacs exists
        echo "$prompt Making emacs start so it can evaluate the emacs_init.el file to download all required packages and set the correct configuration."
        emacsclient --tty --alternate-editor="" $dotfiles_dir/emacs_init.el
    else
        echo "$prompt Emacs not installed. Try running [e]"
        return
    fi
}


# Clean some variables, files and return to initial directory where the script
# was called.
function finalize() {
    unset backup_dir
    unset dotfiles_dir
    cd $initial_dir
    unset initial_dir
}


# Terminates this script gracefully.
function exit_installer() {
    echo "$prompt Have an awesome day!"
    finalize
    exit 0
}


# (Re)Configures the system locales to avoid and collision
function setup_locale() {
    echo "$prompt Installing and reconfiguring some locales. May ask for the root password."
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot update the system's locale. Ask your sysadmin to do it."
        return 1
    else
        sudo locale-gen "it_IT.UTF-8" "en_US.UTF-8"
        sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
    fi
}


# Add a non-root user if not exists and set the shell to ZSH
function add_my_user() {
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot add users of change their settings. Ask your sysadmin to do it."
        return 1
    fi
    id -u $username &> /dev/null
    if [ $? != 0 ]; then # No user exists
        echo "$prompt Adding the user '$username'. May ask for the root password."
        sudo useradd --create-home --shell=/bin/zsh --groups=sudo $username
        sudo passwd $username
    else
        echo "$prompt A user '$username' already exists."
        case $(ask_user "Do you want to create a different user? [y/N]") in
            [yY]|[yY][eE][sS])
                username=$(ask_user "$prompt Type a CORRECTLY formatted username:
            ") 
                add_my_user # call this funcion recursively
                ;;
            *)
                echo "$prompt No new user created."
                echo "$prompt Setting ZSH as the default shell of '$username'. May ask for the root password."
                sudo usermod -s /bin/zsh $username
                ;;
        esac
    fi
}


# Change the hostname of this machine
function change_hostname() {
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot change the hostname of this machine. Ask your sysadmin to do it. I'll just add it to ~/.hostname"
        new_hostname=$(ask_user "$prompt Type a CORRECTLY formatted hostname for this machine:
        ")
        echo $new_hostname >> ~/.hostname
    else
        new_hostname=$(ask_user "$prompt Type a CORRECTLY formatted hostname for this machine:
        ")
        echo $new_hostname >> ~/.hostname
        echo "$prompt Setting the hostname. May ask for the root password."
        # For the current session
        sudo hostnamectl set-hostname $new_hostname
        # Persistently
        if [ -z $(grep "127.0.1.1" /etc/hosts) ]; then # add line or edit it if exists
            sudo echo "127.0.1.1 $new_hostname" >> /etc/hosts
        else
            sudo sed -i original -e 's/127\.0\.1\.1.*/127.0.1.1 "$new_hostname"/g' /etc/hosts
        fi
    fi
}


# If no swap exists, create a swapfile and use it as swap
function create_swapfile() {
    if [ can_sudo == 0 ]; then
        echo "$prompt You cannot create a swap file. Ask your sysadmin to do it."
        return 1
    fi
    free | grep "Swap" > /dev/null
    if [ $? != 0 ]; then # No swap exists
        echo "$prompt Creating and setting up a 2 GB swap file. May ask for the root password."
        # Create an empty file /swapfile with correct permissions
        sudo dd if=/dev/zero of=/swapfile bs=128M count=16
        sudo chmod 600 /swapfile
        # Make it a swap file and enable it
        sudo mkswap /swapfile
        sudo swapon /swapfile
        # Make it persist after reboot
        sudo echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
        echo "$prompt Setting the swappiness to 10"
        # Set swappiness (0% = keeps all in memory, 100% frees the memory ASAP)
        sudo sysctl vm.swappiness=10
        # Make it persist after reboot
        sudo echo "vm.swappiness=10" >> /etc/sysctl.conf
    fi
}


# Runs all options of the repl in sequence.
function run_all_tasks() {
    setup_locale
    add_my_user
    pick_installation_directory
    install_dotfiles_repo
    install_packages_for_dotfiles
    install_dotfiles_to_home
    run_full_system_update
    change_hostname
    create_swapfile
    start_emacs
    exit_installer
}


# Prints an explanation at the beginning of the script
function welcome_message() {
    echo "
Matjaž's dotfiles installer script for Debian or Ubuntu
=======================================================

This script may perform various tasks. For freshly set systems it's raccomended
to run them all [A]. Choose your option:"
}


# Main menu of the script.
# Starts a Read-Evaluate-Print-Loop that offers various options.
function repl() {
    local choise_menu="
-------------
[A] all tasks (sudo)
[b] setup the system's locale (sudo)
[c] add your user (sudo)
[d] pick installation directory different than default
[e] install or update dotfiles repository
[f] install packages that are beeing configured by the dotfiles (sudo)
[g] create or refresh symlinks to the dotfiles in the home directory
[h] perform a complete update&upgrade of all package managers found (sudo)
[i] change the hostname of this machine (partially sudo)
[j] add the swap if it does not exist yet (sudo)
[k] start emacs once to make it install all the packages. Exit it with 'C-x C-c'
[l] get more information about this installer and the dotfiles
[q] exit installer
"
    local i=0
    while [ $i -le 100 ]; do  # prevent any misfortunate infinite loops
        ((i++))
        echo "$choise_menu"
        case $(ask_user "$prompt What do you want to do? [0/1/.../8]") in
            A) run_all_tasks ;;
            b) setup_locale ;;
            c) add_my_user ;;
            d) pick_installation_directory ;;
            e) install_dotfiles_repo ;;
            f) install_packages_for_dotfiles ;;
            g) install_dotfiles_to_home ;;
            h) run_full_system_update ;;
            i) change_hostname ;;
            j) create_swapfile ;;
            k) start_emacs ;;
            l) get_info ;;
            q) exit_installer ;;
            *) echo "$prompt Illegal command, try again." ;;
        esac
    done
}


# ACTUAL EXECUTION
verify_operative_system
executer_has_root_privilege
welcome_message
repl

