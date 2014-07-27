(after-load 'dired
  (toggle-diredp-find-file-reuse-dir 1))

(add-hook 'dired-mode-hook (lambda ()
                             (local-set-key (kbd "M-o") 'other-window)
                             (local-set-key (kbd "C-x o") 'dired-omit-mode)))

;; dired-toggle

(global-set-key (kbd "<f5>") 'dired-toggle)

(provide 'setup-dired+)
