(require 'nix-haskell-mode)
(require 'dante)

(remove-hook 'haskell-mode-hook 'intero-mode)
(add-hook 'haskell-mode-hook 'dante-mode)
(add-hook 'haskell-mode-hook 'flymake-mode)

(eval-after-load 'flymake '(require 'flymake-cursor))
