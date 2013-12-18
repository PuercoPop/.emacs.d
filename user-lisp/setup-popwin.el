(require 'popwin)
(popwin-mode 1)

(setq popwin:special-display-config
      (cl-remove 'slime-repl-mode popwin:special-display-config))
(add-to-list 'popwin:special-display-config "*python-pep8*")
(push '("*Agenda Commands*" :height 30) popwin:special-display-config)


(provide 'setup-popwin)
