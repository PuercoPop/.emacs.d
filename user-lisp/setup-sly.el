(require 'sly-autoloads)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq sly-lisp-implementations
      '((sbcl ("/usr/local/bin/sbcl"))
        (sbcl-vanilla ("/opt/local/bin/sbcl"))
        (mezzano ("/opt/local/bin/sbcl-mezzano"))
        (sbcl-walk-forms ("/opt/local/bin/sbcl-wip-walk-forms"))
        (ccl ("/home/puercopop/.apps/ccl/lx86cl64"))
        (ecl ("/home/puercopop/.apps/ecl-13.5.1/build/bin/ecl"))
        (abcl ("/home/puercopop/Projects/abcl/abcl/abcl"))))

(sp-with-modes 'sly-mrepl-mode
    (sp-local-pair "'" nil :actions nil))

;; (add-hook 'sly-mrepl-mode-hook 'sly-mrepl--ensure-no-font-lock) ;; FIX for font-lock issue where I can't type

(setq Info-default-directory-list
      (cons "/home/puercopop/.emacs.d/site-lisp/sly/doc/"
            Info-default-directory-list))

(push 'sly-repl-ansi-color sly-contribs)
(push 'sly-indentation sly-contribs)
;; (setq sly-contribs (delete 'sly-retro sly-contribs))

(eval-after-load 'sly
  '(progn (define-key lisp-mode-map
            (kbd "M-i")  'sly-inspect-definition)
          (define-key sly-doc-map (kbd "C-d") 'sly-documentation)))

(require 'sly-company)

(add-hook 'sly-mode-hook 'sly-company-mode)

(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "M-.") 'company-show-location)

(provide 'setup-sly)
