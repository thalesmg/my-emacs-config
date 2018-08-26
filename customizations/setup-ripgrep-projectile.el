(require 'projectile-ripgrep)
(require 'helm)
(require 'helm-projectile)
(require 'helm-ag)
(require 'rg)

(define-key projectile-mode-map (kbd "C-c p p") 'helm-projectile-switch-project)
;; (define-key projectile-mode-map (kbd "C-c p s r") 'projectile-ripgrep)

(defun tmg-helm-do-rg
    (&optional targets)
  (interactive)
  (let ((basedir (projectile-project-root)))
   (helm-do-ag basedir targets)))
(define-key projectile-mode-map (kbd "C-c p s r") 'tmg-helm-do-rg)


(custom-set-variables
 '(helm-ag-base-command "rg --no-heading")
 '(ripgrep-arguments (append ripgrep-arguments (list "--hidden"))))

(rg-enable-default-bindings (kbd "M-s"))
