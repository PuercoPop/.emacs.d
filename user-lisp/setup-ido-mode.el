(ido-mode t)
(ido-vertical-mode)

;; Smex too slow, disable
;; (smex-initialize)
;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)

(setq ido-enable-flex-matching t)
;; (setq ido-use-virtual-buffers nil)


(define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-updir)
(ido-better-flex/enable)

(when (equal system-type 'darwin)
  (add-to-list 'ido-ignore-files "\\.DS_Store"))

(provide 'setup-ido-mode)
