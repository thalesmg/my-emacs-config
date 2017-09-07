(require 'projectile-ripgrep)
(require 'helm-ag)

(define-key projectile-mode-map (kbd "C-c p s r") 'projectile-ripgrep)

(custom-set-variables
 '(helm-ag-base-command "rg --no-heading"))
