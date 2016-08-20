Matjaž's dotfiles
===============================================================================

Highly customized dotfiles with one operative system per branch and powerful
installer and updater scripts.


What are dotfiles anyway?
----------------------------------------

Dotfiles are user's configuration files on Unix/Linux/BSD/OS X operative 
systems. Their filename begins with a dot `.` (thus the name _dotfiles_), 
making them hidden files; they are usually places in the user's home 
directory `~`.

Having a published repository of your whole system configuration (with some 
installers), allows fast and no-pain set-up of any newly installed machine 
anywhere, especially some servers that are controlled only by command line 
by `ssh`.


Installation of _Matjaž's dotfiles_
----------------------------------------

This repository has no installers and other scripts on the `common` branch but
there is **one _Git_ branch for each operative system**. This helps using the
OS-specific packager managers (`apt-get`, `brew`, ...) and make OS-specific
changes (for instance `htop` has different configurations on Linux and OS X).

**To install _Matjaž's dotfiles_, run one of the following commands**. It 
downloads and runs the installer for your specific OS found in that OS's branch.

The installer should handle all the rest with an **interactive command line 
interface**. It installs the dotfiles repository (by default in 
`~/Development/Dotfiles`, but you can change that), all the required packages, 
_HomeBrew_ (OS X only) and _Oh My ZSH!_.

_Git_ is required by the installer to clone the branch of your OS.


### Debian/Ubuntu

Basically Linuxes with `apt-get`.

```bash
# Using wget
bash -c "$(wget https://raw.github.com/TheMatjaz/dotfiles/debian-ubuntu/matjaz_dotfiles_installer.sh -O -)"

# Using curl
bash -c "$(curl -fsSL https://raw.github.com/TheMatjaz/dotfiles/debian-ubuntu/matjaz_dotfiles_installer.sh)"
```


### Apple OS X (Mac)

> **CAUTION!**  
> This installer has NEVER BEEN TESTED because I have not yet installed another
> OS X system. Use it at your own risk.

```bash
# Using curl
bash -c "$(curl -fsSL https://raw.github.com/TheMatjaz/dotfiles/mac-osx/matjaz_dotfiles_installer.sh)"
```


### Other OSs

No other OSs yet, but any contribution is welcome!


What is each dotfile for?
----------------------------------------

#### Configuration files

- [`zshrc`](zshrc): general
  [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) settings
- [`zsh_path`](zsh_path): `$PATH` variable setting and `export` settings, like
  default text editors and so on
- [`zsh_aliases`](zsh_aliases): custom aliases and functions for the zsh
- [`zsh_fino_custom.zsh-theme`](zsh_fino_custom.zsh-theme): a customized `fino`
  theme for _Oh My ZSH!_
- [`gitignore_global`](gitignore_global): a list of files _Git_ should ignore in
  any repository. Those are used also by Mercurial
- [`emacs_init.el`](emacs_init.el): _Emacs_ configuration that also installs 
  some ELPA packages, if not already installed, to completely clone an existing
  configuration

The others are pretty obvious from the filenames alone.


#### Installers/automation scripts

- [`matjaz_dotfiles_installer.sh`](matjaz_dotfiles_installer.sh) **does all the
  work for you** (see _Installation_ section above). It's an interactive 
  installer which allows:
    - downloading this repository
    - downloading all the required packages for the dotfiles, like _Emacs_ or
      _Oh My ZSH!_
    - placing the proper symlinks to activate the dotfiles
    - performing system updates
    - and a few more small things such as locale setting, hostname, swapfile
- [`new_system_packages_installer.sh`](new_system_packages_installer.sh)
  installs some packages which the Matjaž's dotfiles are for. It calls the
  system's package manager. **Can be run stand-alone**. The 
  `matjaz_dotfiles_installer.sh` calls it for you as well.
- [`full_system_updater.sh`](full_system_updater.sh) just like
  `new_system_packages_installs.sh` detects the operative system and updates all
  the packages of its package managers. **Can be run stand-alone**.
  The `matjaz_dotfiles_installer.sh` calls it optionally during the install.
- [`useful_packages.md`](useful_packages.md) is a simple list containing
  packages generally worth installing on any system (it's not an executable,
  just a memo). It is not available on the `common` branch.


License
----------------------------------------

This dotfiles repository and all its files are released under the
[BSD 3-clause license](LICENSE.md).


Thanks to
----------------------------------------

Those repositories were used as a huge inspiration, some functions and
aliases were also taken from them. All of those repositories are subject to the
[MIT license](https://opensource.org/licenses/MIT), released by their respective
owners.

- [Mathias Bynens's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Holman's dotfiles](https://github.com/holman/dotfiles)
- [Joined's dotfiles](https://github.com/joined/dotfiles)
- [A huge list of other dotfiles repositories](https://dotfiles.github.io)
- [Oh My ZSH installation scripts](http://github.com/robbyrussell/oh-my-zsh/tree/master/tools)

Some really useful documentation about the dotfiles repositories may be found
here:

- [Getting started with dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789),
  great for beginners
- [Dotfiles are meant to be forked](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/)
  by Holman
- [Using Git and GitHub to manage your dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
