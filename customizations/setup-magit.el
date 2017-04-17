(require 'magit)

(setq
 magit-push-current-set-remote-if-missing t
 ;; Don't prompt everytime for push destination
 magit-push-always-verify nil)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(global-set-key (kbd "C-x g") 'magit-status)

(provide 'setup-magit)
