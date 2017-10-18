(require 'intero)
(require 'flycheck)

;; Intero
(add-hook 'haskell-mode-hook 'intero-mode)

(with-eval-after-load 'intero
  (flycheck-add-next-checker 'intero '(warning . haskell-hlint)))
