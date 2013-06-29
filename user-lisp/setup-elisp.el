(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'check-parens)))

(provide 'setup-elisp)
