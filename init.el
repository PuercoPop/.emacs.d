(setq message-log-max t)
(server-start)
(setq debug-on-error t)
(setq load-prefer-newer t)
(setq lexical-binding t)

;; Stuff to run at the beginning
(setq inhibit-startup-message t)
;; (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(menu-bar-mode t)
;; Set path to .emacs.d
(setq user-emacs-directory
      (file-name-directory (or (buffer-file-name) load-file-name)))

;; Set path to dependencies
(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(setq user-lisp-dir (expand-file-name "user-lisp" user-emacs-directory))

;; Set up Load path
;; (add-to-list 'load-path dotfiles-dir)
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
(require 'cl-lib)
(require 'key-bindings)
(require 'misc-settings)
(case system-type
  (darwin (require 'mac))
  (gnu/linux (require 'linux)))
(require 'midnight)
(require 'setup-dired+)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)
(global-set-key (kbd "C-x p")
                'direx-project:jump-to-project-root)
(global-set-key (kbd "C-x 4 p")
                'direx-project:jump-to-project-root-other-window)

(require 'setup-helm)
(require 'setup-ido-mode)
(require 'setup-org-mode)
(require 'setup-ibuffer-mode)
(require 'setup-uniquify)
(require 'setup-undo-tree)
(require 'setup-tramp-mode)
;; (require 'sudo-ext)
(require 'move-text)
(whole-line-or-region-mode)
;; (global-fixmee-mode 1)
(fullframe magit-status magit-mode-quit-window)

;; Spellcheck
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; wgrep
(setq wgrep-auto-save-buffer t
      wgrep-enable-key "r")

;; Ace Window
(global-set-key (kbd "C-x o") 'ace-window)

(require 'setup-rainbow-delimiters)
(require 'setup-markdown-mode)
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . creole-mode))
(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))
(require 'setup-c++)
(require 'setup-expand-region)
(drag-stuff-mode t)

;; Ace Jump mode
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; multiple-cursors
(global-set-key (kbd "C-c C-a") 'mc/mark-all-like-this-dwim)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)

;; (require 'setup-mediawiki)
;; (require 'mud)
(require 'setup-popwin)
(require 'setup-html-templates)
(require 'setup-css)
(require 'setup-games)
;; (require 'setup-mail)
(require 'setup-notmuch)

;; Javascript
(add-auto-mode 'js2-mode "\\.js$")
(add-auto-mode 'json-mode "\\.json$")
(after-load 'json-mode
  (setq-default js-indent-level 2))

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
                js2-global-externs '("module" "require" "$" "_" "_gaq")))

;;; Irc Stuff
;; (require 'setup-erc)
(require 'setup-rcirc)

;;; shell Stuff
(require 'setup-eshell)

;;; Misc Stuff
(require 'password-vault+)
(password-vault+-register-secrets-file "passwords")

;; (require 'setup-evil)

;; Lisp Stuff
;; Racket
(add-to-list 'auto-mode-alist '("\\.rkt$" . racket-mode))
(setq racket-smart-open-bracket-enable t)

(require 'setup-paredit)
;; (smartparens-global-mode)
;; (require 'smartparens-config)
;; (smartparens-strict-mode)
;; (define-key smartparens-mode-map (kbd "C-)") 'sp-forward-slurp-sexp)
;; (define-key smartparens-mode-map (kbd "C-(") 'sp-backward-slurp-sexp)
;; (define-key smartparens-mode-map (kbd "C-}") 'sp-forward-barf-sexp)
;; (define-key smartparens-mode-map (kbd "C-{") 'sp-backward-barf-sexp)
;; (define-key smartparens-mode-map (kbd "M-s") 'sp-splice-sexp)
;; (define-key smartparens-mode-map (kbd "M-J") 'sp-join-sexp)

;; (define-key smartparens-mode-map (kbd "C-x C-t") 'sp-transpose-hybrid-sexp)
;; (define-key smartparens-mode-map
;;   (kbd "C-M-<right_bracket>") 'sp-select-next-thing)
;; (define-key smartparens-mode-map
;;   (kbd "C-<left_bracket>") 'sp-select-previous-thing)

;; Emacs Lisp
(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(eval-after-load 'elisp-slime-nav '(diminish 'elisp-slime-nav-mode))

(require 'setup-cl-mode)
(require 'setup-sly)

;;; Magit
(require 'setup-magit)

;; SQL
(after-load 'sql
  (sql-set-product 'postgres)
  (require 'sql-indent))
(add-hook 'sql-mode-hook 'edbi-minor-mode)

(require 'html-validate)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t
              save-place-file (expand-file-name ".places"
                                                user-emacs-directory))

;; (require 'setup-smtp)
(load-theme 'solarized) 
(setq initial-buffer-choice "~/org/life.org")


(cl-defun notify (message &key (title "Emacs"))
  "Quick hack to use Ubuntu's notify-send."
  (shell-command
   (concat "notify-send " title " " message)))
;; Display Emacs Startup Time
(add-hook 'after-init-hook (lambda ()
                             (notify (format "The init sequence took %s." (emacs-init-time)) :title "Emacs Startup")))
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-page 'disabled nil)
