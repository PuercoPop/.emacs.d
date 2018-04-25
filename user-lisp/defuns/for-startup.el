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
