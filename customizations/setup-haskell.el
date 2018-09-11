(require 'intero)
(require 'flycheck)

;; Intero
(add-hook 'haskell-mode-hook 'intero-mode)

;; (with-eval-after-load 'intero
;;   (progn
;;     (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
;;     (local-set-key (kbd "C-x M-q")
;;                    (lambda ()
;;                      (interactive)
;;                      (basic-save-buffer)
;;                      (shell-command (concat "stack exec hfmt -- -w " buffer-file-name))))))

(use-package intero
  :config
  (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
  (smartparens-mode t)
  :bind
  (:map haskell-mode-map
   ("C-x M-q" . (lambda ()
                  (interactive)
                  (basic-save-buffer)
                  (shell-command (concat "stack exec hfmt -- -w " buffer-file-name))))))
