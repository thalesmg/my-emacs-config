(require 'smartparens)

(add-hook 'erlang-mode-hook #'lsp)

;; https://github.com/JimMoen/Emacs-Config/commit/2d1305fb6042d65821954aeb7758576967d3c051
(sp-with-modes '(erlang-mode)
  (sp-local-pair "<<" ">>")
  (sp-local-pair "<<\"" "\">>"))
