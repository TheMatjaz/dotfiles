Change Log
================================================================================

All notable changes to the project _Matjaž's dotfiles_ will be documented in
this file. This project adheres to [Semantic Versioning](http://semver.org/).


v2.1.0
----------------------------------------


### Added

- Aliases:
    - `gpg` instead of `gpg2`.
    - `weather` forecast.
    - `py` instead of `python3`.
    - `dot` for the dotfiles directory.
    - `pipupgrade` to upgrade all globally installed Python3 packages.
    - `traffic` for the LTE quota.
    - `filetypes` in a directory recursively.
    - [Mac] `httpserve` serve a directory with an HTTP server in python.
    - [Mac] `cmdc` and `cmdv` aliases to interact with the clipboard.
    - [Mac] `information` about a file, all of it.
    - [Mac] `thumbnailize` to create 600px wide thumbnails for my blog.
    - [Mac] `htop` instead of `sudo htop`
- New dotfiles:
    - For SQLite's command line interface `sqlite`.
    - For PostgreSQL command line interface `psql`.
    - `ssh` configuration file.
- New function: 
    - Python virtual enviroment ZSH prompt and function to `activate` it.
    - `isodate` and `unixtime` function to quickly get the two most standard
      formats, but also to convert them.
- More files for Git to ignore:
    - Netbeans.
    - C objects.
    - LaTeX generated files (except for `pdf`).
- Emacs new settings:
    - Spell checking with aspell.
    - Better tabbing, untabbing and newline behaviour.
    - Backup and auto-save file are created to the `~/.emacs.d/` directory.
    - Session restore on Emacs start.
    - Open new files in buffers, not frames.
    - Deactivate bell sound.
- Ubuntu Server configuration:
    - Swapfile creation.
    - Hostname setup.
    - User setup (adding a user, user's shell).
    - Installing an updated Git.
    - System locale.
- Oh My Zsh Autojump with the `j` command.
- Update Node.js packages in the `full_system_updater.sh`.
- `mosh` gets installed on all systems.
- [Ubuntu] The installed behaves differently if the user has no root 
  permissions.
- [Ubuntu] The script catches a SIGINT (CTRL+C)
- [Mac] MacTeX executables added to `$PATH`.
- [Mac] Homebrew formulas are installed with the options they need.
- [Mac] More, more, more Homebrew formulas and fasks.


## Changed

- Prompts are improved: each script has its own so you know what is running.
- Improved `gitignore` function to accept multiple files and show the content 
  of `.gitignore` if no file is given.
- Default `git push` is set to `simple`.
- ZSH theme has a very cool `r☢☢t` warning when superuser.
- Theme file reorganization.
- Midnight commander's configuration was revisited.
- [Ubuntu] Git gets installed by `apt-get` if does not pre-exists on the 
  Ubuntu/Debian system.
- [Mac] Updated `psql` alias to PostgreSQL 9.5.
- [Mac] `htop` was updated from v0.8.x to v2.x.x.


## Removed

- [Ubuntu] `apt-get dist-upgrade` was removed, substituted with `upgrade` for 
  compatibily of the upgraded programs.


## Fixed

- The title sizes in this changelog and the header to make it compatible
  with the [Keep a Changelog](http://keepachangelog.com) format.
- Syntax errors in the code.
- [Ubuntu] Wrong `gpg` package name.
- [Ubuntu] `wget` instead of `curl`.



v2.0.0
----------------------------------------


### Added

- One `git` branch per operative system:
    - currently `debian-ubuntu` and `mac-osx`
    - removes portability issues of any configuration file or script
    - allows scalability to more operative systems
    - one operative system simply stays on its branch all the time without 
      caring for others
- Explicit license header in every file, except Markdown files


### Changed

- Typo in `LICENSE.md` (missing "the copyright holder")
- Adapted `README.md` to the new branches


### Removed

- Portability of operative-system specific scripts
- Anything except `README.md`, `LICENSE.md` and `CHANGELOG.md` from `master` 
  branch
  

### Fixed

Nothing.



v1.2.0
----------------------------------------


### Added

- `wget-infinite` and `wget-infinite-status` aliases to start a background
  `wget` download that retries from where it stopped until completion
- `gpg` configuration dotfile
- `gpg` signing key choise to global _git_ configuration
- `gitignore` command to easily add files to local `.gitignore` file of a _git_
  repository
- pdf files compression alias `pdfcompress`: transforms a `.pdf` to `.ps` and
  back to `.pdf`. Usually is the best compression without visible quality loss.


### Changed

- OS dependant `mc` alias to start it inside its wrapper, which allows exiting
  `mc` in the directory that `mc` was showing
- Update `numerus` alias from Java version of _Numerus_ (_Numerus_) to C version
- Activate tree view in `htop`
- Prettier changelog


### Removed

Nothing.


### Fixed

Nothing.



v1.1.1
----------------------------------------


### Added

Nothing.


### Changed

Nothing.


### Removed

Nothing.


### Fixed

- _Emacs_ installs packages without errors when they are already installed
- Ensured execution of correct _Emacs_ init file
- Portable upgrade of `pip3`, removed errors with permissions
- Terminate dotfiles repository installation if git is not installed, but show
  a possible solution by running the `new_system_packages_installer.sh`
- `curl` installation command in Readme
- `.original_dotfiles/` is now git-ignored



v1.1.0
----------------------------------------


### Added

- Installer interactivity (REPL): offer 8 possible task to choose at run-time to
  allow user to perform just some (like only symlinking or git-cloning the
  repository) or all of them.
- Installer also starts Emacs to make the daemon run + to make it download all
  the packages it needs for the setup (as specified in `emacs_init.el`)
- Improved quality of console output strings

### Changed

Nothing.


### Removed

Nothing.


### Fixed

Nothing.



v1.0.1
----------------------------------------


### Added

Nothing.


### Changed

Nothing.


### Removed

Nothing.


### Fixed

- Portability fixes:
    -`zsh_path` is now portable also on non-OS X systems
    - Fix non portable home directory in `zshrc`
    - Fix non portable `zsh-syntax-highlight` Oh My ZSH plugin
- Ask user to perform or not the full system update of package managers
- Installer switches to zsh at the end of execution



v1.0.0
----------------------------------------


### Added

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


### Changed

Nothing.


### Removed

Nothing.


### Fixed

Nothing.
