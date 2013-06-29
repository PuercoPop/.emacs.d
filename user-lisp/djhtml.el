;; djhtml-minor-mode
;; Built with Pony-tpl-minor-mode as a foundation

;; djhtml-minor-mode begins

(defgroup djhtml nil
  "Indentation and highlighting of django templates"
  :group 'djhtml
  :prefix "djhtml-")

(defconst djhtml-font-lock-keywords
  (append
   sgml-font-lock-keywords
   ()))

(define-minor-mode pony-tpl-minor-mode
  "djhtml minor mode"
  :initial nil
  :lighter "djhtml"
  :keymap djhtml-minor-mode-map)

;; djhtml-minor-mode ends
