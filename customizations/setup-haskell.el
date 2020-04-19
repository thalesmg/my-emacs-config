;; (require 'intero)
(require 'flycheck)
(require 'dante-mode)

;; Intero
;; (add-hook 'haskell-mode-hook 'intero-mode)

(remove-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-mode-hook 'dante-mode)

;; (with-eval-after-load 'intero
;;   (progn
;;     (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
;;     (local-set-key (kbd "C-x M-q")
;;                    (lambda ()
;;                      (interactive)
;;                      (basic-save-buffer)
;;                      (shell-command (concat "stack exec hfmt -- -w " buffer-file-name))))))

;; (use-package intero
;;   :config
;;   (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
;;   (turn-on-smartparens-mode)
;;   :bind
;;   (:map haskell-mode-map
;;    ("C-x M-q" . (lambda ()
;;                   (interactive)
;;                   (basic-save-buffer)
;;                   (shell-command (concat "stack exec stylish-haskell -- -i " buffer-file-name))
;;                   (revert-buffer nil t)))))
