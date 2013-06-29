(setenv "WORKON_HOME" "/Users/PuercoPop/.envs")
(require 'virtualenv)
(require 'pytest)

(autoload 'python-pep8 "python-pep8")
(setq python-pep8-command "/usr/local/share/python/pep8") ; Path to pep8

;; taken from https://github.com/purcell/emacs.d/blob/master/init-python-mode.el
(setq auto-mode-alist
      (append '(("\\.py$" . python-mode))
              auto-mode-alist))

;; Taken from https://github.com/jart/justinemacs/blob/master/lob-python.el
(defadvice python-calculate-indentation (around outdent-closing-brackets)
  "Handle lines beginning with a closing bracket and indent them so that
  they line up with the line containing the corresponding opening bracket."
  (save-excursion
    (beginning-of-line)
    (let ((syntax (syntax-ppss)))
      (if (and (not (eq 'string (syntax-ppss-context syntax)))
               (python-continuation-line-p)
               (cadr syntax)
               (skip-syntax-forward "-")
               (looking-at "\\s)"))
          (progn
            (forward-char 1)
            (ignore-errors (backward-sexp))
            (setq ad-return-value (current-indentation)))
        ad-do-it))))

(add-hook 'python-mode-hook
          '(lambda ()
             (setq fill-column 79)
             (setq python-indent 4)
             (add-hook 'before-save-hook 'delete-trailing-whitespace)
             (define-key python-mode-map (kbd "<f5>") 'flycheck-compile) ;'pep8
             (define-key python-mode-map (kbd "C-c s") 'magit-status)
             (font-lock-add-keywords nil
                                     '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))
             (local-set-key "\C-ca" 'pytest-all)
             (local-set-key "\C-cm" 'pytest-module)
             (local-set-key "\C-c." 'pytest-one)
             (local-set-key "\C-cd" 'pytest-directory)
             (local-set-key "\C-cpa" 'pytest-pdb-all)
             (local-set-key "\C-cpm" 'pytest-pdb-module)
             (local-set-key "\C-cp." 'pytest-pdb-one)))

;; Usage:
;;   (require 'flymake-python-pyflakes)
;;   (add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

;; To use "flake8" instead of "pyflakes", add this line:
;;   (setq flymake-python-pyflakes-executable "flake8")

(add-hook 'python-mode-hook 'flycheck-mode)
(add-to-list 'ido-ignore-buffers "\*Flycheck .*")

(provide 'setup-python-mode)
