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
    counsel
    counsel-projectile
    darktooth-theme
    dante
    diff-hl
    docker-tramp
    edit-server
    elm-mode
    elpy
    exec-path-from-shell
    expand-region
    flycheck-clj-kondo
    flycheck-purescript
    flycheck-rust
    forge
    git-timemachine
    helm
    helm-ag
    helm-org-rifle
    helm-projectile
    helm-swoop
    helm-unicode
    htmlize
    idris-mode
    indent-guide
    intero
    ivy
    lsp-haskell
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    merlin
    nix-haskell-mode
    org-journal
    ox-reveal
    paradox
    paredit
    projectile
    projectile-ripgrep
    psc-ide
    purescript-mode
    racer
    rainbow-delimiters
    reason-mode
    rg
    rust-mode
    slime
    smartparens
    smex
    switch-window
    use-package
    wgrep
    wgrep-ag
    wgrep-helm
    winum
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
