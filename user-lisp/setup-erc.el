(require 'erc)
;; SSL stuff
(require 'tls)
(require 'secrets)
;(require 'erc-nick-colors)
(setq erc-server-coding-system '(utf-8 . utf-8))

;;; Servers
;; Bitlbee
;; (erc :server "127.0.0.1" :port 6667 :nick "PuercoPop")
;; Freenode
(erc-tls :server "irc.freenode.net"
         :port 7000
         :nick "PuercoPop"
         :full-name "PuercoPop")
;; ZNC Bouncer
;; (erc :server "irc.puercopop.com"
;;      :port 1099
;;      :nick "PuercoPop"
;;      :password rcirc-bouncer-password)

;; (erc-tls :server "irc.oftc.net"
;;          :port 6697
;;          :nick "PuercoPop"
;;          :full-name "PuercoPop")


(require 'erc-services)
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-nickserv-passwords
      `((freenode ((,freenode-nickserv-nick . ,freenode-nickserv-password)))))

;; Bitlbee identify
;; (add-hook 'erc-join-hook 'bitlbee-identify)
;; (defun bitlbee-identify ()
;;   "If we're on the bitlbee server, send the identify command to the
;; &bitlbee channel."
;;   (when (and (string= "localhost" erc-session-server)
;;              (string= "&bitlbee" (buffer-name)))
;;     (erc-message "PRIVMSG" (format "%s identify %s"
;;                                    (erc-default-target)
;;                                    bitlbee-password))))

(require 'growl-notify) ; Growl notification
(defun erc-growl-notify-hook (match-type nick message)
  "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
  (unless (posix-string-match "^\\** *Users on #" message)
    (growl-notify-notification (buffer-name (current-buffer)) message)))

(add-hook 'erc-text-matched-hook 'erc-growl-notify-hook)

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

; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))
;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

; Logging
(pushnew 'log erc-modules)
(erc-update-modules)
(setq erc-log-channels t
      erc-log-channels-directory "~/Documents/logs/irc"
      erc-log-write-after-send t
      erc-log-write-after-insert t)


(provide 'setup-erc)
