(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Installs packages
(load "packages.el")

;; Rainbow mode in programming modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; Diff highlight for VCSs
(add-hook 'prog-mode-hook 'diff-hl-mode)

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-haskell.el")
(load "setup-elixir.el")
(load "setup-org.el")

;; These customizations make editing a bit nicer.
(load "editing.el")
(load "setup-avy.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Magit customizations
(load "setup-magit.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#32302F" "#FB4934" "#B8BB26" "#FABD2F" "#83A598" "#D3869B" "#17CCD5" "#EBDBB2"])
 '(custom-safe-themes
   (quote
    ("1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" "00de442f1a471c98c62281bdf5000b4311db26832a0d6b6f8ffde8705e027828" default)))
 '(haskell-process-type (quote stack-ghci))
 '(package-selected-packages
   (quote
    (paradox helm haskell-mode ansible edit-server ample-zen-theme avy company-anaconda anaconda-mode dockerfile-mode groovy-mode intero darktooth-theme restclient yaml-mode smex smartparens rainbow-delimiters paredit org-alert magit indent-guide ido-ubiquitous helm-projectile git-timemachine flycheck-mix diff-hl clojure-mode-extra-font-locking alchemist ag ac-cider)))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(safe-local-variable-values
   (quote
    ((ag-ignore-list "priv/static/**" "vendor/**" "node_modules/**")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'edit-server)
(edit-server-start)

(unless (server-running-p) (server-start))
