(require 'nix-haskell-mode)

;; dante is bad...
;; (require 'dante)

;; (remove-hook 'haskell-mode-hook 'intero-mode)
;; (add-hook 'haskell-mode-hook 'dante-mode)
;; (add-hook 'haskell-mode-hook 'flymake-mode)

;; (eval-after-load 'flymake '(require 'flymake-cursor))

(require 'lsp)
(require 'lsp-haskell)
(require 'lsp-ui)

(remove-hook 'haskell-mode-hook 'intero-mode)

(add-hook 'haskell-mode-hook 'flycheck-mode)
(add-hook 'haskell-mode-hook #'lsp)
