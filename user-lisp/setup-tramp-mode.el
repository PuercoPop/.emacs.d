(setq tramp-default "sshx"
      tramp-default-method "ssh")

; taken from http://irreal.org/blog/?p=895
(after-load 'tramp
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '((regexp-quote (system-name)) nil nil)))

(provide 'setup-tramp-mode)
