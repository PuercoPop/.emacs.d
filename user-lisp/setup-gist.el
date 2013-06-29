(require 'gist)

(setq gist-use-curl t)

(global-set-key (kbd "M-g a") 'gist-list)
(global-unset-key (kbd "M-g n"))
(global-set-key (kbd "M-g n") 'gist-region-or-buffer)
(global-unset-key (kbd "M-g p"))
(global-set-key (kbd "M-g p") 'gist-region-or-buffer-private)

(provide 'setup-gist)
