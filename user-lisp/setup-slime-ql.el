(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl"
      slime-export-save-file t
      slime-repl-history-remove-duplicates t
      slime-repl-history-trim-whitespaces t)

(global-set-key "\C-z" 'slime-selector)
(setq slime-enable-evaluate-in-emacs t)

(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

(provide 'setup-slime-ql)
