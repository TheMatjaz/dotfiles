Matjaž Dotfiles Repository
==========================

_a.k.a. yet another dotfiles repo but now with powerful installer scripts_

Contained files
---------------

#### Configuration files

- [`zshrc`](zshrc): general
  [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) settings
- [`zsh_path`](zsh_path): `$PATH` variable setting and `export` settings, like
  default text editors and so on
- [`zsh_aliases`](zsh_aliases): custom aliases and functions for the zsh
- [`zsh_fino_custom.zsh-theme`](zsh_fino_custom.zsh-theme): a customized `fino`
  theme for _Oh My ZSH!_
- [`gitconfig`](gitconfig): general _Git_ settings
- [`gitignore_global`](gitignore_global): a list of files _Git_ should ignore in
  any repository
- [`hgrc`](hgrc): general _Mercurial_ settings
- [`emacs_init.el`](emacs_init.el): _Emacs_ configuration that also installs some
  ELPA packages, if not already installed, to completely clone an existing
  configuration
- [`htoprc`](htoprc): looks and columns for `htop` process viewer
- [`screenrc`](screenrc): basic settings of `screen` terminal multiplexer
- [`wgetrc`](wgetrc): global configurations of the `wget` command line
  downloader


#### Installer/automation scripts

Those scripts are meant to be portable, so they react differently based on the
operative system. Currently are implemented for _OS X_ and _Linux
Debian/Ubuntu_.

- [`matjaz_dotfiles_installer.sh`](matjaz_dotfiles_installer.sh) **does all the
  work for you** (see _Installation_ section below). It's an interactive installer
  which allows:
    - downloading this repository
    - downloading all the required packages for the dotfiles, like _Emacs_ or
      _Oh My ZSH!_
    - placing the proper symlinks to activate the dotfiles
    - performing system updates
    - and a few more small things
- [`new_system_packages_installer.sh`](new_system_packages_installer.sh)
  installs some packages which the Matjaž's dotfiles are for. It calls the
  system's package manager. Currently only for `brew` + `brew cask` or
  `apt-get`. Can be run stand-alone but the `matjaz_dotfiles_installer.sh` calls
  it for you as well.
- [`full_system_updater.sh`](full_system_updater.sh) just like
  `new_system_packages_installs.sh` detects the operative system and updates all
  the packages of its package managers. Currently only for `brew` + `brew cask`
  or `apt-get`, `pip3` and `gem`. Can be run stand-alone but the
  `matjaz_dotfiles_installer.sh` calls it for you as well.
- [`useful_packages.md`](useful_packages.md) is a simple list containing
  packages generally worth installing on any system (it's not an executable,
  just a memo).


Installation
------------

All you need to do is download and run the
[`matjaz_dotfiles_installer.sh`](matjaz_dotfiles_installer.sh) which should
handle all the rest with an **interactive command line interface**. It installs
the dotfiles repository in `~/Development/Dotfiles` (by default), all the
required packages, _HomeBrew_ and _Oh My ZSH!_.

_Git_ is obviously required to clone the repository.

**Just run one of the following commands** to download, install and activate this dotfiles
  repository, either by `wget` or `curl`.

##### Using `wget`
```bash
bash -c "$(wget https://raw.github.com/TheMatjaz/dotfiles/master/matjaz_dotfiles_installer.sh -O -)"
```

##### Using `curl`
```bash
bash -c "$(curl -fsSL https://raw.github.com/TheMatjaz/dotfiles/master/matjaz_dotfiles_installer.sh)"
```

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
- [Oh My ZSH installation scripts](http://github.com/robbyrussell/oh-my-zsh/tree/master/tools)

Some really useful documentation about the dotfiles repositories may be found
here:

- [Getting started with dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789),
  great for beginners
- [Dotfiles are meant to be forked](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/)
  by Holman
- [Using Git and GitHub to manage your dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
