(require 'rvm)
(rvm-use-default)

(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)))

(define-key ruby-mode-map "\M-\C-x" 'ruby-send-definition)
(define-key ruby-mode-map "\C-c\C-b" 'ruby-send-block)
(define-key ruby-mode-map "\C-c\M-b" 'ruby-send-block-and-go)
(define-key ruby-mode-map "\C-c\C-x" 'ruby-send-definition)
(define-key ruby-mode-map "\C-c\M-x" 'ruby-send-definition-and-go)
(define-key ruby-mode-map "\C-c\C-r" 'ruby-send-region)
(define-key ruby-mode-map "\C-c\M-r" 'ruby-send-region-and-go)
(define-key ruby-mode-map "\C-c\C-z" 'switch-to-ruby)
(define-key ruby-mode-map "\C-c\C-l" 'ruby-load-file)
(define-key ruby-mode-map "\C-c\C-s" 'run-ruby)

(provide 'setup-ruby-mode)
