(defmacro after-load (feature &rest body)
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,feature
     '(progn ,@body)))

(defmacro after-init (&rest body)
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(add-hook 'after-init-hook '(lambda ()
                                 ,@body)))

(defun add-auto-mode (mode &rest patterns)
    "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
      (dolist (pattern patterns)
            (add-to-list 'auto-mode-alist (cons pattern mode))))

(defun add-auto-modes (pattern &rest modes)
    "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
      (dolist (mode modes)
            (add-to-list 'auto-mode-alist (cons pattern mode))))
