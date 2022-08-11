(require 'nix-haskell-mode)
(require 'lsp-mode)
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
(remove-hook 'haskell-mode-hook 'dante-mode)

(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-mode-hook 'flycheck-mode)

(setq lsp-prefer-flymake nil)

(defun tmg/default-nix-wrapper (args)
  ;; (message "default directory: %s" default-directory)
  ;; (message "current sandbox: %s" (nix-current-sandbox))
  ;; (message "lsp-haskell--get-root: %s" (lsp-haskell--get-root))
  ;; (message "current buffer: %s" (current-buffer))
  (if-let ((sandbox (nix-current-sandbox)))
      (progn
        ;; (message "siiiiiiiiiiiiiiiiiiiiiiiiiiiiimmmmmmmmmm")
        (append
         (append (list "nix-shell" "-I" "." "--command")
                 (list (mapconcat 'identity args " ")))
         (list sandbox)))
    (progn
      ;; (message "nããããããããããããããããããããããããããããããããããããããããããããooooooooooooooooo")
      args)))

(defun tmg/haskell-lsp-hook ()
  (setq lsp-haskell-process-wrapper-function #'tmg/default-nix-wrapper)
  (setq haskell-process-wrapper-function #'tmg/default-nix-wrapper)
  (setq lsp-haskell-server-wrapper-function #'tmg/default-nix-wrapper)
  (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
  (setq haskell-process-wrapper-function
        (lambda (args)
          (if-let ((sandbox (nix-current-sandbox)))
              (apply 'nix-shell-command sandbox args)
            args)))
  )

(defun tmg/haskell-flycheck-hook ()
  (setq flycheck-command-wrapper-function #'tmg/default-nix-wrapper)
  (setq flycheck-executable-find
        (lambda (cmd)
          ;; (message "eu sou o flycheck-executable-find")
          ;; (message "default directory: %s" default-directory)
          ;; (message "current sandbox: %s" (nix-current-sandbox))
          ;; (message "lsp-haskell--get-root: %s" (lsp-haskell--get-root))
          ;; (message "current buffer: %s" (current-buffer))
          (if-let ((sandbox (nix-current-sandbox)))
              (nix-executable-find sandbox cmd)
            cmd))))

(add-hook 'haskell-mode-hook
          #'tmg/haskell-lsp-hook
          ;; (lambda ()
          ;;   (let ((default-nix-wrapper (lambda (args)
          ;;                                  (if (nix-current-sandbox)
          ;;                                    (append
          ;;                                     (append (list "nix-shell" "-I" "." "--command")
          ;;                                             (list (mapconcat 'identity args " ")))
          ;;                                     (list (nix-current-sandbox)))
          ;;                                  args))))
          ;;     (setq-local lsp-haskell-process-wrapper-function default-nix-wrapper)
          ;;     (setq-local haskell-process-wrapper-function
          ;;                 (lambda (args)
          ;;                   (apply 'nix-shell-command (nix-current-sandbox) args)))
          ;;     (setq-local lsp-haskell-process-path-hie "haskell-language-server-wrapper")
          ;;     ))
          )

(add-hook 'flycheck-mode-hook
          #'tmg/haskell-flycheck-hook
          ;; (lambda ()
          ;;   (setq-local flycheck-command-wrapper-function
          ;;               (lambda (command)
          ;;                 (apply 'nix-shell-command (nix-current-sandbox) command)))
          ;;   (setq-local flycheck-executable-find
          ;;               (lambda (cmd)
          ;;                 (nix-executable-find (nix-current-sandbox) cmd))))
          )

;; (define-key haskell-mode-map "C-x M-q"
;;   (lambda ()
;;     (interactive)
;;     (basic-save-buffer)
;;     (shell-command (concat "stylish-haskell -i " buffer-file-name))
;;     (revert-buffer nil t)))
