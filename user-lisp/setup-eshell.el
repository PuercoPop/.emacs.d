(require 'eshell)

(add-hook 'eshell-load-hook 'nyan-prompt-enable)

;; press F11 to bring up the eshell buffer if no eshell buffer is open then open one

(defun ppop-bring-up-eshell ()
  (interactive)
  (if (string= "eshell-mode" major-mode)
      (jump-to-register :eshell-fullscreen)
    (let ((eshell-buffer (or (get-buffer "*eshell*")
                               (eshell))))
        (window-configuration-to-register :eshell-fullscreen)
        (switch-to-buffer eshell-buffer))))


(global-set-key [f11] 'ppop-bring-up-eshell)



(provide 'setup-eshell)
