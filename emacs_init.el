; -----------------------------------------------------------------------------
; Matjaž's dotfiles Emacs configuration file
;
; Copyright (c) 2015-2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
; This source code form is part of the "Matjaž's dotfiles" project and is 
; subject to the terms of the BSD 3-clause license as expressed in the 
; LICENSE.md file found in the top-level directory of this distribution and at
; http://directory.fsf.org/wiki/License:BSD_3Clause
; -----------------------------------------------------------------------------

;;; ====================================================================
;;; INTERNAL SETTINGS
;;; ====================================================================


;;; Backup files settings
;; Create all backup files "FILENAME~" in the same directory
(setq backup-directory-alist `(("." . "~/.emacs.d/emacs-backups/")))
;; Create all auto-save files "#FILENAME#" in the same directory
(setq auto-save-file-name-transforms `((".*" ,"~/.emacs.d/emacs-auto-saves/" t)))
;; Always make backups by copying. Slow but keeps the file intergrity
;; if that's too slow for some reason you might also have a look at 
;; `backup-by-copying-when-linked`
(setq backup-by-copying t    ; Don't delink hardlinks                           
      delete-old-versions t  ; Clean up the backups                             
      version-control t      ; Use version numbers on backups,                  
      kept-new-versions 6    ; keep some new versions                           
      kept-old-versions 2)   ; and some old ones, too  


