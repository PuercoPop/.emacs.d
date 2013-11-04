(require 'popwin)
(popwin-mode 1)

(add-to-list 'popwin:special-display-config "*python-pep8*")
(push '("*Agenda Commands*" :height 30) popwin:special-display-config)


(provide 'setup-popwin)
