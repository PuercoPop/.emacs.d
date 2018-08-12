;; (condition-case nil
;;    (set-face-attribute 'default nil :font "Dejavu Sans Mono-13")
;;   (error "No such font"))

;; "Fantasque Sans Mono-13"
;; "Dejavu Sans Mono-11"
;; "Operator Mono-18"
;; "Input Serif-11"
;; "Terminus-13"

(condition-case nil
    (set-face-attribute 'default nil :font "Fantasque Sans Mono-13")
  (error "No such font"))

(provide 'linux)
