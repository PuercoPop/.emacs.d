;; Slightly more useful C-a and C-e

(defun move-end-of-line-or-next-line ()
  (interactive)
  (if (and (eolp)
           (eq last-command 'move-end-of-line-or-next-line))
      (move-end-of-line 2)
    (move-end-of-line nil)))

(defun move-start-of-line-or-prev-line ()
  (interactive)
  (if (and (bolp)
           (eq last-command 'move-start-of-line-or-prev-line))
      (move-beginning-of-line 0)
    (move-beginning-of-line nil)))


;; From magmars
(defun cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (cleanup-buffer-safe)
  (indent-buffer))

(defun zap-whitespace-forward ()
  "Delete whitespace beginning at point"
  (interactive)
  (delete-region (point)
                 (progn (re-search-forward "[\t ]*") (point))))

(defun jao-toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 1))))

;; Thanks to tali713
(defun backward-kill-word-or-kill-region ()
  "When no region is active call backward-kill-word, otherwise kill-region. To
 make it behave like the shell "
  (interactive)
  (call-interactively
   (if (region-active-p)
       'kill-region
     'sp-backward-kill-word)))

(global-set-key (kbd "C-w") 'backward-kill-word-or-kill-region)

;; Taken from http://whattheemacsd.com/editing-defuns.el-01.html
(defun open-line-below ()
  (interactive)
  (if (eolp)
      (newline)
    (end-of-line)
    (newline))
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)


;; Taken from http://whattheemacsd.com/file-defuns.el-01.html
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

;; Taken from http://whattheemacsd.com/editing-defuns.el-02.html
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (forward-line -1)
    (forward-line -1)
    (move-to-column col)))

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; Taken from
(defun transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(global-set-key (kbd "C-x t") 'transpose-windows)

;; Taken from Emacs Redux:
;; http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))
(global-set-key (kbd "C-c D")  'delete-file-and-buffer)

;; My First Emacs Command
(defun mark-whole-line ()
  "Marks line"
  (interactive)
  (back-to-indentation)
  (call-interactively 'set-mark-command)
  (call-interactively 'move-end-of-line))
(global-set-key (kbd "C-l") 'mark-whole-line)

(defun move-start-of-indentation-or-prev-line ()
  (interactive)
  (let ((prev-point (point)))
    (back-to-indentation)
    (when (= prev-point (point))
      (move-beginning-of-line 0)
      (back-to-indentation))))

(defun kill-filename ()
  "Save in the KILL-RING the filename of the current buffer."
  (interactive)
  (if-let ((filename (buffer-file-name (current-buffer))))
      (with-temp-buffer
        (insert filename)
        (kill-ring-save (point-min) (point-max)))
      (message "Buffer %s has no associated file" (current-buffer))))

(provide 'user-defuns)
