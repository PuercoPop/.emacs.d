; Growl notify
; improved from http://edward.oconnor.cx/elisp/growl.el

(defgroup growl-notify nil
  ""
  :group 'notifications
  :prefix "growl-notify-")

(unless (executable-find "growlnotify")
  (error "growl-notify function requires the growlnotify executable"))

(defsubst growl-notify-ensure-quoted-string (arg)
  (shell-quote-argument
   (cond ((null arg) "")
         ((stringp arg) arg)
         (t (format "%s" arg)))))

(defun growl-notify-notification (subject message &optional sticky)
  "Use growl for notifications"
  (shell-command
   (concat "growlnotify -a Emacs -n Emacs"
           (if sticky " -s" "")
           " " (growl-notify-ensure-quoted-string subject)
           (if message
               (concat " -m" (growl-notify-ensure-quoted-string message))
             ""))
   (get-buffer-create  "*growl output*"))
  message)

(provide 'growl-notify)
