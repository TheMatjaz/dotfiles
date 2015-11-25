TODO
====

_Things to be included or fixed in the current dotfiles repository_

- find a portable solution for `zsh-syntax-highlight`. On Mac install it with
  brew, but an `Oh My ZSH` plugin would be more portable.
- include an `iTerm` color scheme file and a configuration backup
- set up `screenrc` correctly
- `curlrc`: just as `wgetrc` for the `curl` command line downloader

Completed
---------

- installer of `pip` packages
- incorporate all package manager installers and default packages installation
  into one big package-manager-installer script that detects the system:
  `apt-get`, `brew`, `pip`, `gem`
- create a portable `apt-installer` for Debian-based distributions.
- set up `wgetrc` correctly
- set up `hgrc`
- set up `htoprc`
- set up `mc` configuration file
- set up `hgignore_global` (make `hgrc` use the `gitignore_global`)
- move `oh-my-zsh` directory to home. It get's installed by the installer, there
  is no need to push/pull it on github.
- pick out of it 3 files: `zsh_aliases`, `zsh_path` and `zsh_fino_custom` custom
  theme. The rest remains untouched.
- same as of `Oh My ZSH` but for `emacs.d`: include only the `init.el` file in
  the dotfiles repository and make that file require some packages on
  startup. If they are already installed, then no problem. Otherwise they'll get
  downloaded and installed
