(condition-case nil
    (set-face-attribute 'default nil :font "Dejavu Sans Mono-11")
  (error "Monaco: No such font"))
;; (set-face-attribute 'default nil :font "Input Serif-11")

(provide 'linux)
