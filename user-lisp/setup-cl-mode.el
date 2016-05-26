;; Do something like this
;; http://cons.pulp.se/post/468541538/tdd-and-slime

;; From http://bc.tech.coop/blog/070515.html
(defun lispdoc ()
  "Searches lispdoc.com for SYMBOL, which is by default the symbol currently under the cursor"
  (interactive)
  (let* ((word-at-point (word-at-point))
         (symbol-at-point (symbol-at-point))
         (default (symbol-name symbol-at-point))
         (inp (read-from-minibuffer
               (if (or word-at-point symbol-at-point)
                   (concat "Symbol (default " default "): ")
                 "Symbol (no default): "))))
    (if (and (string= inp "") (not word-at-point) (not
                                                   symbol-at-point))
        (message "you didn't enter a symbol!")
      (let ((search-type (read-from-minibuffer
                          "full-text (f) or basic (b) search (default b)? ")))
        (browse-url (concat "http://lispdoc.com?q="
                            (if (string= inp "")
                                default
                              inp)
                            "&search="
                            (if (string-equal search-type "f")
                                "full+text+search"
                              "basic+search")))))))

(define-key lisp-mode-map (kbd "C-c l") 'lispdoc)
;; (eval-after-load 'lisp-mode
;;   '(progn
;;      (diminish 'redshank)
;;      (diminish 'autodoc)))
(define-key lisp-mode-map (kbd "C-x C-t") 'sp-transpose-sexp)

(defconst cl-fontify-defforms-alist
  '((format . 2)
    (formatter . 1)
    (error . 1)
    (signal . 1)
    (warn . 1)
    (cerror . 1)
    (assert . 3)
    (invalid-method-error . 2)
    (method-combination-error . 2)
    (break . 1)
    (with-simple-restart . 2)
    (y-or-n-p . 1)))

(require 'cl-format)

(defun fontify-control-strings ()
  (set
   (make-local-variable 'cl-format-fontify-defforms-alist)
   (append cl-format-fontify-defforms-alist
                 cl-fontify-defforms-alist))
  (cl-format-font-lock-mode 1))

(add-hook 'lisp-mode-hook 'fontify-control-strings)
(add-hook 'lisp-mode-hook 'turn-on-eldoc-mode)

(make-variable-buffer-local 'tab-always-indent)
(add-hook 'lisp-mode-hook
          #'(lambda ()
              (setq tab-always-indent 'complete)))

;; (add-hook 'lisp-mode-hook 'lispy-mode)
(add-to-list 'auto-mode-alist '("\\.paren\\'" . lisp-mode))


(provide 'setup-cl-mode)
