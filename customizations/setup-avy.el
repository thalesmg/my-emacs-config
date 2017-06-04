(require 'avy)

(defun avy-go-past-char ()
  "Calls `avy-goto-char` and advances one character''"
  (interactive)
  (command-execute 'avy-goto-char)
  (forward-char))

;; Jump with Avy
;; (global-set-key (kbd "<C-return>") 'avy-go-past-char)

(global-set-key (kbd "<C-return>") 'avy-goto-char)
