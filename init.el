(package-initialize)

(setq message-log-max t)
(server-start)
(setq debug-on-error t)
(setq load-prefer-newer t)
(setq lexical-binding t)

;; Stuff to run at the beginning
(setq inhibit-startup-message t)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

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

(use-package dired
  :config (setq dired-dwim-target t))

(use-package dired+
  :after (dired)
  :init (toggle-diredp-find-file-reuse-dir 1))

(use-package dired-x
  :after (dired))
;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "M-o") 'other-window)
;;             (local-set-key (kbd "C-x o") 'dired-omit-mode)))

(use-package dired-toggle
  :ensure t
  :after (dired)
  :bind (("<f5>" . dired-toggle)))

(use-package ido
  :init (progn
          (ido-mode t)
          (ido-everywhere t))
  :config (setq ido-enable-flex-matching t
                ido-create-new-buffer 'always
                ido-use-virtual-buffers nil)
  :bind (:map ido-file-completion-map
              (("C-w" . ido-delete-backward-updir))))

(use-package ido-vertical-mode
  :after (ido)
  :ensure t
  :init (ido-vertical-mode))

(use-package ido-better-flex
  :after (ido)
  :ensure t
  :init (ido-better-flex/enable))

(use-package swiper
  :ensure t
  :bind (("C-c o" . swiper)))

(use-package counsel
  :ensure t
  :bind (("M-y" . counsel-yank-pop)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)))

(use-package find-file-in-project
  :ensure t
  :bind (("C-x p" . find-file-in-project)))

(use-package helm
  :ensure t
  :bind (("C-M-s" . helm-occur)
         ;; ("M-y" . helm-show-kill-ring)
         ("C-c g" . helm-suggest-google))
  :bind (:map helm-map
              (("C-s" . helm-next-line)
               ("C-r" . helm-previous-line))))

(use-package minions
  :ensure t
  :config (minions-mode 1))

(require 'setup-org-mode)
(require 'setup-ibuffer-mode)
(require 'setup-uniquify)

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode 1))

(use-package info
  :bind (:map Info-mode-map
              (("(" . Info-backward-node)
               (")" . Info-forward-node))))

(use-package tramp
  :custom (tramp-default-method "ssh"))

(require 'move-text)
(whole-line-or-region-mode)

(use-package flyspell
  :init (progn (add-hook 'flyspell-mode-hook
          (lambda ()
            (define-key flyspell-mode-map (kbd "C-.") nil))))
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)))

(use-package wgrep
  :ensure t
  :config
  (setq wgrep-auto-save-buffer t
        wgrep-enable-key "r"))

