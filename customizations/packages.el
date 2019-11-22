(defvar my-packages
  '(
    ;; org-alert
    ac-cider
    ace-window
    alchemist
    ample-theme
    ample-zen-theme
    ansible
    auth-source-pass
    avy
    cider
    clojure-mode
    clojure-mode-extra-font-locking
    color-theme-sanityinc-tomorrow
    company-terraform
    counsel
    counsel-projectile
    darktooth-theme
    diff-hl
    docker-tramp
    edit-server
    elm-mode
    elpy
    erlang
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
    ivy
    json-mode
    lsp-haskell
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    merlin
    nix-haskell-mode
    nix-mode
    nix-sandbox
    nixos-options
    org-journal
    ox-reveal
    paradox
    paredit
    password-store
    projectile
    projectile-ripgrep
    psc-ide
    purescript-mode
    racer
    rainbow-delimiters
    reason-mode
    restclient
    rg
    rust-mode
    slime
    smartparens
    smex
    switch-window
    terraform-doc
    terraform-mode
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
