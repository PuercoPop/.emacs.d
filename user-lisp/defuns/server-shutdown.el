;; from http://www.emacswiki.org/emacs/EmacsAsDaemon#toc9
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))
