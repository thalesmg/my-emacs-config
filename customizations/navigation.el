
;; ido-mode allows you to more easily navigate choices. For example,
;; when you want to switch buffers, ido presents you with a list
;; of buffers in the the mini-buffer. As you start to type a buffer's
;; name, ido will narrow down the list of buffers to match the text
;; you've typed in
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode t)

;; This allows partial matches, e.g. "tl" will match "Tyrion Lannister"
(setq ido-enable-flex-matching t)

;; Turn this behavior off because it's annoying
(setq ido-use-filename-at-point nil)

;; Don't try to match file across all "work" directories; only match files
;; in the current directory displayed in the minibuffer
(setq ido-auto-merge-work-directories-length -1)

;; Includes buffer names of recently open files, even if they're not
;; open now
(setq ido-use-virtual-buffers t)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Helm buffer list
(global-set-key (kbd "C-x b") 'helm-mini)
;; (global-set-key (kbd "C-x b") 'ivy-switch-buffer)

;; navegar entre buffers
(global-set-key (kbd "C-,") 'previous-buffer)
(global-set-key (kbd "C-.") 'next-buffer)

;; Enhances M-x to allow easier execution of commands. Provides
;; a filterable list of possible commands in the minibuffer
;; http://www.emacswiki.org/emacs/Smex
(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;; projectile everywhere!
(projectile-global-mode)

;; to navigate around dirs
;; https://github.com/emacs-helm/helm/issues/2623#issuecomment-1788494105
(set-variable 'helm-move-to-line-cycle-in-source nil)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)

;; navigate between windows
;; (require 'ace-window)
;; (global-set-key (kbd "C-x o") 'ace-window)
;; switch-window
(require 'switch-window)
(global-set-key (kbd "C-x o") 'ace-window)
;; (global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)

;; copies current buffer file name
(defun tmg/yank-buffer-name (&optional prefix)
  (interactive "P")
  (if prefix
      (let* ((name (buffer-file-name))
             (root (projectile-project-root))
             (relative (string-trim-left name root)))
        (message relative)
        (kill-new relative))
      (progn
        (message (buffer-file-name))
        (kill-new (buffer-file-name)))))

(global-set-key (kbd "C-c C-b") 'tmg/yank-buffer-name)

;; eshell maroto
(global-set-key (kbd "C-c s") 'eshell)

;; refresh buffer
(global-set-key (kbd "<f5>") 'revert-buffer)

;; winum - trocar de janela com M-N, N = 0, 1, 2, ...
(require 'winum)

(define-key winum-keymap (kbd "M-1") 'winum-select-window-1)
(define-key winum-keymap (kbd "M-2") 'winum-select-window-2)
(define-key winum-keymap (kbd "M-3") 'winum-select-window-3)
(define-key winum-keymap (kbd "M-4") 'winum-select-window-4)
(define-key winum-keymap (kbd "M-5") 'winum-select-window-5)
(define-key winum-keymap (kbd "M-6") 'winum-select-window-6)
(define-key winum-keymap (kbd "M-7") 'winum-select-window-7)
(define-key winum-keymap (kbd "M-8") 'winum-select-window-8)
(define-key winum-keymap (kbd "M-9") 'winum-select-window-9)

;; recent bug in helm... without this, helm-mini doesn't work....
(require 'helm-mode)
