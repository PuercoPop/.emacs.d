(add-to-list 'auto-mode-alist '("\\.tmpl\\'" . closure-template-html-mode))

(require 'handlebars-sgml-mode)
(handlebars-use-mode 'global)

(provide 'setup-html-templates)
