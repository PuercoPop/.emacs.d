(require 'paredit)

(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (define-key paredit-mode-map (kbd "C-j") 'eval-print-last-sexp)))
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'sly-mrepl-mode-hook #'enable-paredit-mode)

(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)

(provide 'setup-paredit)
