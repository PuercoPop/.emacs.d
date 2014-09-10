(require 'sly-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(sp-with-modes 'sly-mrepl-mode
    (sp-local-pair "'" nil :actions nil))

(provide 'setup-sly)
