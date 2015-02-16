(require 'helm-config)
;; Who uses C-n/C-p?
(eval-after-load 'helm
  '(progn
     (define-key helm-map (kbd "C-s") 'helm-next-line)
     (define-key helm-map (kbd "C-r") 'helm-previous-line)))
(global-set-key (kbd "C-x c g") 'helm-google)
(global-set-key (kbd "C-M-s") 'helm-occur)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(provide 'setup-helm)
