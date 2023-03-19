;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)
(when (and (native-comp-available-p) (getenv "ELN"))
  (setq borg-compile-function #'native-compile))

(require 'cl-lib)
(require 'compat)


;;; Customize
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
(put 'upcase-region 'disabled nil)

(setq use-package-always-defer t
      use-package-enable-imenu-support t)
(require 'use-package)

;; (require 'auto-compile)
;; (auto-compile-on-load-mode)
;; (auto-compile-on-save-mode)


;;; Daemon

;; (or (server-running-p)
;;     (server-start))
(setq my/server-name (or (daemonp) "none"))


(setq session-save-file (concat user-emacs-directory (system-name) "-" my/server-name "-session"))
(setq desktop-base-file-name (concat (system-name) "-" my/server-name "-desktop-file"))
(setq desktop-base-lock-name (concat (system-name) "-" my/server-name "-desktop-lock"))

(setq frame-title-format '(multiple-frames ("%b - " invocation-name "@" my/server-name)
                                           ("" invocation-name "@" my/server-name)))


;;; QoL

(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode t))

(setq system-time-locale "en_US.utf8")
(setq inhibit-startup-message t
      message-log-max t
      load-prefer-newer t
      column-number-mode t
      require-final-newline t
      x-stretch-cursor t
      scroll-preserve-screen-position t
      scroll-margin 2
      backup-directory-alist `(("." . ,(expand-file-name
                                        (concat user-emacs-directory "backups"))))
      make-backup-files nil
      vc-make-backup-files nil
      auto-save-default t
      auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/" t)) ; temporary-file-directory
      create-lockfiles nil
      tab-always-indent 'complete
      set-mark-command-repeat-pop t
      load-prefer-newer t
      vc-handled-backends '(Git Hg)
      confirm-kill-emacs 'y-or-n-p
      disabled-command-function nil
      help-window-select 'other
      sentence-end-double-space nil
      lazy-highlight-initial-delay 0
      visible-bell t
      fill-column 79)

(blink-cursor-mode -1)
(minibuffer-depth-indicate-mode 1)
(global-auto-revert-mode t)
(delete-selection-mode t)
(require 'savehist)
(setq savehist-file (locate-user-emacs-file (format "%s-history" my/server-name)))
(savehist-mode 1)
(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(defalias 'list-buffers 'ibuffer)

;; (global-set-key (kbd "M-j") 'delete-indentation)
(global-set-key (kbd "M-c") 'capitalize-dwim)
(global-set-key (kbd "M-l") 'downcase-dwim)
(global-set-key (kbd "M-u") 'upcase-dwim)
(global-set-key (kbd "<C-next>") 'scroll-other-window)
(global-set-key (kbd "<C-prior>") 'scroll-other-window-down)
(global-set-key (kbd "M-=") #'count-words)
(global-set-key (kbd "C-z") nil)

(setq uniquify-buffer-name-style 'forward
      uniquify-after-kill-buffer-p t)


(require 'uniquify)

;; Relevant Faces
;; - show-paren-match
;; - show-paren-mismatch
;; :custom (show-paren-style 'expression)
(show-paren-mode t)


(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun my/backward-kill-word-or-region ()
  "When no region is active call BACKWARD-KILL-WORD, otherwise
call KILL-REGION."
  (interactive)
  (let ((fn (if (region-active-p)
      'kill-region
      'backward-kill-word)))
    (call-interactively fn)))

;; Maybe remap kill-region instead?
(global-set-key (kbd "C-w") #'my/backward-kill-word-or-region)
;; Use M-<BACKSPACE> instead

(define-key minibuffer-local-completion-map
  (kbd "C-w") 'backward-kill-word)

(minions-mode 1)

(defvar my/recentf-update-timer nil)
(when my/recentf-update-timer
  (cancel-timer my/recentf-update-timer))
(setq my/recentf-update-timer
      ;; TODO: Should I use run-with-idle-timer instead?
      (run-at-time nil (* 5 60) 'recentf-save-list))
(setq recentf-save-file
      (locate-user-emacs-file (concat (system-name) "-" my/server-name "-recentf")))
(recentf-mode 1)
(global-set-key (kbd "C-x C-r") 'recentf-open)

(use-package minibuffer
  ;; :custom (completion-styles '(flex))
  ;; :custom (completion-styles '(basic partial-completion substring flex))
  ;; :custom (completion-styles '(substring partial-completion flex)))
  )
(fido-vertical-mode t)
;; (use-package simple
;;   :bind ((:map completion-list-mode-map)) )


(require 'proced)

(setq bookmark-default-file
      (concat user-emacs-directory (system-name) "-" my/server-name "-bookmarks"))


(defun bookmark-jump-other-tab (bookmark)
  "Jump to BOOKMARK in another tab.  See `bookmark-jump' for more."
  (interactive
   (list (bookmark-completing-read "Jump to bookmark (in another tab)"
                                   bookmark-current-bookmark)))
  (bookmark-jump bookmark 'switch-to-buffer-other-tab))

(use-package tab-bar
  ;; :config (setq tab-bar-close-button
  ;;               (propertize " ⮾"
  ;;                           'close-tab t
  ;;                           :help "Click to close tab")
  ;;               tab-bar-new-button " + ")
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  ;; (tab-bar-new-tab-choice "*scratch*")
  (tab-bar-select-tab-modifiers '(super))
  (tab-bar-tab-hints t)
  :bind ((:map tab-prefix-map
              (("o" . tab-bar-select-tab-by-name)
               ("p" . tab-previous)
               ("n" . tab-next)
               ("<left>" . tab-previous)
               ("<right>" . tab-next)
               ("c" . tab-new)
               ("k" . tab-close)
               ("j" . bookmark-jump-other-tab)))))

(require 'project)
(global-set-key (kbd "C-c p") project-prefix-map)

(defun my/project-try-gem (dir)
  (when-let (root (locate-dominating-file dir "Gemfile"))
    (cons 'ruby root)))
(cl-defmethod project-root ((project (head ruby)))
  (cdr project))

(cl-defmethod project-files ((project (head ruby)) &optional dir)
  (mapcan #'(lambda (dir)
              ;; TODO: We shouldn't hard-code Git as the backend
              (project--vc-list-files dir 'Git nil))
          (or dir
              (list (project-root project)))))

(setq project-find-functions (list #'my/project-try-gem #'project-try-vc))


(require 'anzu)
(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
;; We still need to update the query-replace face
(global-set-key [remap kill-ring-save] 'easy-kill)



;;; Consult
(use-package consult
  :bind (([remap yank-pop] . consult-yank-replace)
         ([remap goto-line] . consult-goto-line)
         ([remap project-find-regexp] . consult-ripgrep)
         :map minibuffer-local-map
         ("M-r" . consult-history))
  :config
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; TODO C-x b consults buffers in the same project. C-u C-x b all buffers.

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         :map embark-file-map
         ("!" . async-shell-command)
         ;; :map embark-bookmarp-map
         ;; ("!" . async-shell-command)
         ))


(require 'hotfuzz)
(require 'hotfuzz-module)
(setq completion-styles '(hotfuzz))
(add-hook 'icomplete-minibuffer-setup-hook
          (lambda () (setq-local completion-styles '(hotfuzz))))

(defun my/set-ruby-devdocs ()
  (setq-local devdocs-current-docs '("ruby~2.6" "rails~5.2")))

(defun my/set-js-devdocs ()
  (setq-local devdocs-current-docs '("react")))

(use-package devdocs
  :hook ((ruby-mode . my/set-ruby-devdocs)
         (js-mode . my/set-js-devdocs)
         (typescript-mode . my/set-js-devdocs)))


(define-key help-mode-map (kbd "n") 'forward-button)
(define-key help-mode-map (kbd "p") 'backward-button)
(define-key help-mode-map (kbd "f") 'describe-function)
(define-key help-mode-map (kbd "v") 'describe-variable)

(defun my/helpful-at-buffer ()
  (interactive)
  (let ((help-topic (cl-second help-xref-stack-item)))
    (helpful-symbol help-topic)))

(use-package helpful
  :custom (helpful-max-buffers 1)
  :bind ((:map help-mode-map
               (("H" . my/helpful-at-buffer)))))
;; XXX: C-h F Info-goto-emacs-command-node

(use-package emaps
  ;; Consider C-h K
  :bind (("C-h M-k" . emaps-describe-keymap-bindings)))

(use-package transient)
;; (define-transient-command my/counsel ()
;;             "Entry point for assorted counsel commands."
;;             [("o" "Swipe file" swiper)
;;              ("r" "Grep Project" counsel-git-grep) ; pass flags to it like -ni
;;              ("p" "Find file in Project" counsel-git)])

(use-package pinentry)

(use-package epa-file
  :config (setq epg-pinentry-mode 'loopback)
  ;; (load-library "~/.emacs.d/passwords.el.gpg")
  )

;; (use-package password-vault+
;;   :load-path "site-lisp/password-vault+"
;;   :config (password-vault+-register-secrets-file (substitute-in-file-name "$HOME/.emacs.d/passwords.el.gpg")))

(use-package tramp
  :config (setq tramp-default-method "ssh"))

(defun sudo ()
  "Use TRAMP to `sudo' the current buffer"
  (interactive)
  (when-let ((file-name buffer-file-name)
             (point (point)))
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             file-name))
    (goto-char point)))

(use-package wgrep
  :config (setq wgrep-auto-save-buffer t
                wgrep-enable-key "\C-x\C-q"))

(use-package ace-window
  :bind (("M-o" . 'other-window)
         ("M-0" . 'delete-window)
         ("M-1" . 'delete-other-windows)
         ("M-2" . 'split-window-vertically)
         ("M-3" . 'split-window-right)
         ("C-x o" . 'ace-window)))

(use-package winner
  :config (winner-mode))

(use-package ibuffer
  :bind ((:map ibuffer-mode-map
               ("M-o" . other-window))))

(use-package expand-region
  :bind (("C-=" . er/expand-region)))

;; TODO: Check hippie expand
(use-package abbrev
  :hook ((text-mode prog-mode) . abbrev-mode))

;; Spellcheck
;; TODO: Configure Ispell configure
(use-package ispell
  :config
  (defun ispell-word-then-abbrev (p)
    "Call `ispell-word', then create an abbrev for it.
With prefix P, create local abbrev. Otherwise it will
be global."
    (interactive "P")
    (let (bef aft)
      (save-excursion
        (while (progn
                 (backward-word)
                 (and (setq bef (thing-at-point 'word))
                      (not (ispell-word nil 'quiet)))))
        (setq aft (thing-at-point 'word)))
      (when (and aft bef (not (equal aft bef)))
        (setq aft (downcase aft))
        (setq bef (downcase bef))
        (define-abbrev
          (if p local-abbrev-table global-abbrev-table)
          bef aft)
        (write-abbrev-file)
        (message "\"%s\" now expands to \"%s\" %sally"
                 bef aft (if p "loc" "glob")))))
  :bind ((:map ctl-x-map
               (("C-i" . ispell-world-then-abbrev)))))

(use-package flyspell
  :config (setq flyspell-abbrev-p t)
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)))

(defun my/show-commit ()
  (interactive)
  (let ((revision (car (vc-annotate-extract-revision-at-line))))
    (magit-show-commit revision)))

(use-package ediff
  :custom (ediff-highlight-all-diffs nil))

(use-package ediff-wind
  :after (ediff)
  :custom
  (ediff-window-setup-function #'ediff-setup-windows-plain)
  (ediff-split-window-function #'split-window-horizontally))

(use-package vc-git
  :custom (vc-git-print-log t))

(use-package vc-annotate
  :config (setq vc-annotate-background-mode nil))

(defun my/git-commit-hook ()
  (setq fill-column 72))

(use-package git-commit
  :config (add-to-list 'git-commit-style-convention-checks
                       'overlong-summary-line)
  :hook ((git-commit . my/git-commit-hook))
  :bind ((:map git-commit-mode-map
               ("C-c C-a" . git-commit-co-authored))))

;; TODO: We need to take into account that the base-path may already
;; have a suffix.
(defun my/copy-env-file (base-path parent-path new-branch)
  "Take the parent-path and the new-branch.

Copy the .env file from the parent-path to the worktree-directory.
And update the branch as a suffix."
  (let ((env-file (concat parent-path ".env"))
        (new-env-file (concat base-path new-branch "/.env"))
        (suffix (concat "_" (subst-char-in-string ?- ?_ new-branch ))))
    (copy-file env-file new-env-file)
    (let ((env-buffer (find-file-noselect new-env-file)))
      (with-current-buffer env-buffer
        (goto-char (point-min))
        (search-forward "_DATABASE:")
        (move-end-of-line 1)
        (insert suffix)

        (goto-char (point-min))
        (search-forward "_TEST_DATABASE:")
        (move-end-of-line 1)
        (insert suffix)
        (save-buffer)))))

(defun my/setup-connect-web (base-path parent-path new-branch)
  (let ((server-config-file (concat parent-path "serverConfig.json"))
        (new-server-config-file (concat base-path new-branch "/serverConfig.json"))
        (public-config-file (concat parent-path "publicConfig.json"))
        (new-public-config-file (concat base-path new-branch "/publicConfig.json")))
    (copy-file server-config-file new-server-config-file)
    (copy-file public-config-file new-public-config-file)))

;; If the base-path ends in connect-backend, my/copy-env-file. If the
;; base-path ends in connect-web copy public.json and serverConfig.json
(defun my/setup-worktree (base-path tld branch)
  (cond ((string-match-p "connect-backend" base-path)
         (my/copy-env-file base-path tld branch))
        ((string-match-p "connect-web" base-path)
         (my/setup-connect-web base-path tld branch))))


(defun my/magit-worktree-branch (branch)
  (interactive (list (magit-read-string-ns "Branch name [for new worktree]")))
  (let* ((tld (magit-toplevel))
         (base (file-name-directory (directory-file-name tld)))
         (wk-path (concat base branch "/"))
         (starting-branch (if (string= "master" (magit-get-current-branch))
                             "master"
                           (magit-read-starting-point branch))))
    (magit-worktree-branch wk-path branch starting-branch)
    (my/setup-worktree base tld branch)
    wk-path))

(with-eval-after-load 'magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-modules
                          'magit-insert-stashes
                          'append))

(use-package magit
  :after (vc-annotate)
  :commands (magit-status magit-dispatch)
  :custom
  (magit-diff-refine-hunk t)
  (magit-visit-ref-behavior '(checkout-branch))
  (magit-wip-mode t)
  (magit-delete-by-moving-to-trash nil)
  ;; (magit-list-refs-sortby "-creatordate")
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)
         ("C-c g" . magit-file-dispatch)
         ("C-c M-g" . magit-file-dispatch)
         ("C-c l" . magit-list-repositories)
         (:map vc-annotate-mode-map
               ("<return>" . my/show-commit))
         (:map magit-file-section-map
               ("<return>" . magit-diff-visit-file-other-window)))
  :hook ((magit-log-edit-mode . auto-fill-mode))
  :config (progn
            (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-topleft-v1
                  ;; magit-display-buffer-function 'magit-display-buffer-traditional
                  magit-visit-ref-behavior '(checkout-branch)
                  global-magit-file-buffer-mode t)
            (magit-add-section-hook 'magit-status-sections-hook
                                    'magit-insert-worktrees
                                    'magit-insert-unpushed-to-upstream-or-recent)
            (magit-add-section-hook 'magit-status-sections-hook
                                    'magit-insert-branch-description
                                    nil
                                    t)
            (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
            ;; TODO: Replace the c suffix instead of append
            ;; (transient-replace-suffix).
            (transient-append-suffix 'magit-worktree "c"
              '("%" "My Branch and worktree" my/magit-worktree-branch))))

(when (string= "work" (daemonp))
  (setq magit-repository-directories
        '(("/home/puercopop/hcp/" . 1))))

(when (not (string= "work" (daemonp)))
  (setq magit-repository-directories
        '(("/home/puercopop/quicklisp/local-projects/cl-xcb/" . 0)
          ("/home/puercopop/quicklisp/local-projects/tsuru/" . 0)
          ("/home/puercopop/quicklisp/local-projects/tenahu/" . 0))))

;; TODO:
;; (transient-insert-suffix 'forge-dispatch "Remote"
;;   ;; Maybe branch
;;   '("o" "Browse repository" forge-browse-remote))
;; (use-package forge
;;   ;; :load-path "/home/puercopop/code/forge"
;;   :after (magit)
;;   :custom-face (forge-topic-closed ((t (:inherit magit-dimmed :strike-through t)))))

(use-package gh-notify
  :load-path "site-lisp/gh-notify")

;; (use-package github-review
;;   :bind ((:map magit-mode-map
;;                (("C-c r" . github-review-forge-pr-at-point))))
;;   ;; Two mappings:
;;   ;; - C-x r in forge-mode-map to github-review-forge-pr-at-point
;;   ;; - C-c s my/github-review-kill-suggestion
;;   )

(use-package code-review
  :config (setq code-review-fill-column 80)
  :bind ((:map magit-mode-map
               (("C-c r" . code-review-forge-pr-at-point)))))

(use-package browse-at-remote
  :after (magit)
  :config
  ;; Maybe this should be under the remote transient?
  (transient-append-suffix 'magit-file-dispatch "m"
    '("o" "Browse file" browse-at-remote))
  (transient-replace-suffix 'magit-dispatch "o"
    '("o" "Browse file" browse-at-remote))
  :bind (("C-c o" . browse-at-remote)
         (:map magit-log-mode-map
               (("C-c o" . browse-at-remote)))))

(use-package moe-theme)

(use-package cyberpunk-theme
  :load-path "site-lisp/cyberpunk-theme/")

;; plan9-theme

(use-package parchment-theme)

(use-package acme-theme)

(use-package exotica-theme
  :load-path "site-lisp/exotica-theme/")

(use-package tangotango-theme
  :config
  ;; :custom-face
  ;; (show-paren-match ((t (:underline t :bold t :background nil))))
  )

(use-package tron-legacy-theme
  :config (setq tron-legacy-theme-vivid-cursor t
                tron-legacy-theme-softer-bg t))

(use-package doom-themes)

(defun my/set-theme (frame)
  ;; (load-theme 'parchment t)
  (when (string= "personal" (daemonp))
    (if (display-graphic-p frame)
        ;; (load-theme 'exotica t)
        ;; (load-theme 'doom-opera t)
        ;; (load-theme 'ef-day t)
        ;; (disable-theme 'exotica)
        (load-theme 'parchment t)
      ))
  (when (string= "work" (daemonp))
    ;; (load-theme 'doom-xcode t)
    (load-theme 'ef-spring t))
  (when (string= "social" (daemonp))
    (load-theme 'doom-1337 t))
  ;; (set-face-attribute 'default nil :family "Go Mono" :height 170)
  (set-frame-font "DejaVu Sans Mono-18"))
;;(set-frame-font "IBM Plex Mono-22")
;;(set-frame-font "Go Mono-18")
;; (set-frame-font "IBM Plex Mono-18" nil t)
;;(set-frame-font "DejaVu Sans Mono-18")
(add-to-list 'default-frame-alist
	     (cons 'font "IBM Plex Mono-18"))
;; (set-frame-font "IBM Plex Mono-18" nil t)
;; (add-hook 'after-init-hook 'my/set-theme)
(add-hook 'after-make-frame-functions 'my/set-theme)
;; (add-hook 'server-after-make-frame-functions 'my/set-theme)

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification))

(require 'comint)
(define-key comint-mode-map (kbd "C-c C-x") nil)
(define-key comint-mode-map (kbd "C-c C-r") nil)


(use-package compile
  :config (setq compilation-scroll-output 'first-error
                compilation-ask-about-save nil)
  :bind ((:map compilation-mode-map
               ("n" . compilation-next-error)
               ("p" . compilation-previous-error))))

(use-package xterm-color
  :after (compile)
  :init
  (progn
    (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter t)
    (setq comint-output-filter-functions
          (remove 'ansi-color-process-output comint-output-filter-functions))
    (add-hook 'compilation-start-hook
          (lambda (proc)
            (when (eq (process-filter proc) 'compilation-filter)
              (set-process-filter proc
                                  (lambda (proc string)
                                    (funcall 'compilation-filter proc
                                             (xterm-color-filter string)))))))))

(use-package htmlize)

(add-hook 'text-mode-hook 'auto-fill-mode)

(use-package markdown-mode
  :custom (markdown-reference-location 'end)
  :hook ((markdown-mode . auto-fill-mode)))

(use-package restclient
  :bind (:map restclient-mode-map
              ("C-c C-f" . json-mode-beautify)))

(use-package ob-restclient)

;; This provides elasticsearch language to org-babel
(use-package es-mode)

(use-package calendar
  :config (setq diary-file (locate-user-emacs-file (format "%s-diary" my/server-name))))

(require 'info)
(define-key Info-mode-map (kbd "TAB") 'forward-button)


;;; Org-mode
;; TODO: Add https://github.com/alphapapa/org-ql

(use-package ekg
  :init
  (when (string= "personal" (daemonp))
    (setq ekg-db-file "personal.db")))

(global-set-key (kbd "C-c C-n") #'ekg-capture)
(with-eval-after-load 'ekg
  (define-key ekg-notes-mode-map "e" #'ekg-notes-open))

(require 'org-clock)
(defun my/org-clock-dwim ()
  "If the clock is active, jump to the current task. Otherwise
present the list of recent tasks to choose which one to clock
in."
  (interactive)
  (if (org-clocking-p)
      (org-clock-jump-to-current-clock)
    (org-clock-in '(4))))

;; (defvar my-local-agenda-file nil)
(defun my/org-agenda-list (&optional arg)
  (interactive "P")
  (cl-flet ((find-hacking-file ()
                               (let* ((tld (or (locate-dominating-file default-directory ".git/")
                                               (locate-dominating-file default-directory "HACKING.org")
                                               default-directory))
                                      (hacking-file (concat tld "HACKING.org")))
                                 (and (file-exists-p hacking-file)
                                      hacking-file))))
    (let ((local-agenda-file (find-hacking-file)))
      (if local-agenda-file
          (let* ((lexical-binding nil)
                 (org-agenda-files (list local-agenda-file)))
            ;; (org-agenda-list)
            (org-todo-list))
        ;; (org-agenda-list)
        (org-agenda arg "w")))))

(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c C-x C-x" . org-clock-in-last)
         ("C-c C-x C-o" . org-clock-out)
         ("C-c C-x C-j" . org-clock-goto)
         ;; ("<f5>" . my/org-clock-dwim)
         ("<f5>" . my/org-agenda-list)
         ;; ("C-c j" . org-goto)
         ("C-c b" . org-switchb)
         ("C-c I" . my/org-clock-dwim)
         (:map org-mode-map
               (("C-c C-s" . org-schedule)
                ("C-S-<right>" . org-metaright)
                ("C-S-<left>" . org-metaleft))))
  :init (org-babel-do-load-languages
         'org-babel-load-languages
         '((sql . t)
           (shell . t)
           (restclient . t)))
  :hook  ((org-clock-in . save-buffer)
          (org-clock-out . save-buffer))
  :custom
  (org-agenda-window-setup 'current-window)
  (org-clock-sound "/usr/share/sounds/gnome/default/alerts/bark.ogg")
  (org-clock-clocked-in-display 'both)
  (org-clock-mode-line-total 'current)
  (org-deadline-warning-days 3)
  (org-agenda-dim-blocked-tasks nil)
  (org-agenda-window-setup 'reorganize-frame)
  (org-loop-over-headlines-in-active-region 'start-level)
  (org-adapt-indentation nil)
  (org-duration-format 'h:mm)
  (org-src-tab-acts-natively t)
  ;; TODO: Compile X11idleTime and enable idle setting
  ;; (org-clock-idle-time 5) ; minutes
  (org-archive-subtree-add-inherited-tags t)
  :config (setq org-confirm-babel-evaluate nil
                org-use-speed-commands t
                org-fold-catch-invisible-edits 'error
                org-ctrl-k-protect-subtree t
                org-special-ctrl-a/e t
                org-special-ctrl-k t
                org-enforce-todo-dependencies t
                org-log-done 'time
                org-log-into-drawer t
                org-reverse-note-order t
                org-agenda-show-future-repeats 'next
                org-agenda-prefer-last-repeat t
                org-agenda-sorting-strategy '((agenda habit-down time-up effort-up todo-state-down priority-down category-keep)
                                              (todo priority-down category-keep)
                                              (tags priority-down category-keep)
                                              (search category-keep))
                ;; org-refile-targets '((org-agenda-files . (:maxlevel . 1))))
                org-agenda-start-day "-1d"
                org-agenda-start-on-weekday nil
                org-agenda-skip-deadline-if-done t
                org-agenda-skip-scheduled-if-done t
                org-agenda-block-separator ?—
                ;; I want W to list priority Task, Week and the rest of :remotelock: or :work: todos. Or current sprint
                ;; Current Tickets
                ;; Work + Developer Calendar
                ;; Current Sprint
                ;; TODOS
                org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  (require 'org-datetree)
  ;; Adapted from org-datetree-find-iso-week-create
  (defun my/org-weekly-datetree (d &optional keep-restriction)
  "Find or create an ISO week entry for date D.
Compared to `org-datetree-find-date-create' this function creates
entries ordered by week instead of months.
When it is nil, the buffer will be widened to make sure an existing date
tree can be found.  If it is the symbol `subtree-at-point', then the tree
will be built under the headline at point."
  (setq-local org-datetree-base-level 1)
  (save-restriction
    (if (eq keep-restriction 'subtree-at-point)
	(progn
	  (unless (org-at-heading-p) (error "Not at heading"))
	  (widen)
	  (org-narrow-to-subtree)
	  (setq-local org-datetree-base-level
		      (org-get-valid-level (org-current-level) 1)))
      (unless keep-restriction (widen))
      ;; Support the old way of tree placement, using a property
      (let ((prop (org-find-property "WEEK_TREE")))
	(when prop
	  (goto-char prop)
	  (setq-local org-datetree-base-level
		      (org-get-valid-level (org-current-level) 1))
	  (org-narrow-to-subtree))))
    (goto-char (point-min))
    (require 'cal-iso)
    (let* ((year (calendar-extract-year d))
	   (month (calendar-extract-month d))
	   (day (calendar-extract-day d))
	   (time (encode-time 0 0 0 day month year))
	   (iso-date (calendar-iso-from-absolute
		      (calendar-absolute-from-gregorian d)))
	   (weekyear (nth 2 iso-date))
	   (week (nth 0 iso-date)))
      ;; ISO 8601 week format is %G-W%V(-%u)
      (org-datetree--find-create
       "^\\*+[ \t]+\\([12][0-9]\\{3\\}\\)\\(\\s-*?\
\\([ \t]:[[:alnum:]:_@#%%]+:\\)?\\s-*$\\)"
       weekyear nil nil
       (format-time-string "%G" time))
      (org-datetree--find-create
       "^\\*+[ \t]+%d-W\\([0-5][0-9]\\)$"
       weekyear week nil
       (format-time-string "%G-W%V" time)))))

  (defun my/org-archive-subtree (archive-buffer)
    (with-current-buffer archive-buffer
      (goto-char (point-max))
      (while (org-up-heading-safe))
      (let* ((olpath (org-entry-get (point) "ARCHIVE_OLPATH"))
             (path (and olpath (split-string olpath "/")))
             (level 1)
             tree-text)
        (when olpath
          (org-mark-subtree)
          (setq tree-text (buffer-substring (region-beginning) (region-end)))
          (let (this-command) (org-cut-subtree))
          (goto-char (point-min))
          (save-restriction
            (widen)
            (dolist (heading path)
              (if (re-search-forward (rx-to-string
                                      `(: bol (repeat ,level "*") (1+ " ") ,heading))
                                     nil t)
                  (org-narrow-to-subtree)
                (goto-char (point-max))
                (unless (looking-at "^")
                  (insert "\n"))
                (insert (make-string level ?*)
                        " "
                        heading
                        "\n"))
              (cl-incf level))
            (widen)
            (org-end-of-subtree t t)
            (org-paste-subtree level tree-text))))))
  (require 'org-archive)
  (defun my/org-archive-subtree-advice (orig-fn &rest args)
    (let* ((fix-archive-p (and (not current-prefix-arg)
                               (not (use-region-p))))
           (filename (car (org-archive--compute-location (or (org-entry-get nil "ARCHIVE" 'inherit)
                                                             org-archive-location))))
           (archive-buffer (or (find-buffer-visiting filename)
                               (find-file-noselect filename))))

      (apply orig-fn args)
      (when fix-archive-p
        (my/org-archive-subtree archive-buffer))))

  (advice-add 'org-archive-subtree :around #'my/org-archive-subtree-advice))

(defun my/unschedule-waiting-entries (state-change)
  (let ((to-state (plist-get state-change :to))
        (entry-start-pos (plist-get state-change :position)))
    (when (cl-some (lambda (str)
                     (string-collate-equalp str to-state nil t))
                   '("WAITING"))
      (save-excursion
        (goto-char entry-start-pos))
      (org-remove-timestamp-with-keyword "SCHEDULED:"))))

(add-hook 'org-trigger-hook 'my/unschedule-waiting-entries)

;; ref. https://emacs.stackexchange.com/a/31708
(defun diary-last-day-of-month (date)
"Return `t` if DATE is the last day of the month."
  (let* ((day (calendar-extract-day date))
         (month (calendar-extract-month date))
         (year (calendar-extract-year date))
         (last-day-of-month
            (calendar-last-day-of-month month year)))
    (= day last-day-of-month)))

(require 'org-agenda)
;; (use-package org-tempo)
;; (require 'org-tempo)
(require 'org-protocol)

;; (use-package org-contrib)

(defun org-scratch ()
  (interactive)
  (pop-to-buffer
   (with-current-buffer (get-buffer-create "*org-scratch*")
     (org-mode)
     (current-buffer))))

;; I want to be able to capture to the same entry to two places. The daily recap and the weekly retro.
(defun my/org-find-daily-recap ()
  "To be used from org-capture. Finds the headline with the title Recap and "
  (save-restriction
    (goto-char (org-find-exact-headline-in-buffer "Daily Recaps"))
    (org-narrow-to-subtree)
    (org-datetree-find-date-create (calendar-current-date) t)
    ;; (org-up-heading-safe
    ;; (org-demote-subtrree
    ))

(defun my/org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (my/org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (my/org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun my/org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

;; (defun  my/skip-unless-scheduled-for-today ()
;;   (message "Point at %s"  (point))
;;   nil)

(setq org-clock-persist-file
       (convert-standard-filename
        (concat user-emacs-directory my/server-name "-org-clock-save.el")))

(when (string= my/server-name "work")
  (setq org-agenda-files '("~/hcp/inbox.org")
        org-refile-targets '(("~/hcp/inbox.org" :maxlevel . 1))
        org-todo-keywords '(
                            ;; Story flow ; To we want a NEXT/Current header?
                            ;; The code Review flow only involves TODO WAITING and DONE
                            (sequence "TODO"  "WAITING(!)" "TO-DEPLOY" "|" "DONE" "WONT-DO(x)"))
        org-agenda-custom-commands '(("o" "At the Office" tags-todo "@office"
                                      ((org-agenda-overriding-header "Office")
                                       (org-agenda-skip-function 'my/org-agenda-skip-all-siblings-but-first)))
                                     ("w" "HousecallPro"
                                      ;; First meetings
                                      ((tags-todo "meeting"
                                                  ((org-agenda-overriding-header "Meetings for today")
                                                   (org-agenda-todo-ignore-scheduled 'future)
                                                   ;; (org-agenda-skip-function 'my/skip-unless-scheduled-for-today)
                                                   )) ; Add skip if today
                                       (tags-todo "code_review"
                                                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("WAITING")))
                                                   (org-agenda-overriding-header "Pending Code Review"))) ; Add skip if not waiting
                                       (tags-todo "PRIORITY=\"A\"")
                                       (agenda "")
                                       (alltodo)
                                       )
                                      ;; This is unnecessary,;; we can use the :work: tag.
                                      ((org-agenda-files '("~/org/remotelock.org"))
                                       (org-agenda-span 'day)
                                       (org-agenda-start-day nil)
                                       (org-agenda-use-time-grid nil)))
                                     ("u" "Unscheduled TODOs" tags-todo "@work"
                                      ((org-agenda-overriding-header "Unscheduled TODOs")
                                       (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))))))

  (defun my/clock-out-when-waiting ()
    (when (string= org-state "WAITING")
      (and (org-clocking-p)
           (org-clock-out))))

  (add-hook 'org-after-todo-state-change-hook 'my/clock-out-when-waiting)

  (setq org-capture-templates
        '(
          ("n" "Add Note to Current Task" plain (clock))
          ("t" "Work task" entry (file+headline "~/hcp/inbox.org" "Tasks")
           "* TODO %?
SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n"
           :prepend t)
          ("f" "Mail follow-up" entry (file+headline "~/hcp/inbox.org" "Tasks")
           "* TODO Reply to email from %:fromname
:PROPERTIES:
:MAIL-SOURCE: %a
:END:
")
          ("d" "Daily Journal" entry (file+olp+datetree "~/hcp/inbox.org" "Journal")
           "* %t %?
#+BEGIN: clocktable maxlevel: 5 :block %(format-time-string \"%Y-%m-%d\" (current-time)) :scope file-with-archives :link t
#+CAPTION:
#+END: clocktable
\n" :prepend t :jump-to-captured t)

          ;; TODO: I could leverage org-dblock-write:clocktable
          ;; org-clocktable-steps to generate the table
          ;; ("w" "Weekly Reports" entry
;;            (file+olp+datetree "~/org/remotelock.org" "Weekly Reports")
;;            "* Recap %?
;; #+BEGIN: clocktable maxlevel: 5 :block %(format-time-string \"%G-W%V\" (current-time)) :scope file-with-archives :emphasize t
;; #+CAPTION:
;; #+END: clocktable
;; \n" :tree-type week :prepend t :time-prompt t)

;;           ("r" "Monthly Report" entry
;;            (file+olp+datetree "~/org/remotelock.org" "Monthly Reports")
;;            "* Recap
;; #+BEGIN: clocktable maxlevel: 5 :block %(format-time-string \"%Y-%m\" (current-time)) :scope file-with-archives :emphasize t
;; #+CAPTION:
;; #+END: clocktable
;; \n" :tree-type month :prepend t :time-prompt t)

          ("m" "Meeting" entry (file+headline "~/hcp/inbox.org" "Meetings")
           "* %?\n %T\n" :prompt t :prepend t)
          ;; Accompanying Bookmarklet
          ;; javascript:location.href'org-protocol://capture?template=wr&title='+encodeURIComponent(document.title)+'&url='+encodeURIComponent(window.location.href)
          ("R" "Code Review" entry
           (file+headline "~/hcp/inbox.org" "Code Reviews")
           "* TODO Review %?%:title
SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))
:PROPERTIES:
:GITHUB-URL: %:link
:END:
\n")
          ;; TODO: Add a capture for the JIRA ticket
          ;; javascript:location.href'org-protocol://capture?template=wJ&title='+encodeURIComponent(document.title)+'&issue_url='+encodeURIComponent(window.location.href)
          ("J" "Jira Ticket" entry
           (file+headline "~/hcp/inbox.org" "Tasks")
           "* TODO %?%:title
:PROPERTIES:
:JIRA-URL: %:link
:END:
\n"))))

(when (not (string= my/server-name "work"))
  (setq org-agenda-files '("~/org/household.org" "~/org/all.org")
        org-refile-targets '(("~/org/all.org" :maxlevel . 1))
        org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "WONT-DO(x)")))

  (setq org-capture-templates
        '(("t" "Task" entry (file+headline "~/org/all.org" "Miscellaneous Captures")
           "* TODO %?\n %i\n %a")
          ;; Deprecated date/weektree capture templates changed to ‘file+olp+datetree’.
          ("j" "Journal" entry (file+datetree "~/org/journal.org") "* %?"  :empty-lines 1)
          ("n" "Add Note to Current Task" plain (clock))
          ;; TODO: Add a template to capture a new note under the currently clocked template
          )))

(when (string= my/server-name "social")
  (require 'org-feed)
  (setq org-feed-alist '(("Hiper Derecho" "https://hiperderecho.org/feed/"
                          "~/org/feeds.org" "Hiper Derecho")
                         ("Libre Lounge" "https://librelounge.org/rss-feed.rss"
                          "~/org/feeds.org" "Libre Lounge"))))


(require 'org-pomodoro)
(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro))

;; (require 'jira)
;; (use-package org-jira
;;   :load-path "site-lisp/org-jira"
;;   :config (setq jiralib-url "https://remotelock.atlassian.net/"
;;                 org-jira-working-dir "~/org/jira/"
;;                 org-jira-worklog-sync-p nil
;;                 org-jira-default-jql "sprint in openSprints() and sprint not in futureSprints() and assignee = currentUser() and resolution = unresolved ORDER BY priority DESC, created SAC"))

;; (use-package ox-jira
;;   :load-path "site-lisp/ox-jira.el")

;; (use-package jiralib2
;;   :load-path "site-lisp/jiralib2")

;; (use-package ejira
;;   :load-path "site-lisp/ejira")

(require 'bug-reference)
(when (string= "work" (daemonp))
  (setq bug-reference-bug-regexp "\\(GROW-\\([0-9]+\\)\\)"
        bug-reference-url-format "https://housecall.atlassian.net/browse/GROW-%s"))

;; (use-package org-gcal
;;   :load-path "site-lisp/org-gcal.el"
;;   :config (setq org-gcal-client-id "1005544412528-m1u3gtf77an81a54mndal3j49eccq08e.apps.googleusercontent.com"
;;                 org-gcal-client-secret "QieULkXk8DUCsMunLSJ_Tubful"
;;                 ;; developers@remotelock.com id
;;                 org-gcal-file-alist '(("pirata@gmail.com" . "~/org/calendars/personal.org")
;;                                       ("javier.olaechea@remotelock.com" . "~/org/calendars/remotelock.org"))))

;; org-gcal-autoarchive y notify-p

;; (use-package annotate
;;   :hook ((prog-mode . annotate-mode)))

;; (use-package org-annotate
;;   :load-path "site-lisp/org-annotate")

;; (use-package hyperbole)


;;; Browser

;; (use-package w3m)

;; Warning (browse-url): Having ‘browse-url-browser-function’ set to an
;; alist is deprecated.  Use ‘browse-url-handlers’ instead. Disable showing Disable logging
(when (string= my/server-name "personal")
  (setq browse-url-default-handlers
        '(("\\`mailto:" . browse-url--mailto)
         ("\\`man:" . browse-url--man)
         (browse-url--non-html-file-url-p . browse-url-emacs)
         ("\\(?:^http://www\\.lispworks\\.com/reference/HyperSpec.*\\)" . eww-browse-url)
         ("." . browse-url-firefox))))

(when (string= my/server-name "work")

  (setq browse-url-firefox-program "firefox-trunk"
        browse-url-browser-function 'browse-url-firefox))

(when (string= my/server-name "social")
  (setq browse-url-browser-function 'eww-browse-url))


;;; Mail
(if (string= my/server-name "work")
    (setq user-mail-address "javier.olaechea@housecallpro.com")
  (setq user-mail-address "pirata@gmail.com"))

(use-package notmuch
  :load-path "/usr/local/share/emacs/site-lisp/")

(when (string= my/server-name "work")
  (use-package mu4e
    :load-path "/usr/local/share/emacs/site-lisp/mu4e/"
    :commands (mu4e)
    :custom (mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum)
    ;; (mu4e-split-view 'single-window)
    (mu4e-index-lazy-check t)
    :config (setq mu4e-sent-folder "/Sent Mail"
                  mu4e-trash-folder "/Trash"
                  ;; `(,(make-mu4e-bookmark
                  ;;                    :name "Boring Lists"
                  ;;                    :query
                  ;;                    :key ?l))
                  mu4e-bookmarks '(("flag:unread AND NOT flag:trashed" "Unread messages" 117)
                                   ("date:today..now" "Today's messages" 116)
                                   ("date:7d..now" "Last 7 days" 119)
                                   ("flag:unread AND (from:sentry OR from:ayla)" "Boring lists" 108)
                                   ("mime:image/*" "Messages with images" 112))
                  mail-user-agent 'mu4e-user-agent
                  ;; mu4e-get-mail-command "mbsync remotelock-all"
                  mu4e-change-filenames-when-moving t
                  ;; Increase read-process-output-max to make
                  ;; communication faster.
                  read-process-output-max (* 1024 1024)
                  mu4e-headers-include-related nil
                  mu4e-view-show-addresses t
                  user-mail-address "javier.olaechea@remotelock.com"))

  (require 'mu4e-contrib)
  ;; TODO: Configure mu4e-alert
  (require 'mu4e-org)
  (use-package mu4e-alert
    :after (mu4e))

  ;; (require 'mu4e-icalendar)
  ;; (mu4e-icalendar-setup)
  (require 'gnus-icalendar)
  (use-package gnus-icalendar
    :after (org-agenda)
    :config
    (setq gnus-icalendar-org-capture-file "~/org/remotelock.org"
          gnus-icalendar-org-capture-headline '("Meetings"))
    (gnus-icalendar-org-setup)))


;; TODO: add mu4e-action to process an ical invitation and capture it in an org-file
;; TODO: Add mu4e-action to open JIRA ticket.
;; mu4e-view-actions
;; mu4e-view-attachment-actions

;; (use-package undo-tree
;;   :config (global-undo-tree-mode 1)
;;   :bind (("C-x u" . undo-tree-visualize)))

;; TODO: Bind M-w to copy selection and exit
(use-package isearch
  :custom (isearch-allow-scroll 'unlimited)
  :bind (("M-*" . isearch-forward-symbol-at-point)
         (:map isearch-mode-map
               ("C-j " . isearch-exit))))

(advice-add 'isearch-exit :after
            (lambda (&rest _ignore)
              (when (and isearch-forward
                         isearch-success
                         isearch-other-end)
               (goto-char isearch-other-end))))

(use-package isearch-dabbrev
  :bind (:map isearch-mode-map
              ("<tab>" . isearch-dabbrev-expand)
              ("M-/" . isearch-dabbrev-expand)))

(global-set-key [remap dabbrev-expand] 'hippie-expand)

(use-package imenu
  :bind (("M-i" . imenu)))

(use-package dired
  :config
      (setq dired-dwim-target t
            dired-listing-switches "-alh")
  :hook ((dired-mode . dired-hide-details-mode)))

(use-package dired-x
  :after (dired))

(require 'ibuf-ext)
(defun my/ibuffer-vc-hook ()
  (ibuffer-vc-set-filter-groups-by-vc-root)
  (unless (eq ibuffer-sorting-mode 'alphabetic)
    (ibuffer-do-sort-by-alphabetic)))

(use-package ibuffer-vc
  :hook ((ibuffer . my/ibuffer-vc-hook)))

(use-package xref
  :config (setq xref-search-program 'ripgrep))

(use-package man
  :custom (Man-width 80))

(electric-pair-mode t)

(use-package paredit
  :after (sly)
  :bind ((:map paredit-mode-map
               (("M-?" . nil)
                ("M-s" . nil)
                ("M-k" . paredit-splice-sexp)))
         (:map search-map
               (("M-s" . paredit-splice-sexp))))
  :config
  (setq paredit-space-for-delimiter-predicates
      (list
       ;; #'my/at-feature-expression
       (lambda (endp _delimiter)
         (if endp
             t ; Check if this makes sense
           (let ((text-before (buffer-substring-no-properties (- (point) 2) (point))))
             (not (string-equal "#+" text-before)))))
       (lambda (endp _delimiter)
         (if endp
             t ; Check if this makes sense
           (let ((text-before (buffer-substring-no-properties (- (point) 2) (point))))
             (not (string-equal "#P" text-before)))))))
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (eval-expression-minibuffer-setup . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (sly-mrepl-mode . enable-paredit-mode)))


;; (use-package smartparens
;;   :init (require 'smartparens-ruby)
;;   :hook ((ruby-mode . smartparens-mode)
;;          (js-mode . smartparens-mode)
;;          (typescript-mode . smartparens-mode)))

;; (use-package smartparens
;;   :config
;;   (smartparens-strict-mode)
;;   (sp-pair "${" "}")
;;   (sp-pair "`" "`")
;;   :bind ((:map smartparens-modedmap
;;                ("C-M-f" . sp-forward-sexp)
;;                ("C-M-b" . sp-backward-sexp)
;;                ("C-)" . sp-forward-slurp-sexp)
;;                ("C-(" . sp-backward-slurp-sexp)
;;                ("M-)" . sp-forward-barf-sexp)
;;                ("M-(" . sp-backward-barf-sexp)
;;                ("C-S-s" . sp-splice-sexp)
;;                ("C-M-<backspace>" . backward-kill-sexp)
;;                ("C-M-S-<SPC>" . (lambda () (interactive) (mark-sexp -1))))
;;          (:map js-mode-map
;;                ("C-<right>" . sp-forward-slurp-sexp)
;;                ("C-<left>" . sp-forward-barf-sexp)
;;                ("C-<up>" . sp-unwrap-sexp)
;;                )
;;          )
;;   :hook ((ruby-mode . smartparens-mode)))

(use-package window
  ;; Still need to figure out window parameters
  :config
  :bind (("<f2>" . window-toggle-side-windows)))

(defun frame-named-p (name)
  (lambda (frame)
    (when-let ((frame-name (frame-parameter frame 'name)))
      (when (string= name frame-name)
        name))))

(defun my/make-display-buffer-matcher-function (major-modes)
  (lambda (buffer-name _action)
    (with-current-buffer buffer-name (apply #'derived-mode-p major-modes))))

(setq display-buffer-alist
      `(
        ;; Display Help on its own frame
        ;; ("\\*info\\*"
        ;;  (display-buffer-reuse-window display-buffer-use-some-frame display-buffer-pop-up-frame)
        ;;  (reuseable-frames . t)
        ;;  (frame-predicate . ,(frame-named-p "Emacs info"))
        ;;  (pop-up-frame-parameters . ((name . "Emacs info")
        ;;                              (unsplittable . t))))
        ;; Magit own its own frame
        ;; ("^magit:"
        ;;  (display-buffer-reuse-window display-buffer-use-some-frame display-buffer-pop-up-frame)
        ;;  (reuseable-frames . t)
        ;;  (frame-predicate . ,(frame-named-p "magit"))
        ;;  (pop-up-frame-parameters . ((name . "magit")
        ;;                              (unsplittable . t))))
        ;; Ediff on its own frame

        ;; mu4e and related on its own frame
        ;; "^[[:blank:]]*\\*mu4e-"
        ("^*\\*mu4e-main\\*$"
         ;; We could use display-buffer-fullframe
         (display-buffer-reuse-window display-buffer-use-some-frame display-buffer-pop-up-frame)
         (reuseable-frames . t)
         (frame-predicate . ,(frame-named-p "mu4e"))
         (pop-up-frame-parameters . ((name . "mu4e"))))


        ;; (,(my/make-display-buffer-matcher-function '(org-mode org-agenda-mode))
        ;;  (display-buffer-in-tab display-buffer-in-direction)
        ;;  (ignore-current-tab . t)
        ;;  (direction . right)
        ;;  (tab-name . "🚀 ORG")
        ;;  (tab-group . "Org"))
        ;; https://github.com/joaotavora/sly/pull/189#issuecomment-426295098
        ;; ("\\*sly-mrepl for.*"
        ;;  (display-buffer-window nil))
        ;; ("\\*sly-mrepl for.*"
        ;;  (display-buffer-at-bottom display-buffer-in-side-window)
        ;;  (inhibit-same-window . t)
        ;;  (side . bottom)
        ;;  (window-height . 0.25)
        ;;  (dedicated . t)
        ;;  (slot . 0))
        ;; ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Messages\\)\\*"
        ;;  (display-buffer-in-side-window)
        ;;  (window-height . 0.16)
        ;;  (side . bottom)
        ;;  (slot . 1)
        ;;  (window-parameters . ((no-other-window . t))))
        ;; ("\\*rspec-compilation\\*"
        ;;  (display-buffer-in-side-window)
        ;;  (window-height . 0.3)
        ;;  (side . bottom)
        ;;  (slot . 0))
        ;; ("^\\(\\*e?shell\\|vterm\\).*"
        ;;  (display-buffer-in-side-window)
        ;;  (window-height . 0.25)
        ;;  (side . bottom)
        ;;  (slot . 1))
        ))



;; (add-to-list 'display-buffer-alist
;;              `(,(rx bos "*sly-mrepl")
;;                (display-buffer-reuse-window
;;                 display-buffer-in-side-window)
;;                (side            . bottom)
;;                (reusable-frames . visible)
;;                (window-height   . 10)))


(require 'eldoc)
(add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)

;; (setq paredit-override-check-parens-function (lambda (c) t))
;; (eldoc-add-command
;;  'paredit-backward-delete
;;  'paredit-close-round)

;; (defun my/at-feature-expression (endp delimiter)
;;   nil)

;; (define-key prog-mode-map (kbd "C-*") #'highlight-symbol-next)
;; ~~Implement something like highlight-symbol-next~~. M-* is already
;; bound to isearch-forward-symbol-at-point

(use-package subword
  :hook ((js-mode . subword-mode)
         (typescript-mode . subword-mode)
         (ruby-mode . subword-mode)))

;; (use-package outline
;;   :bind (:map outline-minor-mode-map
;;               (("C-c <up>" . outline-backward-same-level)
;;                ("C-c <down>" . outline-forward-same-level))))

;; (use-package bicycle
;;   :after outline
;;   :bind (:map outline-minor-mode-map
;;               ([C-tab] . bicycle-cycle)
;;               ([S-tab] . bicycle-cycle-global)))

;; TODO: Enable reveal mode

;; (use-package prog-mode
;;   :hook ((prog-mode . outline-minor-mode)
;;          (prog-mode . hs-minor-mode)))

;; (defun my/c-mode-hook ()
;;   (setq indent-tabs-mode))
;; (add-hook c-mode-hook 'my/c-mode-hook)

(use-package web-mode
  :mode "\\.erb\\'"
  :bind (:map web-mode-map
               ("C-c C-j" . nil)
               ("C-c C-r" . nil))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  :mode ("\\.svelte\\'"))

(use-package css-mode
  :custom (css-indent-offset 2))

(use-package yaml-mode)


;;; JavaScript, JSON and TypeScript

(use-package json-mode
  :mode ("\\.json\\'"))

(use-package js
  :custom
  (js-indent-level 2)
  (js-jsx-syntax t))

(use-package js2-mode
  :after (js-mode)
  :hook ((js-mode . js2-minor-mode)))

(use-package xref-js2
  :config (define-key js2-mode-map (kbd "M-.") nil)
  (setq xref-js2-search-program 'rg)
  (add-hook 'js2-mode-hook
            (lambda ()
              (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))

(use-package typescript-mode
  :custom (typescript-indent-level 2)
  :mode ("\\.tsx\\'" "\\.ts\\'"))

(use-package prettier-js
  :config ;; (setq prettier-js-command "npx"
          ;;       prettier-js-args '("prettier"))
  :hook ((js-mode . prettier-js-mode)
         (json-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)))

(use-package jest-test-mode
  :defer t
  :commands jest-test-mode
  :hook ((js-mode . jest-test-mode)
         (typescript-mode . jest-test-mode)))

(defun my/ruby-flymake-hook ()
  (let ((in-rlock-p (string-prefix-p "/home/puercopop/hcp/"
                                     (buffer-file-name (current-buffer)))))
    (when in-rlock-p
      (flymake-mode))))

(use-package flymake
  :hook ((ruby-mode . my/ruby-flymake-hook)
         (js-mode . my/ruby-flymake-hook)
         (typescript-mode . my/ruby-flymake-hook))
  ;; flymake-diagnostic-function -> ruby-flymake-auto
  :config (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  :bind ((:map flymake-mode-map
               ("M-n" . 'flymake-goto-next-error)
               ("M-p" . 'flymake-goto-prev-error))))

(use-package eslint-flymake
  :load-path "site-lisp/eslint-flymake"
  :config (setq eslint-flymake-command '("npx" "eslint" "--no-color" "--stdin"))
  :hook ((typescript-mode . eslint-flymake-setup-backend)))

(use-package compile-eslint
  :after (compile)
  :load-path "site-lisp/compile-eslint"
  :init (push 'eslint compilation-error-regexp-alist))


;; (use-package company
;;   :init (global-company-mode)
;;   :config (progn
;;             (bind-key [remap completion-at-point] #'company-complete company-mode-map)
;;             ;; setq company-backends
;;             (setq company-idle-delay 0.2
;;                   company-echo-delay 0.2))
;;   :bind ((:map company-active-map
;;                ("C-n" . company-select-next)
;;                ("C-p" . company-select-previous)
;;                ("C-d" . company-show-doc-buffer)
;;                ("M-." . company-show-location))
;;          ))

;; TODO:
;; https://www.reddit.com/r/emacs/comments/ijbvwv/eglot_sqls_sql_client/
;; setup SQL LSP action for switching databases;
(require 'xref)
(require 'eglot)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((js-mode typescript-mode) "typescript-language-server" "--stdio"))
  ;; (add-to-list 'eglot-server-programs '((rust-ts-mode rust-mode) . ("rustup" "run" "stable" "rust-analyzer")))
  (define-key eglot-mode-map (kbd "M-.") #'xref-find-definitions)
  ;; replace this with eldoc-buffer
  ;; ("C-c h" . 'eldoc-buffer)
  )


;;; Ruby mode
(require 'flymake)
(defun my/enable-ruby-flymake ()
  (add-to-list 'flymake-diagnostic-functions 'ruby-flymake-auto))

(defun my/set-ruby-docsets ()
  (interactive)
  (setq-local imenu-create-index-function #'ruby-imenu-create-index)
  (setq-local dash-docs-docsets '("Ruby on Rails" "Ruby")))

(use-package ruby-mode
  :custom
  (ruby-deep-arglist nil)
  (ruby-deep-indent-paren nil)
  :hook ((ruby-mode . my/set-ruby-docsets)
         ;; (ruby-mode . my/ruby-imenu-setup)
         ;; (ruby-mode . my/enable-ruby-flymake)
         ))

;; (use-package enh-ruby-mode
;;   :mode "\\.rb$"
;;   :hook ((enh-ruby-mody . my/enable-ruby-flymake)))

(defun my/load-irb-history ()
  (setq comint-input-ring-file-name (substitute-in-file-name "$HOME/.irb-history"))
  (when (ring-empty-p comint-input-ring)
    (comint-read-input-ring t)))

(use-package inf-ruby
  :config (add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
  :bind ((:map inf-ruby-minor-mode-map
               (("C-c C-x" . nil)
                ("C-c C-r" . nil))))
  :hook ((inf-ruby-mode . my/load-irb-history)
         (after-init . inf-ruby-switch-setup)))

(use-package chruby
  ;; :config (chruby-use "ruby-2.6.6")
  )

(defun my/read-env-file (env-file)
  (with-current-buffer (find-file-noselect env-file)
    (cl-loop for line in (split-string (buffer-string) "\n")
             when (string-match "^\\(.+[^[:space:]]\\)[[:space:]]*=[[:space:]]*\\(.+\\)" line)
             collect (format "%s=%s"
                             (match-string-no-properties 1 line)
                             (match-string-no-properties 2 line)))))

(defun my/call-in-rspec-mode (fn)
  (lambda (orig-fn &rest args)
    (if (eq major-mode 'rspec-compilation-mode)
      	(apply fn orig-fn args)
      (apply orig-fn args))))

(defun my/maybe-inject-proccess-environment (orig-fun &rest args)
  (chruby-use-corresponding)
  (when-let (;; (default-directory (locate-dominating-file default-directory ".git"))
             (default-directory (locate-dominating-file default-directory #'inf-ruby-console-match))
             (process-environment (append (my/read-env-file ".env") process-environment)))
    (apply orig-fun args)))

(use-package robe
  :config (global-robe-mode)
  :hook ((ruby-mode . robe-mode))
  :init (advice-add 'inf-ruby-console-auto :around #'my/maybe-inject-proccess-environment))

;; TODO: Hook/advice into rspec-spec-file-for to add mappings for connect backend
;; We want to redirect controllers to spec/api/v1/
;; and tenant -> tenant_api/
;; Think using a alist to make it extensible for the user.

;; TODO: We need to define match for the reverse case. my/rspec-target-file-for
(defun my/override-rspec-spec-file-for (file-name)
  (let ((mappings
         '(("rlock/connect-backend/.*?/app/controllers/api/v1/"
            "app/controllers/api/v1/\\(.*\\)_controller.rb"
            "spec/api/v1/\\1_spec.rb")
           ("rlock/connect-backend/.*?/app/controllers/tenant_api/"
            "app/controllers/tenant_api/\\(.*\\).rb"
            "spec/tenant_api/\\1_spec.rb"))))
    (assoc file-name mappings
           (lambda (pat file-name)
             (string-match pat file-name)))))

(defun my/advice-rspec-spec-file-for (orig-fn a-file-name)
  (if-let ((rule (my/override-rspec-spec-file-for a-file-name)))
      (replace-regexp-in-string (cl-second rule)
                                (cl-third rule)
                                a-file-name)
    (funcall orig-fn a-file-name)))

(defun my/override-rspec-target-file-for (file-name)
  (let ((mappings
         '(("rlock/connect-backend/.*?/spec/api/v1/"
            "spec/api/v1/\\(.*\\)_spec.rb"
            "app/controllers/api/v1/\\1_controller.rb")
           ("rlock/connect-backend/.*?/spec/tenant_api/"
            "spec/tenant_api/\\(.*\\)_spec.rb"
            "app/controllers/tenant/\\1.rb"))))
    (assoc file-name mappings
           (lambda (pat file-name)
             (string-match pat file-name)))))

(defun my/advice-rspec-target-file-for (orig-fn a-file-name)
  (if-let ((rule (my/override-rspec-target-file-for a-file-name)))
      (replace-regexp-in-string (cl-second rule)
                                (cl-third rule)
                                a-file-name)
    (funcall orig-fn a-file-name)))

(use-package rspec-mode
  :hook ((dired-mode . rspec-dired-mode))
  :custom (rspec-use-spring-when-possible nil)
  :init (progn
          ;; (advice-add 'rspec-compile :around #'my/maybe-inject-proccess-environment)
          ;; (advice-add 'recompile :around (my/call-in-rspec-mode  #'my/maybe-inject-proccess-environment))
          (advice-add 'rspec-spec-file-for :around #'my/advice-rspec-spec-file-for)
          (advice-add 'rspec-target-file-for :around #'my/advice-rspec-target-file-for)
          (add-hook 'after-init-hook 'inf-ruby-switch-setup)))

(fset 'my/rails-open-backtrace
      (kmacro [?o ?p ?e ?n ?\( ?\' ?s ?c ?r ?a ?t ?c ?h ?. ?h ?t ?m ?l ?\' ?, ?  ?\' ?w ?\' ?\) ?  ?\{ ?  ?| ?f ?| ?  ?f ?. ?w ?r ?i ?t ?e ?\( ?r ?e ?s ?p ?o ?n ?s ?e ?_ ?b ?o ?d ?y ?\) ?  ?\} ?\C-m ?\M-: ?\( ?f ?i ?n ?d ?- ?f ?i ?l ?e ?  ?\" ?s ?c ?r ?a ?t ?c ?h ?. ?h ?t ?m ?l ?\" ?\) ?\C-m ?\M-x ?s ?h ?r ?- ?r ?e ?n ?d ?e ?r ?- ?b ?u ?f ?f ?e ?r ?\C-m] 0 "%d"))

(use-package rails-log-mode
  :load-path "site-lisp/rails-log-mode")

(use-package bundler)

;; Go

;; TODO: gofmt-mode minor mode
(defun my/go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save nil 'local))

(use-package go-mode
  :bind ((:map go-mode-map
               ("C-c C-d" . godoc-at-point-function)))
  :hook ((godoc-mode . help-mode)
         (go-mode . gofmt-mode)))

(require 'go-dlv)
;; go-eldoc
;; go-autocomplete
;; company-go
;; golint
;; go-errcheck
;; gotest
;; go-guru


;; SQL

;; TODO: save history (comint-input-ring?)
(use-package sql
  ;; :bind (("C-c a s" . sql-connect))
  :config
  ;; TODO: Use sql-product to use a different history for postgres and mysql.
  (setq sql-input-ring-file-name (substitute-in-file-name "$HOME/.sqli_history"))
  (plist-put (cdr (assq 'postgres sql-product-alist)) :prompt-regexp "^[[:alnum:]_-]*=[#>] ")
  (plist-put (cdr (assq 'postgres sql-product-alist)) :prompt-cont-regexp "^[[:alnum:]_-]*[-(][#>] ")
  (defun marsam-sql-set-variables ()
    "Set variables on switch to sqli buffer."
    (cl-case sql-product
      (mysql    (setq sql-input-ring-separator "\n"
                      sql-input-ring-file-name (concat (file-remote-p default-directory) "~/.mysql_history")))
      (sqlite   (setq sql-input-ring-separator "\n"
                      sql-input-ring-file-name (concat (file-remote-p default-directory) "~/.sqlite_history")))
      (postgres (setq sql-input-ring-separator "\n"
                      sql-input-ring-file-name (concat (file-remote-p default-directory) "~/.psql_history")))))

  (add-hook 'sql-interactive-mode-hook #'marsam-sql-set-variables)
  (setq sql-connection-alist '(("connect_development" . ((sql-product mysql)
                                                         (sql-user "puercopop")
                                                         (sql-password "")
                                                         (sql-database "connect_development")
                                                         (sql-server "localhost"))))
        sql-mysql-login-params
        '((user :default "puercopop")
          (database :default "connect_development")
          (server :default "localhost"))
        ;; '("puercopop" "" "connect_development" "localhost")
        ))

;; TODO(javier): Remove
;; (defun my/setup-sqlformat ()
;;   ;; the sql-product is set too late
;;   (when (eq 'postgres sql-product)
;;     (setq-local sqlformat-command 'pgformatter)))

;; (require 'sqlformat)
;; (setq sqlformat-command 'pgformatter
;;       sqlformat-args '("-s2" "-g"))
:;; (add-hook 'sql-mode-hook
;;           'sqlformat-on-save-mode)


;;; Other languages

(require 'rust-mode)
(require 'cargo)
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;; TODO(javier): Pull from gnu elpa
;; (use-package prolog-mode
;;   :config (setq prolog-system 'swi
;;                 prolog-electric-if-then-else-flag t)
;;   :mode "\\.pl$")

(use-package ediprolog)

(use-package graphql-mode)

(use-package terraform-mode)



(use-package rainbow-mode
  :config (setq rainbow-x-colors nil)
  :hook ((css-mode . rainbow-mode)))

(require 'multiple-cursors)
(setq mc/cmds-to-run-for-all '(paredit-forward-slurp-sexp))
(global-set-key (kbd "M-RET") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


(use-package macrostep
  :bind ((:map emacs-lisp-mode-map
               ("C-c M-e" . macrostep-expand))
         (:map lisp-interaction-mode-map
               ("C-c M-e" . macrostep-expand))))

(use-package sly
  :load-path "site-lisp/sly"
  :config (setq inferior-lisp-program "/usr/local/bin/sbcl"
                sly-lisp-implementations '((sbcl ("/usr/local/bin/sbcl"))
                                           (ccl ("/home/puercopop/src/ccl/lx86cl64"))
					   (ecl ("/usr/local/bin/ecl"))
                                           (clasp ("/home/puercopop/code/clasp/build/clasp"))))
  :bind ((:map sly-mode-map
               ("C-c C-r" . nil))
         (:map sly-prefix-map
               ("C-c C-r" . nil))))

(use-package sly-macrostep
  :after macrostep)


(setq project-list-file (locate-user-emacs-file (format "%s-projects" my/server-name)))
(use-package project
  :bind (("C-c f" . project-find-file)
         ;; ("C-c s" . project-search)
         ))

(require 'docker)
(setq docker-container-columns
      '((:name "Id" :width 16 :template "{{ json .ID }}" :sort nil :format nil)
        (:name "Names" :width 23 :template "{{ json .Names }}" :sort nil :format nil)
        (:name "Image" :width 15 :template "{{ json .Image }}" :sort nil :format nil)
        (:name "Command" :width 30 :template "{{ json .Command }}" :sort nil :format nil)
        (:name "Created" :width 19 :template "{{ json .CreatedAt }}" :sort nil :format (lambda (x) (format-time-string "%F %T" (date-to-time x))))
        (:name "Status" :width 20 :template "{{ json .Status }}" :sort nil :format nil)
        (:name "Ports" :width 10 :template "{{ json .Ports }}" :sort nil :format nil)))

;; (use-package honcho
;;   :load-path "site-lisp/honcho.el"
;;   :config
;;   (setq honcho-procfile-env-suffix-p nil))

;; (honcho-define-service connect-backend
;;   :cwd "/home/puercopop/rlock/connect-backend/master/"
;;   :command ("foreman" "start"))

;; (honcho-define-service connect-web
;;   :cwd "/home/puercopop/rlock/connect-web/"
;;   :command ("yarn" "start"))

;; '(nnimap "gmail-rlock"
;;          (nnimap-address "imap.gmail.com")
;;          (nnimap-server-port 993)
;;          (nnimap-stream ssl)
;;          (nnir-search-engine imap)
;;          ;; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
;;          ;; press 'E' to expire email
;;          ;; (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
;;          ;; (nnmail-expiry-wait 90)
;;          )

(use-package gnus
  :config (progn
            (setq gnus-select-method '(nnnil "")
                  gnus-secondary-select-methods (list ;; '(nntp "news.gwene.org")
                                                 '(nntp "news.gmane.io")
                                                 '(nntp "nntp.lore.kernel.org"))
                  ;; gnus-secondary-select-methods '((nntp "news.gwene.org")
                  ;;                                 (nnmaildir "remotelock"
                  ;;                                               (directory "~/Maildir/remotelock/")
                  ;;                                               (directory-files nnheader-directory-files-safe)
                  ;;                                               (get-new-mail nil)))
                  gnus-use-cache 'active
                  gnus-agent-directory "/media/data/News/agent/"
                  gnus-save-article-buffer "/media/data/News/"
                  gnus-extra-headers '(To Newsgroups X-GM-LABELS)
                  gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-datee
                                               (not gnus-thread-sort-by-number))
                  gnus-use-adaptive-scoring '(word line)
                  gnus-adaptive-word-length-limit 5
                  gnus-adaptive-word-no-group-words t)))

;; (use-package nntwitter
;;   :after (gnus)
;;   :config (add-to-list 'gnus-secondary-select-methods '(nntwitter "")))

;; This are the rules I want to apply
;; (setq nnmail-split-methods
;;       '(("[Gmail]/All Mail" "^Subject: Ayla")
;;         ("[Gmail]/All Mail" "^Subject: Sentry")))

;; (use-package nnreddit
;;   :custom (nnreddit-python-command "python3")
;;   :config (add-to-list 'gnus-secondary-select-methods '(nnreddit "")))
;;  "python"


;;; Chat et other recreational activities
(when (string= "social" my/server-name)
  (use-package elpher)

  (require 'mastodon)

  (use-package elfeed
    :config
    (setq elfeed-feeds
          '("https://tychoish.com/post/index.xml"
            "http://langnostic.inaimathi.ca/feed"
            "https://lobste.rs/t/email.rss"
            "https://hiperderecho.org/feed/"
            "https://conexiones.hiperderecho.org/feed/podcast"
            "https://librelounge.org/rss-feed.rss"
            "https://scattered-thoughts.net/atom.xml"
            ("https://www.youtube.com/feeds/videos.xml?channel_id=UCHP9CdeguNUI-_nBv_UXBhw" chess youtube))))

  (defun my/rcirc-mode-hook ()
    (flyspell-mode 1)
    (rcirc-omit-mode))

  (defun my/rcirc-set-credentials ()
    (interactive)
    (setq rcirc-authinfo `(("libera" nickserv "PuercoPop" ,(auth-source-pick-first-password :host "irc.libera.chat" :login "PuercoPop")))))

  (use-package rcirc
    :commands (rcirc)
    :config (setq rcirc-debug-flag nil ; (load "rcirc-sasl")
                  rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE")
                  rcirc-log-directory nil

                  ;; rcirc-authinfo `(("freenode" nickserv "PuercoPop" ,(auth-source-pick-first-password :host "irc.freenode.net" :login "PuercoPop")))
                  )
    :hook ((rcirc-mode . my/rcirc-mode-hook))))


(require 'alert)
(setq alert-user-configuration
      '((((:category . "slack")) ignore nil)
        (((:title . "\\(eng\\)")
          (:category . "slack"))
         libnotify nil)
        (((:message . "@javier\\|Javier")
          (:category . "slack"))
         libnotify nil)))

(use-package j-mode
  :load-path "site-lisp/j-mode")

(use-package q-mode
  :load-path "site-lisp/q-mode")

;; (use-package q
;;   :load-path "site-lisp/q.el")
;; (load "/home/puercopop/.emacs.d/site-lisp/q.el/q.el")

;; (use-package transmission)

;; Package hasn't been released yet
;; (use-package systemd
;;   :pin gnu)

(require 'time)
;; TODO: Add Leon and fix the other two
(setq world-clock-list '(("America/Lima" "Lima")
                         ("America/Arkansas" "Fayettevile")
                         ("America/Virginia" "Virginia")
                         ("America/Fortaleza" "Fortaleza")
                         ("Asia/Tokyo" "Tokyo")))

(setq term-prompt-regexp "^\\$ ")
(require 'vterm)
(eval-after-load 'vterm
  (progn
    (define-key vterm-mode-map (kbd "M-p") 'vterm-send-C-p)
    (define-key vterm-mode-map (kbd "M-n") 'vterm-send-C-n)))
(defun project-vterm ()
  (declare (interactive-only shell-command))
  (interactive)
  ;; TODO(javier): Error out if we are not in a project.
  (let ((default-directory (cdr (project-current))))
    (vterm (format "*vterm: %s*" default-directory))))
(define-key project-prefix-map (kbd "v") 'project-vterm)

(use-package detached
  :init (detached-init)
  :bind (([remap async-shell-command] . detached-shell-command)))

(use-package axe)

(require 'kubel)
(kubel-vterm-setup)

;; (require 'dyalog-mode)
;; (use-package dyalog-mode
;;   :load-path "site-lisp/dyalog-mode/")

(defun my/vim-it ()
  (interactive)
  (async-shell-command
   (format "gvim +%d %s"
       (+ (if (bolp) 1 0) (count-lines 1 (point)))
       (shell-quote-argument buffer-file-name))))


;; Fortune Cookies

;; (use-package oblique
;;   :load-path "site-lisp/oblique-strategies")

;; (setq initial-scratch-message (format ";; %s\n"(oblique-strategy)))



;; My config

;; TODO: Have project.el distinguish rails projects and npm projects

(cl-defgeneric my/jump-to-test-toggle (filename)
  "Jump to the related test file of FILENAME. If at the test-file
jump to the related implementation file."
  (:method ()))

(cl-defgeneric my/call-related-test ()
  "Runs the test related to the current file")
