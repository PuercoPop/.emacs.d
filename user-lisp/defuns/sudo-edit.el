(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (unless buffer-file-name
    (error "Buffer does not have a file associated to it."))
  (if arg
      (find-file (concat "/sudo::"
                                   (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo::" buffer-file-name))))

(global-set-key (kbd "C-x C-v") 'sudo-edit)
