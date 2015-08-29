(defun irc-puercopop ()
  "Connect to irc-proxy @kraken"
  (interactive)
  (unless (memq 'secrets features)
    (require 'secrets))
  (rcirc-connect "irc.puercopop.com"
                 1099
                 "PuercoPop"
                 "PuercoPop"
                 "PuercoPop"
                 '("#lisp" "#limajs")
                 znc-password
                 'ssl))


(setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY" "MODE")
      rcirc-log-directory nil
      rcirc-ignore-list (list "rritoch"))


;;;; Auto reconnect
;;;; Taken from http://www.emacswiki.org/emacs/rcircReconnect
(after-load 'rcirc
  (defun-rcirc-command reconnect (arg)
    "Reconnect the server process."
    (interactive "i")
    (if (buffer-live-p rcirc-server-buffer)
        (with-current-buffer rcirc-server-buffer
          (let ((reconnect-buffer (current-buffer))
                (server (or rcirc-server rcirc-default-server))
                (port (if (boundp 'rcirc-port) rcirc-port rcirc-default-port))
                (nick (or rcirc-nick rcirc-default-nick))
                channels)
            (dolist (buf (buffer-list))
              (with-current-buffer buf
                (when (equal reconnect-buffer rcirc-server-buffer)
                  (remove-hook 'change-major-mode-hook
                               'rcirc-change-major-mode-hook)
                  (let ((server-plist (cdr (assoc-string server rcirc-server-alist))))
                    (when server-plist
                      (setq channels (plist-get server-plist :channels))))
                  )))
            (if process (delete-process process))
            (rcirc-connect server port nick
                           nil
                           nil
                           channels))))))

;;; Attempt reconnection at increasing intervals when a connection is
;;; lost.

(defvar rcirc-reconnect-attempts 0)

;;;###autoload
(define-minor-mode rcirc-reconnect-mode
  nil
  nil
  " Auto-Reconnect"
  nil
  (if rcirc-reconnect-mode
      (progn
        (make-local-variable 'rcirc-reconnect-attempts)
        (add-hook 'rcirc-sentinel-hooks
                  'rcirc-reconnect-schedule nil t))
    (remove-hook 'rcirc-sentinel-hooks
                 'rcirc-reconnect-schedule t)))

(defun rcirc-reconnect-schedule (process &optional sentinel seconds)
  (condition-case err
      (when (and (eq 'closed (process-status process))
                 (buffer-live-p (process-buffer process)))
        (with-rcirc-process-buffer process
          (unless seconds
            (setq seconds (exp (1+ rcirc-reconnect-attempts))))
          (rcirc-print
           process "my-rcirc.el" "ERROR" rcirc-target
           (format "scheduling reconnection attempt in %s second(s)." seconds) t)
          (run-with-timer
           seconds
           nil
           'rcirc-reconnect-perform-reconnect
           process)))
    (error
     (rcirc-print process "RCIRC" "ERROR" nil
                  (format "%S" err) t))))

(defun rcirc-reconnect-perform-reconnect (process)
  (when (and (eq 'closed (process-status process))
             (buffer-live-p (process-buffer process))
             )
    (with-rcirc-process-buffer process
      (when rcirc-reconnect-mode
        (if (get-buffer-process (process-buffer process))
            ;; user reconnected manually
            (setq rcirc-reconnect-attempts 0)
          (let ((msg (format "attempting reconnect to %s..."
                             (process-name process)
                             )))
            (rcirc-print process "my-rcirc.el" "ERROR" rcirc-target
                         msg t))
          ;; remove the prompt from buffers
          (condition-case err
              (progn
                (save-window-excursion
                  (save-excursion
                    (rcirc-cmd-reconnect nil)))
                (setq rcirc-reconnect-attempts 0))
            ((quit error)
             (incf rcirc-reconnect-attempts)
             (rcirc-print process "my-rcirc.el" "ERROR" rcirc-target
                          (format "reconnection attempt failed: %s" err)  t)
             (rcirc-reconnect-schedule process))))))))

(add-hook 'rcirc-mode-hook (lambda ()
                             (flyspell-mode 1)
                             (rcirc-omit-mode)
                             (rcirc-track-minor-mode 1)
                             (set (make-local-variable 'scroll-conservatively)
                                  8192)
                             (rcirc-reconnect-mode 1)))

(defun rcirc-growl-notify (process sender response target text)
  (let ((nick (rcirc-nick process)))
    (when (and (string-match (regexp-quote nick) text)
               (not (string= nick sender))
               (not (string= (rcirc-server-name process) sender)))
      (growl-notify-notification sender text))))
;; (add-hook 'rcirc-print-functions 'rcirc-growl-notify
(require 'rcirc-notify)


(provide 'setup-rcirc)
