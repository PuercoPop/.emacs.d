(setq mail-default-headers
      "From: pirata@gmail.com\nReply-to: pirata@gmail.com")

(setq user-mail-address "pirata@gmail.com"
      user-full-name "Javier"
      mail-host-address "gmail.com")


(require 'smtpmail)
(setq smtpmail-stream-type 'ssl
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

(provide 'setup-mail)
