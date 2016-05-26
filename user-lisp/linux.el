;; (condition-case nil
;;     (set-face-attribute 'default nil :font "Dejavu Sans Mono-11")
;;   (error "No such font"))

(condition-case nil
    (set-face-attribute 'default nil :font "Fantasque Sans Mono-14")
  (error "No such font"))
;; (set-face-attribute 'default nil :font "Input Serif-11")

(provide 'linux)
