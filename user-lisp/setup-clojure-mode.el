;; Rainbow parentesis
(require 'clojure-mode)
(require 'clojure-test-mode)
(require 'cljsbuild-mode)
(require 'elein)
(require 'nrepl)
(require 'slamhound)
(require 'ac-nrepl)


(setq nrepl-popup-stacktraces-in nil
      nrepl-hide-special-buffers t
      nrepl-popup-stacktraces-in-repl t
      nrepl-history-file "~/.emacs.d/nrepl-history")

(after-load 'nrepl
            (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
            (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
            (add-hook 'nrepl-mode-hook 'paredit-mode)
            (add-hook 'nrepl-mode-hook 'subword-mode)
            (add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
            (add-hook 'nrepl-connected-hook 'nrepl-enable-on-existing-clojure-buffers)
            (define-key nrepl-interaction-mode-map (kbd "C-c C-d")
              'ac-nrepl-popup-doc)
)

(after-load  'clojure-mode
             (add-hook 'clojure-mode-hook 'subword-mode)
             (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode))

(add-auto-mode 'clojure-mode "\\.cljs\\'")

; depends also en ac-mode
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))
(put 'erase-buffer 'disabled nil)

(provide 'setup-clojure-mode)
