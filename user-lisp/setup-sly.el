(require 'sly-autoloads)

(setq sly-lisp-implementations
      '((ccl ("/home/puercopop/.apps/ccl/lx86cl64"))
        (sbcl ("/usr/local/bin/sbcl"))
        (sbcl-vanilla ("/opt/local/bin/sbcl"))
        (mezzano ("/opt/local/bin/sbcl-mezzano"))
        (sbcl-walk-forms ("/opt/local/sbcl-codewalker/bin/sbcl"))
        (sbcl-walk-forms-v2 ("/opt/local/sbcl-codewalker-v2/bin/sbcl"))
        (ecl ("/usr/local/bin/ecl"))
        (abcl ("/home/puercopop/Projects/abcl/abcl/abcl"))
        (abcl-git ("/home/puercopop/Projects/abcl-git/abcl"))
        (clisp ("/usr/bin/clisp"))
        (cmucl ("/home/puercopop/.apps/cmucl/bin/lisp")))
      sly-default-lisp 'sbcl)

;; (sp-with-modes 'sly-mrepl-mode
;;     (sp-local-pair "'" nil :actions nil))

(add-to-list 'Info-default-directory-list
             "/home/puercopop/.emacs.d/site-lisp/sly/doc/")

(add-to-list 'sly-contribs 'sly-macrostep 'append)
(add-to-list 'sly-contribs 'sly-repl-ansi-color 'append)
(add-to-list 'sly-contribs 'sly-repl-ansi-color 'append)

(eval-after-load 'sly
  '(progn (define-key lisp-mode-map
            (kbd "M-i")  'sly-inspect-definition)
          (define-key sly-doc-map
            (kbd "C-d") 'sly-documentation)
          (define-key sly--completion-transient-mode-map
            (kbd "C-s") 'sly-next-completion)
          (define-key sly--completion-transient-mode-map
            (kbd "C-r") 'sly-prev-completion)))

;; (require 'sly-company)

;; (add-hook 'sly-mode-hook 'sly-company-mode)

;; (define-key company-active-map (kbd "\C-n") 'company-select-next)
;; (define-key company-active-map (kbd "\C-p") 'company-select-previous)
;; (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
;; (define-key company-active-map (kbd "M-.") 'company-show-location)

;; (require 'sly-macrostep-autoloads)

(provide 'setup-sly)
