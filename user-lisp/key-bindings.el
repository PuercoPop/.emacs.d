(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "C-e") 'move-end-of-line-or-next-line)
(global-set-key (kbd "C-a") 'move-start-of-line-or-prev-line)
;; (global-set-key (kbd "C-a") 'move-start-of-indentation-or-prev-line)
;; (global-set-key (kbd "M-m") 'move-start-of-line-or-prev-line)

(global-unset-key (kbd "C-z"))

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(global-set-key (kbd "C-M-w") 'kill-whole-line)


(provide 'key-bindings)
