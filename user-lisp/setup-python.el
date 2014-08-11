(require 'virtualenvwrapper)
(setq venv-location "~/.envs/"
      python-shell-interpreter "ipython"
      python-shell-prompt-regexp "In \\[[0-9]+\\]: "
      python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: ")

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

(defun ipython-notebook ()
  "TODO: http://tkf.github.io/emacs-ipython-notebook/#using-package-el-melpa
        and https://github.com/jhamrick/emacs/blob/master/.emacs.d/settings/python-settings.el"
  (interactive)
  )

(provide 'setup-python)
