Matjaž Dotfiles Repository
==========================

_a.k.a. yet another dotfiles repo_

Features
--------

### Configuration files

- [`zshrc`](zshrc): general
  [_Oh My ZSH!_](https://github.com/robbyrussell/oh-my-zsh) settings
- [`zsh_path`](zsh_path): `$PATH` variable setting and `export` settings, like
  default text editors and so on
- [`zsh_aliases`](zsh_aliases): custom aliases and functions for the zsh
- [`zsh_fino_custom.zsh-theme`](zsh_fino_custom.zsh-theme): a customized `fino`
  theme for _Oh My ZSH!_
- [`gitconfig`](gitconfig): general Git settings
- [`gitignore_global`](gitignore_global): a list of files Git should ignore in
  any repository
- [`init.el`](init.el): Emacs configuration that also installs some ELPA
  packages, if not already installed, to completely clone an existing
  configuration
- [`hgrc`](hgrc): general Mercurial settings
- [`htoprc`](htoprc): looks and columns for `htop` process viewer
- [`screenrc`](screenrc): basic settings of `screen` terminal multiplexer
- [`wgetrc`](wgetrc): global configurations of the `wget` command line
  downloader


### Installer/automation scripts

Those scripts are meant to be portable, so they react differently based on the
operative system. Currently are implemented for OS X and Linux Debian/Ubuntu.

- [`matjaz_dotfiles_installer.sh`](matjaz_dotfiles_installer.sh) installs _Oh My
  ZSH!_, if not already installed, clones this dotfiles repository and creates
  symlinks in the home directory to the just git-cloned dotfiles configuration
  files.
- [`new_system_packages_installer.sh`](new_system_packages_installer.sh) which
  installs some basic packages from the main package manager of the current
  operating system. Currently only for `brew` + `brew cask` or `apt-get` and
  `pip3` installed, and a bunch of basic useful formulas.
- [`full_system_updater.sh`](full_system_updater.sh) just like
  `new_system_packages_installs.sh` detects the operative system and updates
  all the packages of its package managers: currently only for `brew` + `brew
  cask` or `apt-get`, `pip3` and `gem`.


Installation
------------

All you need to do is download and run the
[`matjaz_dotfiles_installer.sh`](matjaz_dotfiles_installer.sh) which should
handle all the rest. It installs the dotfiles repository in
`~/Development/Dotfiles`. Change that setting in the file, if needed.

Run the following command to perform the whole job:

```bash
bash -c "$(wget https://raw.github.com/TheMatjaz/dotfiles/master/matjaz_dotfiles_installer.sh -O -)"
```

After that I suggest running the
[`new_system_packages_installer.sh`](new_system_packages_installer.sh), which is
located in the dotfiles repository (default in `~/Development/Dotfiles`),
especially on freshly installed systems:

```bash
bash new_system_packages_installer.sh
```

It ask for root password just for `gem` updates.

License
-------

This dotfiles repository is released under the
[BSD 3-clause license](LICENSE.md).


Thanks to
---------

Those repositories were used as a huge inspiration, some functions and
aliases were also taken from them. All of those repositories are subject to the
[MIT license](https://opensource.org/licenses/MIT), released by their respective
owners.

- [Mathias Bynens's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [Joined's dotfiles](https://github.com/joined/dotfiles)

Some really useful documentation about the dotfiles repositories may be found
here:

- [Getting started with dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789),
  great for beginners
- [Dotfiles are meant to be forked](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/)
  by Holman
- [Using Git and GitHub to manage your dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
