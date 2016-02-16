v2.0.0
===============================================================================


Added
----------------------------------------

- One `git` branch per operative system:
    - currently `debian-ubuntu` and `mac-osx`
    - removes portability issues of any configuration file or script
    - allows scalability to more operative systems
    - one operative system simply stays on its branch all the time without 
      caring for others
- Explicit license header in every file, except Markdown files


Changed
----------------------------------------

- Typo in LICENSE.md (missing "the copyright holder")
- README.md to adapt it to the new branches


Removed
----------------------------------------

- Portability of operative-system specific scripts
- Anything except README.md, LICENSE.md and CHANGELOG.md from `master` branch


v1.2.0
===============================================================================


Added
----------------------------------------

- `wget-infinite` and `wget-infinite-status` aliases to start a background
  `wget` download that retries from where it stopped until completion
- `gpg` configuration dotfile
- `gpg` signing key choise to global _git_ configuration
- `gitignore` command to easily add files to local `.gitignore` file of a _git_
  repository
- pdf files compression alias `pdfcompress`: transforms a `.pdf` to `.ps` and
  back to `.pdf`. Usually is the best compression without visible quality loss.


Changed
----------------------------------------

- OS dependant `mc` alias to start it inside its wrapper, which allows exiting
  `mc` in the directory that `mc` was showing
- Update `numerus` alias from Java version of _Numerus_ (_Numerus_) to C version
- Activate tree view in `htop`
- prettier changelog



v1.1.1
===============================================================================


Fixed
----------------------------------------

- _Emacs_ installs packages without errors when they are already installed
- Ensured execution of correct _Emacs_ init file
- Portable upgrade of `pip3`, removed errors with permissions
- Terminate dotfiles repository installation if git is not installed, but show
  a possible solution by running the `new_system_packages_installer.sh`
- `curl` installation command in Readme
- `.original_dotfiles/` is now git-ignored



v1.1.0
===============================================================================


Added
----------------------------------------

- Installer interactivity (REPL): offer 8 possible task to choose at run-time to
  allow user to perform just some (like only symlinking or git-cloning the
  repository) or all of them.
- Installer also starts Emacs to make the daemon run + to make it download all
  the packages it needs for the setup (as specified in `emacs_init.el`)
- Improved quality of console output strings



v1.0.1
===============================================================================


Fixed
----------------------------------------

- Portability fixes:
    -`zsh_path` is now portable also on non-OS X systems
    - Fix non portable home directory in `zshrc`
    - Fix non portable `zsh-syntax-highlight` Oh My ZSH plugin
- Ask user to perform or not the full system update of package managers
- Installer switches to zsh at the end of execution



v1.0.0
===============================================================================


Added
----------------------------------------

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

