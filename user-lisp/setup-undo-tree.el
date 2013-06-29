(setq undo-tree-mode-lighter "")
(require 'undo-tree)
(global-undo-tree-mode)
;quiero que global-undo sea con C-c i
; y C-c u sea normal
(provide 'setup-undo-tree)
