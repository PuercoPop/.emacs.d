(require 'markdown-mode)

(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

(provide 'setup-markdown-mode)
