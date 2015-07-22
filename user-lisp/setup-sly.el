(require 'sly-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq inferior-lisp-program "/home/puercopop/.apps/ccl/lx86cl64")

(sp-with-modes 'sly-mrepl-mode
    (sp-local-pair "'" nil :actions nil))

(add-hook 'sly-mrepl-mode-hook 'sly-mrepl--ensure-no-font-lock) ;; FIX for font-lock issue where I can't type
(eval-after-load 'sly
  '(define-key lisp-mode-map
     (kbd "M-i")  'sly-inspect-definition))

(provide 'setup-sly)
