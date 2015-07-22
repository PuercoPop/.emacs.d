(setq visual-line-mode t)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(show-paren-mode 1)
(setq default-directory "~/")
(blink-cursor-mode 0)

(setq echo-keystrokes 0.1)

;; Taken from http://whattheemacsd.com//sane-defaults.el-01.html
;; Auto refresh buffers
(global-auto-revert-mode 1)
;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(global-font-lock-mode t)

(delete-selection-mode 1) ; delete selected block when start typing
(setq-default truncante-lines t)
;; (global-visual-line-mode t)

;; Never insert tabs
(set-default 'indent-tabs-mode nil)
;; Show me empty lines after buffer end
(set-default 'indicate-empty-lines t)

(setq transient-mark-mode t)
(delete-selection-mode t)

;; A saner ediff
(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; UTF-8
(setenv "LANG" "en_US.UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(require 'iso-transl)

;;(fset 'yes-or-no-p 'y-or-n-p)
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Show Line numbers
(require 'linum)
(line-number-mode 1)
;;(global-linum-mode 1)
(column-number-mode 1)  ;; Line numbers on left most column
(setq-default fill-column 79)

(auto-compression-mode t)
(global-auto-revert-mode 1)

;; Disabled shift selecting
(setq shift-select-mode nil)

(setq x-select-enable-clipboard t)

;; BackupStuff
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq auto-save-default nil)

;; (global-set-key (kbd "<escape>") 'god-mode-all)

;; Whitespace config
;; (setq-default indicate-empty-lines t)
;; (global-whitespace-mode 1)
(setq whitespace-style '(face trailing tab empty))

;; css-mode stuff
(setq css-indent-offset 2)

;; Winner mode
;; (when (fboundp 'winner-mode) (winner-mode 1))

;; Icicles
;; (require 'icicles)
;; (icy-mode 1)

;; Setting a custom file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Save point position between sessions
;; taken from: http://whattheemacsd.com/init.el-03.html
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Taken from http://whattheemacsd.com/key-bindings.el-01.html
;; Display the line numbers when using goto-line
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

(global-set-key [remap goto-line] 'goto-line-with-feedback)

;; (color-theme-sanityinc-tomorrow-eighties)
(setq source-directory "~/.apps/emacs-24.3/src/")

(setq visible-bell t)

(setq-default mode-line-format
              '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position (vc-mode vc-mode) "  " mode-name " " mode-line-misc-info mode-line-end-spaces))

;; Use xdg-open always. Work-around for broken  #'browse-url-can-use-xdg-open. Should hard code org.gnome.SessionManager
(setq browse-url-browser-function #'browse-url-xdg-open)

(provide 'misc-settings)
