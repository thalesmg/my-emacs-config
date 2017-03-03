(require 'magit)

(setq
 magit-push-current-set-remote-if-missing t
 ;; Don't prompt everytime for push destination
 magit-push-always-verify nil)

(provide 'setup-magit)
