(defun irc-puercopop ()
  "Connect to irc-proxy @kraken"
  (interactive)
  (unless (memq 'secrets features)
    (require 'secrets))
  (rcirc-connect
   "irc.puercopop.com"
   1099
   "PuercoPop"
   "PuercoPop@irc.freenode.net"
   "PuercoPop"
   '("#emacs" "#lisp" "#lisp" "#python.pe")
   rcirc-bouncer-password))