;;; Package manager settings
;;; Set repositories to pick packages from for correct versions of Emacs
(when (>= emacs-major-version 24)
  (require 'package) ;; "package" is the package manager
  (dolist (source '(
                    ("melpa" . "http://melpa.milkbox.net/packages/")
                    ("gnu" . "http://elpa.gnu.org/packages/")
                    ("marmalade" . "http://marmalade-repo.org/packages/")
                    ;("elpa" . "http://tromey.com/elpa/")
                    ))    
    (add-to-list 'package-archives source t))
(package-initialize) ; Activate all the packages (in particular autoloads)
)

;;; Update packages list (like apt-get update) when there is none
;;; This happens only for freshly installed Emacs
(when (not package-archive-contents)
  (package-refresh-contents))

;;; List necessary/useful pakcages to be installed
(defvar my-package-list '(
s
f
2048-game
auto-complete
auto-complete-clang
autopair
base16-theme
dash
db
db-pg
diff-hl
ecb
fill-column-indicator
flymake
flymake-cppcheck
flymake-easy
flymake-json
flymake-python-pyflakes
flymake-shell
git
hydra
kv
markdown-mode
markdown-mode+
org
pg
popup
yasnippet
) "A list of packages to ensure are installed at launch.")

;;; Install the missing packages from previous list
(dolist (pack my-package-list)
    (when (not (package-installed-p pack))
        (package-install pack)))

(package-initialize)

;;; ====================================================================
;;; EDITOR LOOK
;;; ====================================================================

;;; Font
(set-default-font "Menlo 15")
(set-frame-font "Menlo-15" t) ; for graphical frames

;;; Cursor format
(setq-default cursor-type '(bar . 2)) ; form and pixel width
(blink-cursor-mode 1) ; blinking

;;; Highlight current line
(global-hl-line-mode 1)
(set-face-foreground 'highlight nil) ; To keep syntax highlighting in the current line
(set-face-background 'hl-line "#292929")

;;; "Bend" current line to when is longer than screen
;(setq toggle-truncate-lines nil)
(global-visual-line-mode 1) 

;;; Remove splash screen (buffer) on start
(setq inhibit-startup-message t)

;;; Remove scratch text
(setq initial-scratch-message nil)

;;; Mode line (a.k.a. Status bar)
(size-indication-mode t)
(column-number-mode t)
(display-time-mode t)

;;; Line number settings
; Activate linum
(global-linum-mode 1)
; Set numbers to dynamically adjust to the lines in the buffer and flush right
(setq linum-format 'dynamic)

;;; Window margins
;(defun xah-toggle-margin-right ()
;  "Toggle the right margin between `fill-column' or window width.
;   This command is convenient when reading novel, documentation."
;  (interactive)
;  (if (eq (cdr (window-margins)) nil)
;      (set-window-margins nil 0 (- (window-body-width) fill-column))
;    (set-window-margins nil 0 0) ) )

;;; If GUI, remove toolbar (with icons) and scrollbar
(if
(display-graphic-p)
(progn
(tool-bar-mode -1)
(scroll-bar-mode -1)))

;;; Start GUI frames maximized
(toggle-frame-maximized)

;;; Theme and colors
(load-theme 'base16-atelierforest-dark t)

;;; Emacs code browser: file viewer panels
;(require 'ecb)
;(require 'ecb-autoloads)


;;; ====================================================================
;;; EDITOR USAGE AND ACTIONS
;;; ====================================================================


;;; Keep  a list of recently opened files
(recentf-mode 1) ;
    
;;; Automatically reload file in buffer, when file content changes
(global-auto-revert-mode t)

;;; Tabs and indentation
;; make indentation commands use space only (never tab character)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'insert-tab)
(setq tab-stop-list (number-sequence 0 200 4))
(electric-indent-mode 0)

; Shift+Tab (Backtab) removes indentation
(global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
"remove 4 spaces from beginning of of line"
 (interactive)
   (save-excursion
     (save-match-data
       (beginning-of-line)
       ;; get rid of tabs at beginning of line
       (when (looking-at "^\\s-+")
         (untabify (match-beginning 0) (match-end 0)))
       (when (looking-at (concat "^" (make-string tab-width ?\ )))
         (replace-match "")))))

(setq-default c-basic-offset 4 c-default-style "linux")
;(define-key c-mode-base-map (kbd "RETURN") 'newline-and-indent)

;;; Automatically close the pairing brackets
;(require 'autopair)
;(autopair-global-mode 1)
;(setq autopair-autowrap t)
(electric-pair-mode 1)

;;; Highlight matching parenthesis
(show-paren-mode 1) ; turn on paren match highlighting
(setq show-paren-style 'parenthesis) ; highlight entire bracket expression

;;; Saving or writing a file silently puts a newline at the end if there
;;; isn’t already one there
(setq require-final-newline t)

;;; Require 'y', 'n' instead of "yes" and "no" when asking
(fset 'yes-or-no-p 'y-or-n-p)

;;; When killing a line, kill also the \n(\r) character
(setq kill-whole-line t)

;;; Kill (C-w) and copy (M-w) act on the current line if no text is visually selected.
;;; http://www.emacswiki.org/emacs/WholeLineOrRegion
(defun kill-ring-save-with-whole-line (beg end flash) 
      (interactive (if (use-region-p)
                       (list (region-beginning) (region-end) nil)
                     (list (line-beginning-position)
                           (line-beginning-position 2) 'flash)))
      (kill-ring-save beg end)
     (message "Copied.")
      (when flash
        (save-excursion
          (if (equal (current-column) 0)
              (goto-char end)
            (goto-char beg))
          (sit-for blink-matching-delay))))
(global-set-key [remap kill-ring-save] 'kill-ring-save-with-whole-line)

;;; If terminal, enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
			       (interactive)
			       (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
			       (interactive)
			       (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t))


;;; Vertical ruler at column 80
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(setq fci-rule-character ?│)
(setq fci-rule-width 1)
(setq fci-rule-color "darkred")
;; Activate always as a global minor mode
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)


;;; Set wrapping of lines with newlines at column 80 when pressing M-q
(setq-default fill-column 80)
;(auto-fill-mode 1)

;(setq mac-option-modifier 'meta)
;(setq mac-command-modifier 'none)

;;; Set left option key (alt) as 'meta', while right stays 'option', unbinded
;;; Useful to do meta-something commands on the left and alt-key symbols on the right
(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)


;;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time


;===============

;;; C/C++ code autocomplete
;;; Make sure to install autocomplete and yasnipper before installing auto-complete-clang

;;; yasnippet setup 
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")


(require 'auto-complete-clang)
;(define-key c++-mode-map (kbd "C-<space>") 'ac-complete-clang)

;;; Flymake code syntax check on the fly
(require 'flymake)

;;; ====================================================================
;;; MODES
;;; ====================================================================


;;; crontab mode
(add-to-list 'auto-mode-alist '("\\.cron\\(tab\\)?\\'" . crontab-mode))
(add-to-list 'auto-mode-alist '("cron\\(tab\\)?\\."    . crontab-mode))

;;; gnuplot mode
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.plt$" . gnuplot-mode))
			      auto-mode-alist))
(setq gnuplot-program "/usr/local/bin/gnuplot")

;;; ido mode - autocompleting for C-f
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)


;;; ====================================================================
;;; OTHER
;;; ====================================================================

;;; tramp settings for opening remote files over ssh like if they were local
(setq tramp-default-method "ssh")

;;; ====================================================================
;;; CUSTOM SETS
;;; ====================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("54a8c782a7a66e9aeb542af758f7f9f1a5702b956f425ffe15fccf5339f01f1e" "5d8caed7f4ed8929fd79e863de3a38fbb1aaa222970b551edfd2e84552fec020" "234976f82b2d64c6d2da3bca061d9f09b46e1496f02451fe02a4c707fab32321" "86847534b000a2e7f2b77c24faf3a94283329073bd4687807a4b6a52cae752dd" "4cdea318a3efab7ff7c832daea05f6b2d5d0a18b9bfa79763b674e860ecbc6da" "cda6cb17953b3780294fa6688b3fe0d3d12c1ef019456333e3d5af01d4d6c054" default)))
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((((class color) (background light)) (:background "#ffa54f"))))
    )



;;; ====================================================================
;;; SPELLCHECKING
;;; by http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html
;;; ====================================================================

;; if (aspell installed) { use aspell}
;; else if (hunspell installed) { use hunspell }
;; whatever spell checker I use, I always use English dictionary
;; I prefer use aspell because:
;; 1. aspell is older
;; 2. looks Kevin Atkinson still get some road map for aspell:
;; @see http://lists.gnu.org/archive/html/aspell-announce/2011-09/msg00000.html
(defun flyspell-detect-ispell-args (&optional run-together)
  "if RUN-TOGETHER is true, spell check the CamelCase words."
  (let (args)
    (cond
     ((string-match  "aspell$" ispell-program-name)
      ;; Force the English dictionary for aspell
      ;; Support Camel Case spelling check (tested with aspell 0.6)
      (setq args (list "--sug-mode=ultra" "--lang=en_US"))
      (if run-together
          (setq args (append args '("--run-together" "--run-together-limit=5" "--run-together-min=2")))))
     ((string-match "hunspell$" ispell-program-name)
      ;; Force the English dictionary for hunspell
      (setq args "-d en_US")))
    args))

(cond
 ((executable-find "/usr/local/bin/aspell")
  ;; you may also need `ispell-extra-args'
  (setq ispell-program-name "/usr/local/bin/aspell"))
 ((executable-find "/usr/local/bin/hunspell")
  (setq ispell-program-name "/usr/local/bin/hunspell")

  ;; Please note that `ispell-local-dictionary` itself will be passed to hunspell cli with "-d"
  ;; it's also used as the key to lookup ispell-local-dictionary-alist
  ;; if we use different dictionary
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))
 (t (setq ispell-program-name nil)))

;; ispell-cmd-args is useless, it's the list of *extra* arguments we will append to the ispell process when "ispell-word" is called.
;; ispell-extra-args is the command arguments which will *always* be used when start ispell process
;; Please note when you use hunspell, ispell-extra-args will NOT be used.
;; Hack ispell-local-dictionary-alist instead.
(setq-default ispell-extra-args (flyspell-detect-ispell-args t))
;; (setq ispell-cmd-args (flyspell-detect-ispell-args))
(defadvice ispell-word (around my-ispell-word activate)
  (let ((old-ispell-extra-args ispell-extra-args))
    (ispell-kill-ispell t)
    (setq ispell-extra-args (flyspell-detect-ispell-args))
    ad-do-it
    (setq ispell-extra-args old-ispell-extra-args)
    (ispell-kill-ispell t)
    ))

(defadvice flyspell-auto-correct-word (around my-flyspell-auto-correct-word activate)
  (let ((old-ispell-extra-args ispell-extra-args))
    (ispell-kill-ispell t)
    ;; use emacs original arguments
    (setq ispell-extra-args (flyspell-detect-ispell-args))
    ad-do-it
    ;; restore our own ispell arguments
    (setq ispell-extra-args old-ispell-extra-args)
    (ispell-kill-ispell t)
    ))

(defun text-mode-hook-setup ()
  ;; Turn off RUN-TOGETHER option when spell check text-mode
  (setq-local ispell-extra-args (flyspell-detect-ispell-args)))
(add-hook 'text-mode-hook 'text-mode-hook-setup)




;;; When evaluation of this buffer is completed, print confirmation
(message "Evaluation of init file completed.")
