(after-load 'tetris
  (define-key tetris-mode-map (kbd "h")	'tetris-move-left)
  (define-key tetris-mode-map (kbd "l")	'tetris-move-right)
  (define-key tetris-mode-map (kbd "k")	'tetris-rotate-prev)
  (define-key tetris-mode-map (kbd "j")	'tetris-rotate-next))

(provide 'setup-games)