(use-package ace-window
  :ensure t
  :bind (("M-o" . 'other-window)
         ("M-0" . 'delete-window)
         ("M-1" . 'delete-other-windows)
         ("M-2" . 'split-window-vertically)
         ("M-3" . 'split-window-right)
         ("C-x o" . 'ace-window)
         ("C-x t" . (lambda () (interactive) (ace-window 4)))))

(require 'setup-rainbow-delimiters)

(use-package markdown-mode
  :ensure t
  :mode (("\\.md" . markdown-mode)))

(add-to-list 'auto-mode-alist '("\\.wiki\\'" . creole-mode))
(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.ttl\\'" . ttl-mode))

(use-package expand-region
  :ensure t
  :bind (("C-=" . 'er/expand-region)))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c C-a" . 'mc/mark-all-like-this-dwim)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)))


;; (require 'setup-mediawiki)
;; (require 'mud)
(require 'setup-html-templates)
(require 'setup-css)
;; (require 'setup-mail)

(setq c-default-style '((c-mode . "bsd")
                        (java-mode . "java")
                        (awk-mode . "awk")
                        (other . "gnu")))

(add-hook 'c-mode-common-hook
          (lambda ()
            (define-key c-mode-map (kbd "<f8>") 'compile)))

(use-package nyan-prompt
  :load-path "site-lisp/nyan-prompt"
  :init (nyan-prompt-enable))

;; Javascript

(use-package json-mode
  :mode (("\\.json$" . json-mode))
  :init (setq-default js-indent-level 2))

(use-package js2-mode
  :init
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
  :mode (("\\.js$" . js2-mode)
         ("\\.es6$" . js2-mode)))

(use-package rjsx-mode
  :ensure t
  :mode (("\\.jsx" . rjsx-mode)))

(use-package prettier-js
  :ensure t
  :custom
  (prettier-js-command "npx")
  (prettier-js-args '("prettier")))

(require 'virtualenvwrapper)
(setq venv-location "~/.envs/")
;; (require 'jedi)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (add-hook 'python-mode-hook
;;          '(lambda ()
;;             (setq fill-column 79)
;;             (jedi:setup)
;;             (jedi:ac-setup)))

(eval-after-load "python"
  '(progn (setq python-fill-docstring-style 'pep-257-nn)
          (define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer)
          (define-key python-mode-map (kbd "C-c t") 'python-test-test-function)))

;;; Irc Stuff
;; (require 'setup-erc)
(require 'setup-rcirc)

;;; shell Stuff
(require 'setup-eshell)

;;; Misc Stuff
(require 'password-vault+)
(password-vault+-register-secrets-file "passwords")

;; Lisp Stuff

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
(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (turn-on-eldoc-mode)
                                  (setq tab-always-indent 'complete)))

(use-package macrostep
  :ensure t
  :bind (:map emacs-lisp-mode-map
        ("C-c M-e" . macrostep-expand)
        :map lisp-mode-map
        ("C-c M-e" . macrostep-expand)))

(require 'setup-cl-mode)
(require 'setup-sly)
;; (use-package sly-mode
;;   :load-path "site-lisp/sly"
;;   :init (add-to-list 'Info-default-directory-list
;;                      "/home/puercopop/.emacs.d/site-lisp/sly/doc/")
;;   :config (progn
;;             (setq sly-lisp-implementations
;;                   '((ccl ("/home/puercopop/.apps/ccl/lx86cl64"))
;;                     (sbcl ("/usr/local/bin/sbcl"))
;;                     (sbcl-vanilla ("/opt/local/bin/sbcl"))
;;                     (mezzano ("/opt/local/bin/sbcl-mezzano"))
;;                     (sbcl-walk-forms ("/opt/local/sbcl-codewalker/bin/sbcl"))
;;                     (sbcl-walk-forms-v2 ("/opt/local/sbcl-codewalker-v2/bin/sbcl"))
;;                     (ecl ("/usr/local/bin/ecl"))
;;                     (abcl ("/home/puercopop/Projects/abcl/abcl/abcl"))
;;                     (abcl-git ("/home/puercopop/Projects/abcl-git/abcl"))
;;                     (clisp ("/usr/bin/clisp"))
;;                     (cmucl ("/home/puercopop/.apps/cmucl/bin/lisp")))
;;                   sly-default-lisp 'sbcl)
;;             (add-to-list 'sly-contribs 'sly-macrostep 'append)
;;             (add-to-list 'sly-contribs 'sly-repl-ansi-color 'append)
;;             (add-to-list 'sly-contribs 'sly-indendation 'append))
;;   :bind (:map lisp-mode-map
;;               ("M-i" . sly-inspect-defintion)
;;          :map sly-doc-map
;;               ("C-d" . sly-documentation)
;;          :map sly--completion-transient-mode-map
;;               ("C-s" . sly-next-completion)
;;               ("C-r" . sly-prev-completion)))

(use-package geiser
  :ensure t)

(use-package smtpmail
  :config (setq smtpmail-smtp-server "smtp.gmail.com"
                smtpmail-local-domain "gmail.com"
                smtpmail-sendto-domain "gmail.com"
                smtpmail-smtp-user "pirata@gmail.com"
                smtpmail-smtp-service 465
                smtpmail-stream-type 'ssl
                smtpmail-debug-info t
                send-mail-function 'smtpmail-send-it))

(use-package git-commit
  :ensure t
  :config (progn
            (setq git-commit-fill-column 72)
            (add-to-list 'git-commit-style-convention-checks
                         'overlong-summary-line)))

(use-package magit
  :ensure t
  :config (progn
            (setq magit-auto-revert-mode nil
                  magit-push-always-verify nil)
            (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-branch-description
                          nil t)
            (fullframe magit-status magit-mode-quit-window))
  :bind (("C-c s" . 'magit-status)
         (:map magit-status-mode-map
               ("W" . 'magit-toggle-whitespace))))

;; SQL
(after-load 'sql
  (sql-set-product 'postgres)
  (require 'sql-indent))
(add-hook 'sql-mode-hook 'edbi-minor-mode)

(setq prolog-system 'swi
      auto-mode-alist (append '(("\\.pl$" . prolog-mode))
                              auto-mode-alist))

(defun my/read-env-file (env-file)
  (with-current-buffer (find-file-noselect env-file)
    (cl-loop for line in (split-string (buffer-string) "\n")
             when (string-match "^\\(.+[^[:space:]]\\)[[:space:]]*=[[:space:]]*\\(.+\\)" line)
             collect (format "%s=%s"
                             (match-string-no-properties 1 line)
                             (match-string-no-properties 2 line)))))

(defun my/call-in-rspec (fn)
  (lambda (orig-fn &rest args)
    (if (eq major-mode 'rspec-compilation-mode)
        (apply fn orig-fn args)
      (apply orig-fn args))))

(defun my/maybe-inject-proccess-environment (orig-fun &rest args)
  (chruby-use-corresponding)
  (when-let ((default-directory (locate-dominating-file default-directory ".git/"))
             (process-environment (append (my/read-env-file ".env") process-environment)))
    (apply orig-fun args)))

(use-package chruby
  :ensure t)

(use-package robe
  :ensure t
  :hook (ruby-mode . robe-mode)
  :init (advice-add 'inf-ruby-console-auto :around #'my/maybe-inject-proccess-environment))

(use-package rspec-mode
  :ensure t
  :hook ((ruby-mode . rspec-mode)
         (dired-mode . rspec-dired-mode))
  :init (progn (advice-add 'rspec-compile :around #'my/maybe-inject-proccess-environment)
               (advice-add 'recompile :around (my/call-in-rspec #'my/maybe-inject-proccess-environment)) ))

(use-package inf-ruby
  :ensure t)

(use-package honcho
  :ensure t)

(use-package elfeed
  :ensure t
  :config (progn
            (setq elfeed-feeds
                  '("https://gilesbowkett.blogspot.com/feeds/posts/default?alt=atom"
                    "https://dorophone.blogspot.com/feeds/posts/default?alt=atom"
                    "https://swannodette.github.io/atom.xml"
                    "http://emacsninja.com/feed.atoml"
                    "https://existentialtype.wordpress.com/feed/"
                    "https://feeds.feedburner.com/lmeyerov"
                    "http://blog.kingcons.io/rss.xml"
                    "http://feeds.feedburner.com/glyph"
                    "https://irreal.org/blog/?feed=atom"
                    "https://langnostic.inaimathi.ca/feed/atom"
                    "https://lisp-univ-etc.blogspot.com/feeds/posts/default"
                    "http://www.loper-os.org/?feed=atom"
                    "https://feeds.feedburner.com/kvardek-du"
                    "https://patricklogan.blogspot.com/feeds/posts/default"
                    "http://nullprogram.com/blog/index.rss"
                    "http://nullprogram.com/blog/index.rss"
                    "http://www.pvk.ca/atom.xml"
                    "http://www.pvk.ca/atom.xml"
                    "https://pchiusano.blogspot.com/feeds/posts/default"
                    "http://pchiusano.io/feed.xml"
                    "http://russ.unwashedmeme.com/blog/?feed=atom"
                    "https://yinwang0.wordpress.com/feed/"
                    "https://unlearningeconomics.wordpress.com/feed/"
                    "http://feeds.feedburner.com/vivekhaldar"
                    "http://whattheemacsd.com/atom.xml"
                    "http://wingolog.org/feed/atom"
                    "http://alex-charlton.com/rss.xml"
                    "http://lisptips.com/rss"
                    "http://sciencebitesperu.weebly.com/1/feed"
                    "http://planet.lisp.org/github.atom"
                    "http://250bpm.com/feed/pages/pagename/start/category/blog/t/250bpm-blogs/h/http%3A%2F%2Fwww.250bpm.com%2Fblog"))))

(use-package darktooth-theme
  :ensure t
  :init (load-theme 'darktooth))

(use-package moody
  :ensure t
  :config (progn
            (setq x-underline-at-descent-line t)
            (moody-replace-mode-line-buffer-identification)
            (moody-replace-vc-mode)))

(use-package docean
  :load-path "site-lisp/docean.el")

(use-package shackle
  :ensure t
  :config (setq shackle-rules
                '((compilation-mode :noselect t)
                  (sly-mrepl-mode :other t))
                shackle-default-rule '(:select t)))

(use-package eyebrowse
  :ensure t
  :init (eyebrowse-mode t))

(use-package pivotal-tracker
  :load-path "site-lisp/pivotal-tracker")

;; (require 'exwm)
;; (require 'exwm-config)
;; (exwm-config-default)

;; (exwm-input-set-key (kbd "M-p")
;;                     (lambda (command)
;;                       (interactive (list (read-shell-command "$ ")))
;;                       (start-process-shell-command command nil command)))

;; (exwm-input-set-key (kbd "C-x w t") #'exwm-floating-toggle-floating)
;; (exwm-input-set-key (kbd "C-x w f") #'exwm-layout-toggle-fullscreen)

(cl-defun notify (message &key (title "Emacs"))
  "Quick hack to use Ubuntu's notify-send."
  (shell-command
   (concat "notify-send " title " " message)))

(add-hook 'after-init-hook (lambda ()
                             (org-todo-list)
                             (delete-other-windows)))

