(setq gnus-select-method '(nnimap "gmail"
				  (nnimap-address "imap.gmail.com")
				  (nnimap-server-port 993)
				  (nnimap-stream ssl)))

(setq mail-sources
      '((pop :server "pop.gmail.com"
             :port 995
             :user "Leo@gmail.com"
             :password "wrongpw"
             :stream ssl)))


(provide 'setup-gnus)
