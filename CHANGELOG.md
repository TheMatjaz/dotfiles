v1.1.1
======

Fixed
-----

- _Emacs_ installs packages without errors when they are already installed
- Ensured execution of correct _Emacs_ init file
- Portable upgrade of `pip3`
- Terminate dotfiles repository installation if git is not installed.

v1.1.0
======

Added
-----

- Installer interactivity (REPL): offer 8 possible task to choose at run-time
to allow user to perform just some (like only symlinking or git-cloning the
repository) or all of them.
- Installer also starts Emacs to make the daemon run + to make it download all
the packages it needs for the setup (as specified in `emacs_init.el`)
- Improved quality of console output strings


v1.0.1
======

Fixed
-----

- Portability fixes:
    -`zsh_path` is now portable also on non-OS X systems
    - Fix non portable home directory in `zshrc`
    - Fix non portable `zsh-syntax-highlight` Oh My ZSH plugin
- Ask user to perform or not the full system update of package managers
- Installer switches to zsh at the end of execution


v1.0.0
======

Added
-----

- Dotfiles for:
    - Emacs
    - Git
    - Mercurial `hg`
    - Wget
    - Oh My ZSH! with aliases and theme
    - Screen 
    - Midnight Commander `mc`
    - htop
- Scripts for:
    - installing the dotfiles repository along with the packages the dotfiles
      are meant for
    - updating the whole system
- Other:
    - list of mostly useful packages
    - license, readme and this changelog
