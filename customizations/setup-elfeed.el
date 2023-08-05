(require 'org)
(require 'elfeed)
(require 'elfeed-org)


(use-package elfeed-org
  :ensure t
  :config
  (setq elfeed-show-entry-switch 'display-buffer)
  (setq rmh-elfeed-org-files
        (list "~/org/diversos/elfeed.org")))

(use-package elfeed
  :ensure t
  :init
  (elfeed-org)
  :config
  (setq
   ;; elfeed-db-directory (expand-file-name "elfeed" user-emacs-directory)
   elfeed-show-entry-switch 'display-buffer))
