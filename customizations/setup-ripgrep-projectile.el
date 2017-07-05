(require 'projectile-ripgrep)

(eval-after-load 'projectile-mode
  '(define-key projectile-mode-map (kbd "C-c p s r") 'projectile-ripgrep))
