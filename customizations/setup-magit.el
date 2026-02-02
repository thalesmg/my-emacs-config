(require 'magit)

(setq
 magit-push-current-set-remote-if-missing t
 ;; Don't prompt everytime for push destination
 magit-push-always-verify nil)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(global-set-key (kbd "C-x g") 'magit-status)

(add-hook 'magit-mode-hook 'diff-hl-mode)

(add-hook 'magit-process-mode-hook
          (lambda ()
            (add-hook 'after-change-functions
                      (lambda (beg end len)
                        (ansi-color-apply-on-region beg end))
                      nil t)))

(provide 'setup-magit)
