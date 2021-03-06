;; -*- lexical-binding: t -*-
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

(defun sly-list-asdf-systems ()
  (sly-eval `(cl:append (ql:list-local-systems)
                        (cl:mapcar 'ql-dist:name (ql:system-list)))))

(defun sly-load-asdf-system ()
  (interactive)
  (let* ((system-name (sly-completing-read "System name: "
                                           (sly-list-asdf-systems))))
    (sly-message "Loading %s system." system-name)
    (sly-eval-async `(ql:quickload ,system-name)
      (lambda (result)
        (declare (ignore result))
        (sly-message "System %s loaded." system-name)))))

(defun sly-test-asdf-system ()
  (interactive)
  (let* ((system-name (sly-completing-read "System name: "
                                           (sly-list-asdf-systems))))
    (sly-message "Loading %s system." system-name)
    (sly-eval-async `(asdf:test-system ,system-name))))

(setq sly-mrepl-shortcut-alist
      (acons "test system" 'sly-test-asdf-system
             sly-mrepl-shortcut-alist)
      sly-mrepl-shortcut-alist
      (acons "load system" 'sly-load-asdf-system
             sly-mrepl-shortcut-alist))

(provide 'setup-sly)
