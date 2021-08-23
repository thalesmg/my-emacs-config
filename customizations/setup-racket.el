(require 'racket-mode)

(add-hook 'racket-mode-hook 'enable-paredit-mode)
(add-hook 'racket-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'racket-mode-hook 'flycheck-mode)
(add-hook 'racket-mode-hook 'racket-xp-mode)
