(setq message-log-max t)
(require 'cl-lib)
(server-start)
(setq debug-on-error t)

;; Stuff to run at the beginning
(setq inhibit-startup-message t)
(if (display-graphic-p)
    (progn
      (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
      (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
      (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))))
;; Add to every emacsclient run
(add-hook 'server-visit-hook
          (lambda ()
            (message "Running server-visit-hook")
            (if (display-graphic-p)
                (progn
                  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
                  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
                  (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))))))

;; Set path to .emacs.d
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))
;; Set path to dependencies
(setq site-lisp-dir (expand-file-name "site-lisp" dotfiles-dir))
(setq user-lisp-dir (expand-file-name "user-lisp" dotfiles-dir))

;; Set up Load path
(add-to-list 'load-path dotfiles-dir)
(add-to-list 'load-path site-lisp-dir)

(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

(add-to-list 'load-path user-lisp-dir)

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-lisp-dir))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

(require 'setup-package)
(require 'use-package)
(require 'key-bindings)
(require 'misc-settings)
(when (equal system-type 'darwin) (require 'mac))
(use-package diminish)
;; (require 'secrets)
;; (use-package secrets
;;   :init
;;   (progn
;;     (epa-file-enable)
;;     ;;(setq epa-file-select-keys t)
;;     ;;(setq epg-gpg-program "gpg2")
;;     (load-library "~/.emacs.d/user-lisp/passwords.el.gpg")))
(use-package midnight)
(require 'setup-dired+)
(require 'setup-org-mode)
(require 'setup-ido-mode)
(require 'setup-ibuffer-mode)
(require 'setup-uniquify)
(require 'setup-undo-tree)
(require 'setup-tramp-mode)
(require 'sudo-ext)
(use-package wgrep
  :init
  (progn
    (setq wgrep-auto-save-buffer t)
    (setq wgrep-enable-key "r"))) ;; Originally C-c C-p
(require 'setup-rainbow-delimiters)
(require 'setup-markdown-mode)
(require 'setup-python)                 ; Stock Python mode
;; (require 'setup-python-mode)            ; LaunchPad
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(require 'setup-expand-region)
(require 'setup-mark-multiple)
(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))
(use-package multiple-cursors
             :bind (("C-c C-a" . mc/mark-all-like-this)
                    ("C->" . mc/mark-next-like-this)
                    ("C-<" . mc/mark-prev-like-this)))
;; (require 'setup-mediawiki)
(require 'setup-smtp)
;(require 'mud)
(require 'setup-popwin)
(require 'setup-mu)
(require 'campfire)
(require 'setup-twittering-mode)
(require 'gist)
(require 'setup-css)
;(require 'google-contacts) ; missing oauth from elpa
(require 'setup-games)
(require 'setup-js2-mode)
(use-package js2-mode
  :init
  (progn
    ;; Taken from https://github.com/andialbrecht/emacs-config/blob/master/init.el
    (setq js2-cleanup-whitespace t)
    (setq js2-global-externs (list "$")) ; Always asume jquery is included
    (setq js2-basic-offset 2)))

;;; Irc Stuff
;;(require 'setup-erc)
(require 'setup-rcirc)

;;; Shell Stuff
;;(require 'setup-eshell)
(require 'term+)
(require 'term+mux)

;;; Misc Stuff
(require 'osx-plist)

;; (require 'setup-evil)

;; Lisp Stuff
(setq geiser-racket-binary "/usr/local/bin/racket")

(smartparens-global-mode)
(require 'smartparens-config)

(require 'redshank-loader)
(eval-after-load "redshank-loader"
  `(redshank-setup '(lisp-mode-hook
                     slime-repl-mode-hook) t))
(require 'setup-paredit)

(require 'setup-elisp)
;; Emacs Lisp
(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))
(eval-after-load 'elisp-slime-nav '(diminish 'elisp-slime-nav-mode))


;;; clojure mode
(require 'setup-ac-mode)
(require 'setup-clojure-mode)

(require 'setup-cl-mode)
(require 'setup-slime-ql)

;;; Magit
(require 'setup-magit)

;; SQL
(use-package sql
  :init
  (progn
    (sql-set-product 'postgres)
    (load-library "sql-indent")))

;;; Scheme / Racket
;(require setup-scheme)

;;; Java Android
(require 'setup-java)

(require 'growl-notify)
(require 'html-validate)

;; Save point position between sessions
(use-package saveplace
  :init
  (progn
    (setq-default save-place t
                  save-place-file (expand-file-name ".places"
                                                    user-emacs-directory))))

;; Spitout random keybindings every 3 minuts
;; (use-package keywiz)
;; (defun sacha/load-keybindings ()
;;   "Since we don't want to have to pass through a keywiz game each time..."
;;   (setq keywiz-cached-commands nil)
;;   (do-all-symbols (sym)
;;     (when (and (commandp sym)
;;                (not (memq sym '(self-insert-command
;;                                 digit-argument undefined))))
;;       (let ((keys (apply 'nconc (mapcar
;;                                  (lambda (key)
;;                                    (when (keywiz-key-press-event-p key)
;;                                      (list key)))
;;                                  (where-is-internal sym)))))
;;         ;;  Politically incorrect, but clearer version of the above:
;;         ;;    (let ((keys (delete-if-not 'keywiz-key-press-event-p
;;         ;;                               (where-is-internal sym))))
;;         (and keys
;;              (push (list sym keys) keywiz-cached-commands))))))
;;   (sacha/load-keybindings)
;;   ;; Might be good to use this in org-agenda...
;; (defun sacha/random-keybinding ()
;;   "Describe a random keybinding."
;;   (let* ((command (keywiz-random keywiz-cached-commands))
;;          (doc (and command (documentation (car command)))))
;;     (if command
;;         (concat (symbol-name (car command)) " "
;;                 "(" (mapconcat 'key-description (cadr command) ", ") ")"
;;                 (if doc
;;                     (concat ": " (substring doc 0 (string-match "\n" doc)))
;;                   ""))
;;       "")))
;; (run-at-time (current-time) 300
;;  (message "%s" (sacha/random-keybinding)))


(require 'setup-w3m)

;; Display Emacs Startup Time
(add-hook 'after-init-hook (lambda ()
                             (growl-notify-notification "Emacs Startup" (format "The init sequence took %s." (emacs-init-time)))))
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
