(after-load 'magit
  (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)
  (magit-add-section-hook 'magit-status-sections-hook
                        'magit-insert-branch-description
                        nil t)
  (add-to-list 'git-commit-style-convention-checks
               'overlong-summary-line))

(setq magit-auto-revert-mode nil
      magit-last-seen-setup-instructions "1.4.0"
      magit-push-always-verify nil
      git-commit-fill-column 72)

(global-set-key (kbd "C-c s") 'magit-status)


;; Taken from http://whattheemacsd.com//setup-magit.el-02.html
(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(require 'git-pr)

;; (eval-after-load 'magit
;;   '(add-hook 'magit-mode-hook #'git-pr-add-refs))

(provide 'setup-magit)
