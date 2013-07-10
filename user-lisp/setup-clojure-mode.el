;; Rainbow parentesis
(require 'rainbow-delimiters)
(require 'nrepl)
(require 'ac-nrepl)

(setq nrepl-popup-stacktraces-in nil
      nrepl-hide-special-buffers t
      nrepl-popup-stacktraces-in-repl t
      nrepl-history-file "~/.emacs.d/nrepl-history")

;; Eldoc
(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(add-hook 'nrepl-connected-hook 'nrepl-enable-on-existing-clojure-buffers)

(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'nrepl-mode-hook 'subword-mode)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)

; depends also en ac-mode
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))
(put 'erase-buffer 'disabled nil)

(provide 'setup-clojure-mode)
