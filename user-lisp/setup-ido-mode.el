(ido-mode t)
(ido-everywhere t)
(ido-vertical-mode)

(setq ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-virtual-buffers nil)

(after-load 'ido
            (define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-updir)
            (when (equal system-type 'darwin)
              (add-to-list 'ido-ignore-files "\\.DS_Store")))

(ido-better-flex/enable)



(provide 'setup-ido-mode)
