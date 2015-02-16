
;; (global-set-key (kbd "C-x r t") 'inline-string-rectangle)

(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this-dwim)
;; (require 'key-chord)
;; (key-chord-define-global "mn" 'mark-previous-like-this)
;; (key-chord-define-global "m," 'mark-previous-like-this)
;; (key-chord-define-global "nm," 'mark-more-like-this)


(add-hook 'sgml-mode-hook
          (lambda ()
            (require 'rename-sgml-tag)
            (define-key sgml-mode-map (kbd "C-c C-r") 'mc/mark-sgml-tag-pair)))

(provide 'setup-multiple-cursors)
