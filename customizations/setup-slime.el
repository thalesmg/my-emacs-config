(require 'slime)

(let ((helper-file (expand-file-name "~/quicklisp/slime-helper.el")))
  (when (file-exists-p helper-file)
    (load helper-file)))

;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")
