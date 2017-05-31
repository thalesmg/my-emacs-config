(require 'org)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

;; (require 'org-alert)
;; (setq org-alert-interval 300)
;; (org-alert-enable)
;; (setq alert-default-style 'libnotify)
