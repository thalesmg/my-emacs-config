;; Smartparens customizations

(require 'smartparens)

(eval-after-load 'smartparens
  '(progn
     (define-key smartparens-mode-map (kbd "<C-right>") 'sp-forward-slurp-sexp)
     (define-key smartparens-mode-map (kbd "<C-left>") 'sp-forward-barf-sexp)
     (define-key smartparens-mode-map (kbd "M-s") 'sp-splice-sexp)))
