(require 'racer)
(require 'rust-mode)
(require 'flycheck-rust)

(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'rust-mode-hook 'flycheck-mode)
(add-hook 'rust-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook 'company-mode)
