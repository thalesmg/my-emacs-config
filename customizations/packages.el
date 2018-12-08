(defvar my-packages
  '(
    ;; org-alert
    ac-cider
    ace-window
    alchemist
    ample-theme
    ample-zen-theme
    ansible
    avy
    cider
    clojure-mode
    clojure-mode-extra-font-locking
    color-theme-sanityinc-tomorrow
    darktooth-theme
    diff-hl
    edit-server
    elm-mode
    exec-path-from-shell
    flycheck-rust
    git-timemachine
    helm
    helm-ag
    helm-projectile
    idris-mode
    indent-guide
    intero
    magit
    markdown-mode
    merlin
    paradox
    paredit
    projectile
    projectile-ripgrep
    racer
    rainbow-delimiters
    reason-mode
    rg
    rust-mode
    smartparens
    smex
    switch-window
    use-package
    wgrep
    wgrep-ag
    wgrep-helm
    yaml-mode
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
