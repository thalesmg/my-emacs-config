(require 'projectile-ripgrep)
(require 'helm)
(require 'helm-projectile)
;; helm-ag is deprecated
;; (require 'helm-ag)
(require 'rg)
(require 'counsel)

;; to make counsel independent of serach term order
;; defualt is '((t . ivy--regex-plus))
(setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

(defun tmg-helm-do-rg (&optional targets)
  (interactive)
  (let ((basedir (projectile-project-root)))
   (helm-do-grep-ag targets)))

;; (define-key projectile-mode-map (kbd "C-c p s r") 'tmg-helm-do-rg)
(global-set-key (kbd "C-c p s r") 'counsel-projectile-rg)

(custom-set-variables
 '(helm-ag-base-command "rg -. --no-heading")
 '(ripgrep-arguments (append ripgrep-arguments (list "--hidden"))))

(rg-enable-default-bindings (kbd "M-s"))
