(autoload 'js2-mode "js2-mode" nil t)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq-default js2-auto-indent-p t
              js2-cleanup-whitespace t
              js2-enter-indents-newline t
              js2-indent-on-enter-key t
              js2-mode-indent-ignore-first-tab t
              js2-show-parse-errors nil
              js2-strict-inconsistent-return-warning nil
              js2-strict-var-hides-function-arg-warning nil
              js2-strict-missing-semi-warning nil
              js2-strict-trailing-comma-warning nil
              js2-strict-cond-assign-warning nil
              js2-strict-var-redeclaration-warning nil

              js2-global-externs '("module" "require" "$" "_" "_gaq"))


(require 'js2-refactor)

(setq ac-js2-evaluate-calls t)
;; (add-to-list 'ac-js2-external-libraries "path/to/lib/library.js")
;; (run-skewer)

(provide 'setup-js2-mode)
