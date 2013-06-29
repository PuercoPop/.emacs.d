(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq ns-function-modifier 'hyper)

;;(setq mac-option-modifier 'meta)
;;(setq mac-right-option-modifier nil)
(setq mac-right-option-modifier 'ctrl)

;;; mac friendly font
;; (condition-case nil
;;     (set-face-attribute 'default nil :font "Monaco-14")
;;   (error "Monaco: No such font"))

;; make sure path is correct when launched as application
;; Fixed now with /etc/launchd.conf
;; (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
;; (push "/usr/local/bin" exec-path)

;; keybinding to toggle full screen mode
(global-set-key (quote [M-f10]) (quote ns-toggle-fullscreen))

;; Move to trash when deleting stuff
(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")

;; Don't scroll when not in focus
(mouse-wheel-mode -1)

(provide 'mac)
