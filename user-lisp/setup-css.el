(add-to-list 'auto-mode-alist '("\\.css$" . (lambda () 
                                              (less-css-mode)
                                              (rainbow-mode))))
(add-to-list 'auto-mode-alist '("\\.less$" . (lambda ()
                                               (css-mode)
                                               (rainbow-mode))))

(provide 'setup-css)
