(defvar my-packages
  '(
    ;; org-alert
    ac-cider
    ace-window
    alchemist
    ample-theme
    ample-zen-theme
    ansible
    ansible-doc
    auth-source-pass
    avy
    bm ;; better bookmarks
    cider
    clojure-mode
    clojure-mode-extra-font-locking
    color-theme-sanityinc-tomorrow
    company-coq
    company-terraform
    counsel
    counsel-projectile
    dante
    darktooth-theme
    dhall-mode
    diff-hl
    direnv
    docker-tramp
    dockerfile-mode
    edit-server
    elfeed
    elfeed-org
    elfeed-web
    elm-mode
    elpy
    erlang
    exec-path-from-shell
    expand-region
    flycheck-clj-kondo
    flycheck-ledger
    ;; flycheck-purescript
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
    ledger-mode
    lsp-haskell
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    merlin
    multiple-cursors
    nix-haskell-mode
    nix-mode
    nix-sandbox
    nixos-options
    org-journal
    org-roam
    ox-reveal
    paradox
    paredit
    password-store
    polymode
    projectile
    projectile-ripgrep
    proof-general
    psc-ide
    purescript-mode
    quelpa
    racer
    racket-mode
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
    unicode-fonts
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

;; custom packages
(require 'quelpa)

(setq quelpa-update-melpa-p nil)

(quelpa
 ;; '(nix-sandbox :fetcher github
 ;;               :repo "thalesmg/nix-emacs"
 ;;               :branch "fix-sandbox-directory")
 '(alloy-mode :fetcher github
              :repo "thalesmg/alloy-mode"
              :branch "master")
 )

(provide 'packages)
