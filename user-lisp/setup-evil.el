(require 'evil)
(evil-mode 1)

;; Surround
;; (require 'surround)
;; (global-surround-mode 1)
(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)


(provide 'setup-evil)
