;; Customizations relating to editing a buffer.

(require 'helm-swoop)

;; Key binding to use "hippie expand" for text autocompletion
;; http://www.emacswiki.org/emacs/HippieExpand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Para substituir ao colar
(delete-selection-mode 1)

;; Lisp-friendly hippie expand
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;; global yasnippet mode
(when (boundp 'yas-global-mode)
  (yas-global-mode 1))

;; Highlights matching parenthesis
(show-paren-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Interactive search key bindings. By default, C-s runs
;; isearch-forward, so this swaps the bindings.
(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
;; (global-set-key (kbd "C-s") 'helm-swoop)
;; (global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'counsel-grep-or-swiper-backward)
;; (global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Don't use hard tabs
(setq-default indent-tabs-mode nil)


;; comments
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; use 2 spaces for tabs
(defun die-tabs ()
  (interactive)
  (set-variable 'tab-width 2)
  (mark-whole-buffer)
  (untabify (region-beginning) (region-end))
  (keyboard-quit))

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq auto-save-default nil)

;; Use smartparens keybindings when using it
(add-hook 'smartparens-strict-mode 'sp-use-smartparens-bindings)
(add-hook 'smartparens-mode 'sp-use-smartparens-bindings)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; Para testar que o modo está habilitado:
;; (bound-and-true-p electric-indent-mode)
;; ou
;; (and (boundp 'electric-indent-mode) electric-indent-mode)
(defun tmg-toggle-delete-trailing-whitespace ()
  (interactive)
  (if (member 'delete-trailing-whitespace before-save-hook)
      (progn
        (remove-hook 'before-save-hook 'delete-trailing-whitespace)
        (electric-indent-mode -1)
        (message "delete-trailing-whitespace is off"))
    (progn
      (add-hook 'before-save-hook 'delete-trailing-whitespace)
      (electric-indent-mode 1)
      (message "delete-trailing-whitespace is on"))))
(global-set-key (kbd "<f12>") 'tmg-toggle-delete-trailing-whitespace)

;; Electric pair mode everywhere!
(add-hook 'prog-mode-hook #'electric-pair-mode)

;; truncate long lines (line wrap)
(global-set-key (kbd "<f6>") 'toggle-truncate-lines)

;; ivy + counsel para ter amostra do caractere
;; (global-set-key (kbd "C-x 8 RET") 'counsel-unicode-char)
;; helm-unicode para ter amostra do caractere
(global-set-key (kbd "C-x 8 RET") 'helm-unicode)

;; expand region
(global-set-key (kbd "C-=") 'er/expand-region)

(custom-set-faces
 '(ediff-odd-diff-C ((t (:background "#555555")))))

;; multiple cursors
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-previous-like-this)

;; hocon syntax highlight (closest thing so far)
(add-to-list 'auto-mode-alist '("\\.hocon$" . hcl-mode))

(setq-default fill-column 90)
