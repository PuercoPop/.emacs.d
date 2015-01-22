(after-load 'magit
  (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace))


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

(provide 'setup-magit)
