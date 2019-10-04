;; Color Themes
;; Read http://batsov.com/articles/2012/02/19/color-theming-in-emacs-reloaded/
;; for a great explanation of emacs color themes.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Custom-Themes.html
;; for a more technical explanation.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")

(setq inhibit-startup-screen t)

(defun disable-all-themes ()
  "disables all themes"
  (dolist (x custom-enabled-themes)
    (disable-theme x)))

;; (defadvice load-theme (before disable-themes-first activate)
;;   (disable-all-themes))

;; (progn (disable-all-themes) (load-theme 'deeper-blue) (set-default-font "Source Code Pro-7:style=Regular"))
;; (load-theme 'sanityinc-tomorrow-bright t)
(load-theme 'deeper-blue t)

(defun disable-all-themes ()
  "desliga os temas para poder experimentar outros temas"
  (dolist (x custom-enabled-themes)
    (disable-theme x)))

;; increase font size for better readability
(set-face-attribute 'default nil :height 140)

;; Font
;; (set-default-font "DejaVu Sans Mono:style=Book")
;; (set-default-font "Fira Mono-11:style=Regular")
;; (set-default-font "Iosevka SS09-7:style=Regular")
;; (set-default-font "Hasklig-7:style=Regular")
(set-default-font "Source Code Pro-7:style=Regular")
(set-fontset-font "fontset-standard" nil "Symbola:style=Regular")

;; No cursor blinking, it's distracting
(blink-cursor-mode 0)

;; Show line numbers
(global-linum-mode)

;; Vertical bars for indentation
(require 'indent-guide)
(add-hook 'prog-mode-hook 'indent-guide-mode)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; don't pop up font menu
(global-set-key (kbd "s-t") '(lambda () (interactive)))

;; Don't show native OS scroll bars for buffers because they're redundant
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; No need for menu bar nor toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; These settings relate to how emacs interacts with your operating system
(setq ;; makes killing/yanking interact with the clipboard
      x-select-enable-clipboard t

      ;; I'm actually not sure what this does but it's recommended?
      x-select-enable-primary t

      ;; Save clipboard strings into kill ring before replacing them.
      ;; When one selects something in another program to paste it into Emacs,
      ;; but kills something in Emacs before actually pasting it,
      ;; this selection is gone unless this variable is non-nil
      save-interprogram-paste-before-kill t

      ;; Shows all options when running apropos. For more info,
      ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html
      apropos-do-all t

      ;; Mouse yank commands yank at point instead of at click.
      mouse-yank-at-point t)

;; Show column numbers
(add-hook 'prog-mode-hook 'column-number-mode)

;; Move between windows (S-up, S-right, S-left, S-down)
;; (windmove-default-keybindings)

;; open helm window in the opposite buffer
(setq helm-split-window-default-side 'other)
