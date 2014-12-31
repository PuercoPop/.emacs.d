;; From Bodil's emacs.d
;; https://github.com/bodil/emacs.d/blob/master/bodil-orgmode.el
;; Stop org-mode from highjacking shift-cursor keys
(setq org-replace-disputed-keys t
      org-use-speed-commands t
      org-fontify-done-headline t

      ;; Agenda
      org-startup-truncated nil
      org-completion-use-ido t
      org-return-follows-link t
      org-special-ctrl-a/e t
      org-special-ctrl-k t
      org-ctrl-k-protect-subtree t

      org-todo-keywords '((sequence "TODO" "|" "DONE")
                          (sequence "To-Download" "Downloading" "|"
                                    "Downladed" "To-Watch" "Watched"))

      org-src-fontify-natively t
      org-src-lang-modes '(("ocaml" . tuareg)
                           ("elisp" . emacs-lisp)
                           ("ditaa" . artist)
                           ("asymptote" . asy)
                           ("dot" . fundamental)
                           ("sqlite" . sql)
                           ("calc" . fundamental)
                           ("C" . c)
                           ("cpp" . c++)
                           ("screen" . shell-script)
                           ("javascript" . js2)
                           ("json" . json))

      ;; Add pdflatex to exec-path
      exec-path (append exec-path '("/usr/local/texlive/2012/bin/universal-darwin/")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp . t)))

(define-key org-mode-map (kbd "<f5>") 'epresent-run)

(setq org-confirm-babel-evaluate nil)

;; Leuven src blocks: http://orgmode.org/worg/org-contrib/babel/examples/fontify-src-code-blocks.html
(defface org-block-begin-line
  '((t (:underline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF")))
  "Face used for the line delimiting the begin of source blocks.")

(defface org-block-background
  '((t (:background "#FFFFEA")))
  "Face used for the source block background.")

(defface org-block-end-line
  '((t (:overline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF")))
  "Face used for the line delimiting the end of source blocks.")

;; TODO progress loggin stuf
(setq org-log-done 'time)

;; Org Files Files
(setq org-directory "~/org")
(setq org-agenda-directory (concat org-directory "/Agenda/"))
(setq org-agenda-files (directory-files (expand-file-name org-agenda-directory) t "^[^\.][^#][[:alnum:]]+\.org$"))
(setq org-default-notes-file (concat org-directory "/gtd.org"))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ; add-to-mode

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
                                        ;(add-hook 'org-mode-hook 'turn-on-font-lock)
;; Default Settings


;; Org Agenda
(setq org-agenda-custom-commands
      '(("v" tags "Movies")
        ("e" tags "Eventos")))
;; To add: quicklink to bookmarks, weight,

;; Capture Templates
;; Add idea, mind-onanism, contacts, movies to download
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "gtd.org" "Tasks")
         "* TODO %?\n %i\n")
        ("i" "For jotting quick ideas" entry (file+headline "gtd.org" "Ideas")
         "* %?\n %i\n%t\n%A")
        ;; ("c" "Contacts" entry (file "contacts.org")
        ;;  "* %(org-contacts-template-name)\n  :PROPERTIES:\n  :EMAIL: %(org-contacts-template-email)\n  :END:")
        ("b" "Bookmark links" entry (file+headline "links.org" "Bookmarks")
         "* %?%^g")
        ("m" "Movies to see" entry (file "movies.org")
         "* ToDownload %? \n  :PROPERTIES:\n  :DATE: %t\n  :URL: %c\n  :END:")
        ("l" "Temp Links from the interwebs" item (file+headline "links.org" "Temporary Links")
         "%?\nEntered on %U\n \%i\n %a")
        ("w" "Weight Log" table-line (file+headline "weight.org" "Diario de Peso") " | %? | %t |")
        ("c" "Lucuma Clock In" table-line (file+headline "lucuma.org" "Bitácora de Asistencia") " | %T |")))

(custom-set-faces
 '(org-done ((t (:foreground "PaleGreen"
                             :weight normal
                             :strike-through t))))
 '(org-headline-done
   ((((class color) (min-colors 16) (background dark))
     (:foreground "LightSalmon" :strike-through t)))))

(define-key org-mode-map [f12] 'epresent-run)

;; Org-Journal
(setq org-journal-dir "~/org/journal/")

(provide 'setup-org-mode)
