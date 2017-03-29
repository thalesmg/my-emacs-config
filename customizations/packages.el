(defvar my-packages
  '(rainbow-delimiters
    ido-ubiquitous
    diff-hl
    smex
    projectile
    clojure-mode
    clojure-mode-extra-font-locking
    ac-cider
    cider
    smartparens
    alchemist
    paredit
    darktooth-theme
    indent-guide
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
