(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-local-domain "gmail.com"
      smtpmail-sendto-domain "gmail.com"
      smtpmail-smtp-service 465
      smtpmail-debug-info t
      send-mail-function 'smtpmail-send-it)
(load-library "smtpmail")

    (setq smtpmail-local-domain "YOUR DOMAIN NAME")
    (setq smtpmail-sendto-domain "YOUR DOMAIN NAME")

(provide 'setup-smtp)
