(require 'cljsbuild-mode)
(require 'slamhound)


(setq cider-popup-stacktraces-in nil
      nrepl-hide-special-buffers t
      cider-popup-stacktraces-in-repl t
      cider-history-file "~/.emacs.d/cider-history")

(after-load 'cider
  (add-hook 'cider-mode-hook 'ac-nrepl-setup)
  (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
  (add-hook 'cider-mode-hook 'paredit-mode)
  (add-hook 'cider-mode-hook 'subword-mode)
  (add-hook 'cider-mode-hook 'nrepl-turn-on-eldoc-mode)
  (add-hook 'cider-connected-hook 'nrepl-enable-on-existing-clojure-buffers)
  (define-key cider-repl-mode-map (kbd "C-c C-d")
    'ac-nrepl-popup-doc))

(after-load  'clojure-mode
  (add-hook 'clojure-mode-hook 'subword-mode)
  (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode))

(add-auto-mode 'clojure-mode "\\.cljs\\'")

;; depends also en ac-mode
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-mode))
(put 'erase-buffer 'disabled nil)

(provide 'setup-clojure-mode)
