(require 'lsp)
(require 'lsp-ui)

(remove-hook 'haskell-mode-hook 'intero-mode)
(remove-hook 'haskell-mode-hook 'dante-mode)

(add-hook 'haskell-mode-hook
          (lambda ()
            (setq lsp-haskell-process-path-hie "ghcide")
            (setq lsp-haskell-process-args-hie '())
            ))
