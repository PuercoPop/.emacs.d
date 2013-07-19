(ido-mode t)
(ido-everywhere t)
(ido-vertical-mode)

;; Smex too slow, disable
;; (smex-initialize)
;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)

(setq ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-virtual-buffers nil)

(after-load 'ido
  (define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-updir)
  (when (equal system-type 'darwin)
    (add-to-list 'ido-ignore-files "\\.DS_Store")))

(ido-better-flex/enable)



(provide 'setup-ido-mode)
