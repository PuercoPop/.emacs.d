(setq eval-expression-print-length nil
      eval-expression-print-level nil)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'check-parens)
            (lispy-mode 1)
            (define-key lispy-mode-map (kbd "M-o") nil)))

(define-key emacs-lisp-mode-map (kbd "C-c C-t") 'elpakit-test)

(provide 'setup-elisp)
