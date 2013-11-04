(setq message-log-max t)
(require 'cl-lib)
(server-start)
(setq debug-on-error t)
(setq lexical-binding t)

;; Stuff to run at the beginning
(setq inhibit-startup-message t)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

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
(require 'package)
(require 'ensure-packages)
(require 'key-bindings)
(require 'misc-settings)
(when (equal system-type 'darwin)
  (require 'mac))
(require 'midnight)
(require 'setup-dired+)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)
(global-set-key (kbd "C-x p")
                'direx-project:jump-to-project-root)
(global-set-key (kbd "C-x 4 p")
                'direx-project:jump-to-project-root-other-window)
(require 'setup-org-mode)
(require 'setup-ido-mode)
(require 'setup-ibuffer-mode)
(require 'setup-uniquify)
(require 'setup-undo-tree)
(require 'setup-tramp-mode)
(require 'sudo-ext)
(require 'setup-ac-mode)


(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c" "C-x")
      guide-key/popup-window-position 'bottom)
(guide-key-mode 1)

;; wgrep
(setq wgrep-auto-save-buffer t
      wgrep-enable-key "r")

(require 'setup-rainbow-delimiters)
(require 'setup-markdown-mode)
(require 'setup-python)                 ; Stock Python mode
;; (require 'setup-python-mode)            ; LaunchPad
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(require 'setup-expand-region)
(drag-stuff-mode t)

(add-hook 'before-save-hook
          (lambda ()
            (when (or (derived-mode-p 'lisp-mode)
                      (derived-mode-p 'emacs-lisp-mode)
                      (derived-mode-p 'clojure-mode))
              (indent-buffer))))

;; Ace Jump mode
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; multiple-cursors
(global-set-key (kbd "C-c C-a") 'mc/mark-all-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)

;; (require 'setup-mediawiki)
;; (require 'mud)
(require 'setup-popwin)
(require 'setup-forth)
(require 'setup-twittering-mode)
(require 'setup-html-templates)
(require 'setup-css)
;(require 'google-contacts) ; missing oauth from elpa
(require 'setup-games)

;; Scala

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Javascript
(add-auto-mode 'js2-mode "\\.js$")
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
(after-load 'js2-mode
  (setq-default js2-auto-indent-p t
                js2-basic-offset 2
                js2-cleanup-whitespace t
                js2-enter-indents-newline t
                js2-indent-on-enter-key t
                js2-mode-indent-ignore-first-tab t
                js2-show-parse-errors nil
                js2-strict-inconsistent-return-warning nil
                js2-strict-var-hides-function-arg-warning nil
                js2-strict-missing-semi-warning nil
                js2-strict-trailing-comma-warning nil
                js2-strict-cond-assign-warning nil
                js2-strict-var-redeclaration-warning nil
                js2-global-externs '("module" "require" "$" "_" "_gaq"))

  (js2r-add-keybindings-with-prefix "C-c C-m")

  (setq inferior-js-program-command "/usr/local/bin/js")
  (add-hook 'js2-mode-hook '(lambda ()
                              (local-set-key "\C-x\C-e" 'js-send-last-sexp)
                              (local-set-key "\C-\M-x"
                                             'js-send-last-sexp-and-go)
                              (local-set-key "\C-cb" 'js-send-buffer)
                              (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
                              (local-set-key "\C-cl" 'js-load-file-and-go)
                              )))


;; Smart-mode-line
(after-init
  (sml/setup)
  (setq sml/shorten-directory t
        sml/shorten-modes t
        sml/name-width 40
        sml/mode-width 'full))

;;; Irc Stuff
;;(require 'setup-erc)
(require 'setup-rcirc)

;;; Shell Stuff
;;(require 'setup-eshell)

;;; Misc Stuff
(require 'osx-plist)
(password-vault-register-secrets-file "passwords")

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
(require 'setup-clojure-mode)

(require 'setup-cl-mode)
(require 'setup-slime-ql)

;;; Magit
(require 'setup-magit)

;; SQL
(after-load 'sql
  (sql-set-product 'postgres)
  (require 'sql-indent))

(autoload 'growl-notify-notification "growl-notify" "Enable growl notifications" nil nil)
(require 'html-validate)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t
              save-place-file (expand-file-name ".places"
                                                user-emacs-directory))

(require 'setup-w3m)
(require 'setup-smtp)

;; Display Emacs Startup Time
(add-hook 'after-init-hook (lambda ()
                             (growl-notify-notification "Emacs Startup" (format "The init sequence took %s." (emacs-init-time)))))
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
