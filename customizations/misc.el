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

(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; prevent Emacs from freezing with C-z...
(global-unset-key (kbd "C-z"))

(defun tmg/sha256 (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))))
  (let ((checksum '())
        (cur-buf (current-buffer))
        (buffer-output (make-temp-name "tmg/sha256")))
    (shell-command-on-region beg end "sha256sum" buffer-output)
    (switch-to-buffer buffer-output)
    (setq checksum (replace-regexp-in-string
                    " +-.*$"
                    ""
                    (replace-regexp-in-string
                     "\n"
                     ""
                     (buffer-string))))
    (switch-to-buffer cur-buf)
    (kill-buffer buffer-output)
    (when (equal current-prefix-arg '(4))
      (insert checksum))
    (message "%s" checksum)
    checksum))
