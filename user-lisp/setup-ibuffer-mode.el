;; Replacing buffer with iBuffer
(defalias 'list-buffers 'ibuffer)
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)

;; Taken from: http://emacs-fu.blogspot.com/2010/02/dealing-with-many-buffers-ibuffer.html
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Org" ;; all org-related buffers
                (mode . org-mode))
               ("Mail"
                (or  ;; mail-related buffers
                 (mode . message-mode)
                 (mode . mail-mode)))
               ("Twitter"
                (mode . twittering-mode))
               ("Emacs init.el & src"
                (or
                 (filename . "/Users/PuercoPop/.emacs.d")
                 (filename . "/Users/PuercoPop/.apps/emacs-24.3")))
               ("Emacs Lisp"   (mode . emacs-lisp-mode))
               ("ERC"   (mode . erc-mode))
               ("rcirc"   (mode . rcirc-mode))
               ("twitter"   (mode . twittering-mode))
               ))))


(setq ppop-ignore-directories '("." ".." ".DS_Store" "lisp"))
(defun ppop-folder-in-ibuffer-save-group (folder)
  (lexical-let ((match nil))
    (dolist (group (cdr (car ibuffer-saved-filter-groups)))
      (when (equal folder (car group)) (setq match t)))
    match))

(dolist (dir (directory-files "~/Projects/"))
  (if (not (member dir ppop-ignore-directories))
      (setf (car ibuffer-saved-filter-groups)
            (append (car ibuffer-saved-filter-groups)
                    `((,dir
                       (filename . ,(expand-file-name dir "~/Projects/"))))))
    (message "Excluded Dir")))

(dolist (dir (directory-files "~/quicklisp/local-projects/"))
  (if (not (member dir ppop-ignore-directories))
      (setf (car ibuffer-saved-filter-groups)
            (append (car ibuffer-saved-filter-groups)
                    `((,dir
                       (filename . ,(expand-file-name dir "~/quicklisp/local-projects/"))))))
    (message "Excluded Dir")))

(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-switch-to-saved-filter-groups "default")
             (ibuffer-auto-mode 1)))

(provide 'setup-ibuffer-mode)
