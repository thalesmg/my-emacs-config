(require 'org)
(require 'org-journal)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(setq org-log-done t)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)

(customize-set-variable 'org-journal-date-format "%a, %d/%m/%Y")
(customize-set-variable 'org-journal-dir "~/org/journal")

;; (require 'org-alert)
;; (setq org-alert-interval 300)
;; (org-alert-enable)
;; (setq alert-default-style 'libnotify)
