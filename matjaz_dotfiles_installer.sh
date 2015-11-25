#!/bin/bash
################################################################################
# Matjaž dotfiles installer script
# Copyright (c) 2015 Matjaž <dev@matjaz.it> matjaz.it
#
# Execute this script anywhere on the system. It downloads the dotfiles git
# repository in ~/Development/Dotfiles and creates symlinks from the home
# directory to the files in the dotfiles repository.
################################################################################

# Install Oh My ZSH if not already installed
if [ -d ~/.oh-my-zsh ]; then
    echo "Oh My ZSH installation found, skipping install."
else
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh -s $(which zsh)
fi

# Create dotfiles directory and clone repository into it
dotfiles_dir="$HOME/Development/Dotfiles"
backup_dir="$HOME/Development/Dotfiles/.original_dotfiles/"
mkdir -p $backup_dir
cd $dotfiles_dir
#git clone --recursive git://github.com/TheMatjaz/dotfiles.git . || exit 1

# Pick configuration files to symlink, ignore makrdown, shell scripts,
# htop configuration file and midnight commander (mc) configuration file.
# The last two are needed since their position is not the same on different OS.
symlinkables=$(ls -1 | egrep --invert-match --regexp='(^.+\.(sh|md)$)|(^mc_.+$)|(^htoprc$)')

# Create symlinks in the home directory that point to the files in the
# dotfiles repository. Backup any existing dotfile.
for file in $symlinkables; do
    if [[ -e ~/.$file && ! -L ~/.$file ]]; then
        echo "Backing up existing $file into $backup_dir"
        mv ~/.$file $backup_dir
    fi
    ln -s -v -f -F $dotfiles_dir/$file ~/.$file
done

# Symlink the htop configuration file aswell, but place it in ~/.htoprc on Macs
# and in ~/.config/htop/htoprc on Debian
file="htoprc"
case $(uname) in
    'Darwin')
        if [[ -e ~/.$file && ! -L ~/.$file ]]; then
            echo "Backing up existing $file into $backup_dir"
            mv ~/.$file $backup_dir
        fi
        ln -s -v -f -F $dotfiles_dir/$file ~/.$file
        ;;
    'Linux')
        if [[ -e ~/.config/htop/$file && ! -L ~/.config/htop/$file ]]; then
            echo "Backing up existing $file into $backup_dir"
            mv ~/.config/htop/$file $backup_dir
        fi
        ln -s -v -f -F $dotfiles_dir/$file ~/.config/htop/$file
        ;;
    *)
        echo 'Cannot symlink htoprc on proper position on this operative system. Please update this script or perform the symlink yourself.'
    ;;
esac

# Symlink the mc configuration files into ~/.config/mc/, since it's the default
# path for mc conficurations
symlinkables="mc_ini mc_panels.ini"
for file in $symlinkables; do
    file=$(echo $file | sed 's/mc_//')
    if [[ -e ~/.config/mc/$file && ! -L ~/.config/mc/$file ]]; then
        echo "Backing up existing $file into $backup_dir"
        mv ~/.config/mc/$file $backup_dir
    fi
    ln -s -v -f -F $dotfiles_dir/$file ~/.config/mc/$file
done

# Symlink the custom Oh My ZSH! theme
file="zsh_fino_custom.zsh-theme"
if [[ -e ~/.oh-my-zsh/custom/themes/$file && ! -L ~/.oh-my-zsh/custom/themes/$file ]]; then
    echo "Backing up existing $file into $backup_dir"
    mv ~/.oh-my-zsh/custom/themes/$file $backup_dir
fi
ln -s -v -f -F $dotfiles_dir/$file ~/.oh-my-zsh/custom/themes/$file

# Symlink the Emacs init.el configuration file
file="init.el"
if [[ -e ~/.emacs.d/$file && ! -L ~/.emacs.d/$file ]]; then
    echo "Backing up existing $file into $backup_dir"
    mv ~/.emacs.d$file $backup_dir
fi
ln -s -v -f -F $dotfiles_dir/$file ~/.emacs.d/$file

unset file
unset symlinkables
unset backup_dir
unset dotfiles_dir
