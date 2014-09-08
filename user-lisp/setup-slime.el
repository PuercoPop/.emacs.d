(require 'slime-autoloads)

(setq inferior-lisp-program "sbcl"
      slime-export-save-file t
      slime-repl-history-remove-duplicates t
      slime-repl-history-trim-whitespaces t
      slime-load-failed-fasl 'always
      slime-enable-evaluate-in-emacs t
      slime-autodoc-use-multiline-p t
      slime-contribs '(slime-fancy
                       slime-xref-browser
                       slime-sprof))

(global-set-key "\C-z" 'slime-selector)

(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

(provide 'setup-slime)
