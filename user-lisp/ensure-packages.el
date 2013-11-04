(defvar puercopop-packages
  '(ido-better-flex
    ido-vertical-mode
    undo-tree
    sudo-ext
    smart-mode-line
    magit
    dired+

    ;; Misc
    diminish
    osx-plist
    auto-complete
    guide-key

    ;; General Editing
    move-text
    drag-stuff
    expand-region
    multiple-cursors
    wgrep

    ;; HTML
    handlebars-sgml-mode
    closure-template-html-mode

    ;; CSS
    less-css-mode
    rainbow-mode

    ;; SML
    sml-mode
    ob-sml

    ;; Lisp
    paredit
    smartparens
    rainbow-delimiters

    ;; Common Lisp
    redshank
    ac-slime

    ;; Clojure
    nrepl
    cljsbuild-mode
    elein
    slamhound
    ac-nrepl

    ;; Scheme
    geiser
    ac-geiser

    ;; Emacs Lisp
    elisp-slime-nav
    elpakit
    morlock

    ;; Javascript
    js2-mode
    js2-refactor
    ac-js2
    skewer-mode

    ;; Python
    pep8

    ;; SQL
    sql-indent
    ))

(dolist (package puercopop-packages)
  (when (not (package-installed-p package))
    (package-install package)))

(provide 'ensure-packages)
