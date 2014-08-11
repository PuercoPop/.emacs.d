(require 'erc)
;; SSL stuff
(require 'tls)
(require 'secrets)
;; (require 'erc-nick-colors)
(setq erc-server-coding-system '(utf-8 . utf-8))

;; ZNC Bouncer
(defun irc-puercopop ()
  "Connect to irc-proxy @kraken"
  (interactive)
  (unless (memq 'secrets features)
    (require 'secrets))
  (erc-tls :server "irc.puercopop.com"
           :port 1099
           :nick "PuercoPop"
           :password (format "%s:%s"
                             rcirc-bouncer-username
                             znc-password)))
(setq znc-servers
      `(("irc.puercopop.com"
         1099
         t
         ((puercoIRC ,rcirc-bouncer-username ,rcirc-bouncer-password)))))

(require 'erc-services)
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-nickserv-passwords
      `((freenode ((,freenode-nickserv-nick . ,freenode-nickserv-password)))))

;; (require 'growl-notify) ; Growl notification
;; (defun erc-growl-notify-hook (match-type nick message)
;;   "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
;;   (unless (posix-string-match "^\\** *Users on #" message)
;;     (growl-notify-notification (buffer-name (current-buffer)) message)))

;; (add-hook 'erc-text-matched-hook 'erc-growl-notify-hook)

(setq erc-current-nick-highlight-type "all")

;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)

(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#limajs" "#lisp" )))

;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))
;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

;; Logging
;; (pushnew 'log erc-modules)
;; (erc-update-modules)
;; (setq erc-log-channels t
;;       erc-log-channels-directory "~/Documents/logs/irc"
;;       erc-log-write-after-send t
;;       erc-log-write-after-insert t)


(provide 'setup-erc)
