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
(require 'key-bindings)
(require 'misc-settings)
(when (equal system-type 'darwin) (require 'mac))
(require ' midnight)
(require 'setup-dired+)
(require 'setup-org-mode)
(require 'setup-ido-mode)
(require 'setup-ibuffer-mode)
(require 'setup-uniquify)
(require 'setup-undo-tree)
(require 'setup-tramp-mode)
(require 'sudo-ext)

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
(require 'setup-mark-multiple)

;; Ace Jump mode
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; multiple-cursors
(global-set-key (kbd "C-c C-a") 'mc/mark-all-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)

;; (require 'setup-mediawiki)
;(require 'mud)
(require 'setup-popwin)
(require 'setup-twittering-mode)
(require 'setup-html-templates)
(require 'setup-css)
;(require 'google-contacts) ; missing oauth from elpa
(require 'setup-games)
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
                              (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-cl" 'js-load-file-and-go)
			    ))

)


;;; Irc Stuff
;;(require 'setup-erc)
(require 'setup-rcirc)

;;; Shell Stuff
;;(require 'setup-eshell)

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
