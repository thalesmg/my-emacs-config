(require 'nix-haskell-mode)
(require 'lsp)
(require 'lsp-haskell)
(require 'lsp-ui)
(require 'nix-sandbox)

;; dante is bad...
;; (require 'dante)

;; (remove-hook 'haskell-mode-hook 'intero-mode)
;; (add-hook 'haskell-mode-hook 'dante-mode)
;; (add-hook 'haskell-mode-hook 'flymake-mode)

;; (eval-after-load 'flymake '(require 'flymake-cursor))

(remove-hook 'haskell-mode-hook 'intero-mode)

(add-hook 'haskell-mode-hook 'flycheck-mode)
(add-hook 'haskell-mode-hook #'lsp)

(add-hook 'haskell-mode-hook
          (lambda ()
            (let ((default-nix-wrapper (lambda (args)
                                         (append
                                          (append (list "nix-shell" "-I" "." "--command")
                                                  (list (mapconcat 'identity args " ")))
                                          (list (nix-current-sandbox))))))
              (setq-local lsp-haskell-process-wrapper-function default-nix-wrapper))))

(add-hook 'haskell-mode-hook
          (lambda ()
            (setq-local haskell-process-wrapper-function
                        (lambda (args) (apply 'nix-shell-command (nix-current-sandbox) args)))))

(add-hook 'flycheck-mode-hook
          (lambda ()
            (setq-local flycheck-command-wrapper-function
                        (lambda (command)
                          (apply 'nix-shell-command (nix-current-sandbox) command)))
            (setq-local flycheck-executable-find
                        (lambda (cmd)
                         (nix-executable-find (nix-current-sandbox) cmd)))))
