(require 'python)

(add-hook 'python-mode-hook
          '(lambda ()
             (setq fill-column 79)
             (add-hook 'before-save-hook 'delete-trailing-whitespace)
             (setq ac-sources '(ac-source-python))
             (define-key python-mode-map (kbd "<f5>") 'pep8)
             (font-lock-add-keywords
              nil
              '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))
             ))

(provide 'setup-python)
