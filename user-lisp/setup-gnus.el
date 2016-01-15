(setq gnus-select-method '(nntp "news.gmane.org"))

(add-to-list 'gnus-select-method
             '(nnimap
               "gmail"
               (nnimap-address "imap.gmail.com")
               (nnimap-server-port 993)
               (nnimap-stream ssl)))

(setq gnus-posting-styles
      '((".*"
         ("CC" "pirata@gmail.com")
         (address "pirata@gmail.com"))))

(provide 'setup-gnus)
