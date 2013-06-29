(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl"
      slime-export-save-file t
      slime-repl-history-remove-duplicates t
      slime-repl-history-trim-whitespaces t)

;(require 'slime-asdf)

(global-set-key "\C-z" 'slime-selector)


(provide 'setup-slime-ql)
