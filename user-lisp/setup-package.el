(require 'package)

;; Add marmalade to package repos
;; default value for package-archives
;; (("gnu" . "http://elpa.gnu.org/packages/"))
(let
    ((marmalade '("marmalade" . "http://marmalade-repo.org/packages/"))
     (melpa '("melpa" . "http://melpa.org/packages/"))
     (org '("org" . "http://orgmode.org/elpa/"))
     (emacs-pe '("emacs-pe" . "https://emacs-pe.github.io/packages/")))
  (add-to-list 'package-archives marmalade t)
  (add-to-list 'package-archives melpa t)
  (add-to-list 'package-archives org t))

(package-initialize)

(unless (and (file-exists-p "~/.emacs.d/elpa/archives/marmalade")
             (file-exists-p "~/.emacs.d/elpa/archives/gnu")
             (file-exists-p "~/.emacs.d/elpa/archives/melpa"))
  (package-refresh-contents))

(defun packages-install (&rest packages)
  (mapc (lambda (package)
          (let ((name (car package))
                (repo (cdr package)))
            (when (not (package-installed-p name))
              (let ((package-archives (list repo)))
                (package-initialize)
                (package-install name)))))
        packages)
  (package-initialize)
  (delete-other-windows))

(provide 'setup-package)
