(require 'elixir-mode)
(require 'erlang)
(require 'projectile)
(require 'alchemist)
(require 'lsp)

(add-hook 'elixir-mode-hook 'company-mode)
(add-hook 'elixir-mode-hook 'smartparens-mode)
(defun tmg/add-elixir-ls-to-path ()
  (let ((dir "/home/thales/dev/elixir/elixir-ls/release"))
    (if (file-directory-p dir)
        (progn
          (add-to-list 'exec-path dir)
          (remove-hook 'elixir-mode-hook 'alchemist-mode)
          (setq lsp-elixir-local-server-command (concat (file-name-as-directory dir) "language_server.sh"))
          (add-hook 'elixir-mode-hook #'lsp))
      (progn
        (add-hook 'elixir-mode-hook 'alchemist-mode)))))
(add-hook 'elixir-mode-hook 'tmg/add-elixir-ls-to-path)
(eval-after-load 'elixir-mode-hook '(require 'smartparens-elixir))

(require 'smartparens-config)
(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))

;; Run tests on save
;(setq alchemist-hooks-test-on-save t)
;; Run compile on save
;(setq alchemist-hooks-compile-on-save t)

(defvar xerpa/original-alchemist-goto-callback nil)

(defun xerpa/advice-goto-callback (&rest args)
  (setq xerpa/original-alchemist-goto-callback alchemist-goto-callback)
  (setq alchemist-goto-callback
        (lambda (path)
          (let ((project-root (projectile-project-root)))
            (if (and (stringp project-root) (stringp path))
                (apply xerpa/original-alchemist-goto-callback (list (replace-regexp-in-string "^/mnt/[a-z]+/" project-root path)))
              (apply xerpa/original-alchemist-goto-callback (list path)))))))

(defun xerpa/project-root (original-alchemist-fn &rest args)
  (if-let ((project-root (projectile-project-root)))
      project-root
    (apply original-alchemist-fn args)))

(defun xerpa/config-alchemist ()
  (when-let ((project-root (projectile-project-root)))
    (let ((ext-bin-mix (concat project-root "ext/bin/mix"))
          (ext-bin-sandbox (concat project-root "ext/bin/sandbox")))
      (when (file-exists-p ext-bin-mix)
        (setq alchemist-mix-command ext-bin-mix))
      (advice-add
       #'alchemist-project-root
       :around
       #'xerpa/project-root)
      (when (file-exists-p ext-bin-sandbox)
        (advice-add
         #'alchemist-server-goto
         :before
         #'xerpa/advice-goto-callback)))))

(add-hook 'elixir-mode-hook #'xerpa/config-alchemist)

(define-key elixir-mode-map (kbd "C-x M-q")
  (lambda ()
    (interactive)
    (basic-save-buffer)
    (message projectile-project-root)
    (let ((curr-file-path (string-remove-prefix (projectile-project-root) buffer-file-name)))
      (shell-command (concat (projectile-project-root) "ext/bin/env mix format " curr-file-path))
      (revert-buffer nil t))))

(define-key erlang-mode-map (kbd "C-x M-q")
  (lambda ()
    (interactive)
    (basic-save-buffer)
    (message projectile-project-root)
    ;; fixme: only for emqx...
    (let ((default-directory (projectile-project-root)))
      (shell-command (concat "make fmt")))
    (revert-buffer nil t)))
