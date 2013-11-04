(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (paredit-mode +1)
            (add-hook 'after-save-hook 'check-parens nil t)
            (define-key paredit-mode-map (kbd "C-j") 'eval-print-last-sexp)))
(add-hook 'lisp-mode-hook             (lambda ()
                                        (paredit-mode +1)))

(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))

(add-hook 'scheme-mode-hook (lambda () (paredit-mode +1)))

(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'clojure-mode-hook (lambda () (paredit-mode +1)))

(require 'eldoc) ; if not already loaded
(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)

(provide 'setup-paredit)
