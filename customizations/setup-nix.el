(require 'nix-mode)

(add-hook 'nix-mode-hook 'company-mode)

(define-key nix-mode-map (kbd "C-x M-q")
  (lambda ()
    (interactive)
    (basic-save-buffer)
    (message projectile-project-root)
    (let ((curr-file-path (string-remove-prefix (projectile-project-root) buffer-file-name)))
      (shell-command (concat "nixfmt " curr-file-path))
      (revert-buffer nil t))))
