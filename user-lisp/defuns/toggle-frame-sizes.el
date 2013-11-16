(setq *frame-sizes*
      '((80 . 60)
        (160 . 60)
        (80 . 30)))

(defun toggle-frame-sizes ()
  "Iterate over an alist of (col . height)."
  (interactive)
  (message "%s" (boundp '*frame-sizes-index*))
  (unless (boundp '*frame-sizes-index*)
    (message "Runs")
    (setq *frame-sizes-index* 0))

  (let ((current-frame (elt *frame-sizes* *frame-sizes-index*)))
    (set-frame-size (selected-frame)
                    (car current-frame)
                    (cdr current-frame)))

  (cl-incf *frame-sizes-index*)
  (when (= *frame-sizes-index*  (length *frame-sizes*))
    (setq *frame-sizes-index* 0)))
(toggle-frame-sizes)

(global-set-key (kbd "<f5>") 'toggle-frame-sizes)
