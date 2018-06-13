(defvar my-packages
  '(
    ;; org-alert
    ac-cider
    ace-window
    alchemist
    ample-zen-theme
    ansible
    avy
    cider
    color-theme-sanityinc-tomorrow
    clojure-mode
    clojure-mode-extra-font-locking
    darktooth-theme
    diff-hl
    edit-server
    elm-mode
    flycheck-rust
    git-timemachine
    helm
    helm-ag
    helm-projectile
    ido-ubiquitous
    indent-guide
    intero
    magit
    markdown-mode
    paradox
    paredit
    projectile
    projectile-ripgrep
    racer
    rainbow-delimiters
    rg
    rust-mode
    smartparens
    smex
    switch-window
    use-package
    wgrep
    wgrep-ag
    wgrep-helm
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
