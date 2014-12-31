;; Replacing buffer with iBuffer
(defalias 'list-buffers 'ibuffer)

(after-load 'ibuffer
  (define-key ibuffer-mode-map (kbd "C-x C-f") nil) ;; Don't know why local-unset-key doesn't work
  (setq ibuffer-expert t
        ibuffer-show-empty-filter-groups nil)
  (require 'ibuffer))

;; Taken from:
;;http://emacs-fu.blogspot.com/2010/02/dealing-with-many-buffers-ibuffer.html
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Org" ;; all org-related buffers
                (mode . org-mode))
               ("Mail"
                (or (mode . message-mode)
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
               ("Dired" (mode .  dired-mode))
               ("Special Buffers"
                (or
                 (mode . magit-status-mode)
                 (mode . ediff-mode)))
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

;; From http://irreal.org/blog/?p=3544
(defun ibuffer-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (next-line 3))

(defun ibuffer-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (next-line -2))

(eval-after-load 'ibuffer
  '(progn
     (define-key ibuffer-mode-map
       (vector 'remap 'end-of-buffer) 'ibuffer-jump-to-bottom)
     (define-key ibuffer-mode-map
       (vector 'remap 'beginning-of-buffer) 'ibuffer-back-to-top)))

(provide 'setup-ibuffer-mode)
