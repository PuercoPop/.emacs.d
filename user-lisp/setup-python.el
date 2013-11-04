(require 'virtualenvwrapper)
(setq venv-location "~/.envs/")
(venv-initialize-eshell)
(venv-initialize-interactive-shells)

(setq jedi:setup-keys t
      jedi:complete-on-dot t)

(add-hook 'python-mode-hook
          '(lambda ()
             (setq fill-column 79)
             (add-hook 'before-save-hook 'delete-trailing-whitespace)
             (define-key python-mode-map (kbd "<f5>") 'pep8)
             (font-lock-add-keywords
              nil
              '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))
             (jedi:setup)
             (jedi:ac-setup)))

(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))

(provide 'setup-python)
