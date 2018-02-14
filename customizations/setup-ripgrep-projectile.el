(require 'projectile-ripgrep)
(require 'helm-ag)
(require 'rg)

(define-key projectile-mode-map (kbd "C-c p s r") 'projectile-ripgrep)

(custom-set-variables
 '(helm-ag-base-command "rg --no-heading")
 '(ripgrep-arguments (append ripgrep-arguments (list "--hidden"))))

(rg-enable-default-bindings (kbd "M-s"))
