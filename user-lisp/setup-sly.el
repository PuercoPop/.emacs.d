(require 'sly-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq inferior-lisp-program "/home/puercopop/.apps/ccl/lx86cl64")
;; (setq inferior-lisp-program "/home/puercopop/Projects/abcl/abcl/abcl")

(sp-with-modes 'sly-mrepl-mode
    (sp-local-pair "'" nil :actions nil))

;; (add-hook 'sly-mrepl-mode-hook 'sly-mrepl--ensure-no-font-lock) ;; FIX for font-lock issue where I can't type

(setq Info-default-directory-list
      (cons "/home/puercopop/.emacs.d/site-lisp/sly/doc/"
            Info-default-directory-list))

(push 'sly-repl-ansi-color sly-contribs)
;; (setq sly-contribs (delete 'sly-retro sly-contribs))

(eval-after-load 'sly
  '(define-key lisp-mode-map
     (kbd "M-i")  'sly-inspect-definition))

(provide 'setup-sly)
