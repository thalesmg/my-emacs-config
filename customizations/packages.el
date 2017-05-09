(defvar my-packages
  '(
    ac-cider
    alchemist
    ample-zen-theme
    avy
    cider
    clojure-mode
    clojure-mode-extra-font-locking
    darktooth-theme
    diff-hl
    edit-server
    ido-ubiquitous
    indent-guide
    magit
    org-alert
    paredit
    projectile
    smartparens
    smex
rainbow-delimiters
    ))

;; package loading
(setq packaged-contents-refreshed-p nil)
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (condition-case ex
	(package-install p)
      ('error (if packaged-contents-refreshed-p
		  (error ex)
		(package-refresh-contents)
		(setq packaged-contents-refreshed-p t)
		(package-install p))))))

(provide 'packages)
