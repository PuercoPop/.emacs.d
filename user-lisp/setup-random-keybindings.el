;; Spitout random keybindings every 3 minuts
(use-package keywiz)
(defun sacha/load-keybindings ()
  "Since we don't want to have to pass through a keywiz game each time..."
  (setq keywiz-cached-commands nil)
  (do-all-symbols (sym)
    (when (and (commandp sym)
               (not (memq sym '(self-insert-command
                                digit-argument undefined))))
      (let ((keys (apply 'nconc (mapcar
                                 (lambda (key)
                                   (when (keywiz-key-press-event-p key)
                                     (list key)))
                                 (where-is-internal sym)))))
        ;;  Politically incorrect, but clearer version of the above:
        ;;    (let ((keys (delete-if-not 'keywiz-key-press-event-p
        ;;                               (where-is-internal sym))))
        (and keys
             (push (list sym keys) keywiz-cached-commands))))))
  (sacha/load-keybindings)
  ;; Might be good to use this in org-agenda...
(defun sacha/random-keybinding ()
  "Describe a random keybinding."
  (let* ((command (keywiz-random keywiz-cached-commands))
         (doc (and command (documentation (car command)))))
    (if command
        (concat (symbol-name (car command)) " "
                "(" (mapconcat 'key-description (cadr command) ", ") ")"
                (if doc
                    (concat ": " (substring doc 0 (string-match "\n" doc)))
                  ""))
      "")))
(run-at-time (current-time) 300
 (message "%s" (sacha/random-keybinding)))


(provide 'setup-random-keybindings)
