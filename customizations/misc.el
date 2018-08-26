;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; No need for ~ files when editing
(setq create-lockfiles nil)

(setq
 tramp-password-prompt-regexp
 (concat
  "^.*"
  (regexp-opt
   '("passphrase" "Passphrase"
     "password" "Password"
     "Verification code" "verification code") t)
  ".*:\0? *"))
(add-to-list 'tramp-default-proxies-alist '(nil "root" "/ssh:thalesmg@%h:"))
(add-to-list 'tramp-default-proxies-alist '("localhost" nil nil))
(add-to-list 'tramp-default-proxies-alist '("tufe" nil nil))
(add-to-list 'tramp-default-proxies-alist '("biuru" nil nil))
(add-to-list 'tramp-default-proxies-alist '("poiseh" nil nil))
