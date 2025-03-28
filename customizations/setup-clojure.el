;;;;
;; Clojure
;;;;

(require 'clojure-mode)
(require 'flycheck)
;; (require 'flycheck-joker)
(require 'flycheck-clj-kondo)

;; Enable paredit for Clojure
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'flycheck-mode)

;; para quando o magit ediff caga com parenteses desbalanceados
(defun tmg-toggle-paredit-clojure-hook ()
  (interactive)
  (if (member 'enable-paredit-mode clojure-mode-hook)
      (progn
        (remove-hook 'clojure-mode-hook 'enable-paredit-mode)
        (message "paredit-mode hook removed from clojure-mode-hook"))
    (progn
      (add-hook 'clojure-mode-hook 'enable-paredit-mode)
      (message "paredit-mode hook added to clojure-mode-hook"))))
(define-key clojure-mode-map (kbd "<f8>") 'tmg-toggle-paredit-clojure-hook)

;; This is useful for working with camel-case tokens, like names of
;; Java classes (e.g. JavaClassName)
(add-hook 'clojure-mode-hook 'subword-mode)

;; A little more syntax highlighting
(require 'clojure-mode-extra-font-locking)

;; syntax hilighting for midje
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq inferior-lisp-program "lein repl")
            (font-lock-add-keywords
             nil
             '(("(\\(facts?\\)"
                (1 font-lock-keyword-face))
               ("(\\(background?\\)"
                (1 font-lock-keyword-face))))
            (define-clojure-indent (fact 1))
            (define-clojure-indent (facts 1))))

;;;;
;; Cider
;;;;

;; provides minibuffer documentation for the code you're typing into the repl
(add-hook 'cider-mode-hook 'turn-on-eldoc-mode)

;; go right to the REPL buffer when it's finished connecting
(setq cider-repl-pop-to-buffer-on-connect t)

;; When there's a cider error, show its buffer and switch to it
(setq cider-show-error-buffer t)
(setq cider-auto-select-error-buffer t)

;; Where to store the cider history.
(setq cider-repl-history-file "~/.emacs.d/cider-history")

;; Wrap when navigating history.
(setq cider-repl-wrap-history t)

;; enable paredit in your REPL
(add-hook 'cider-repl-mode-hook 'paredit-mode)

;; Use clojure mode for other extensions
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojurescript-mode))
(add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode))

(defun zprint-this ()
  (interactive)
  (basic-save-buffer)
  (let ((default-directory (projectile-project-root)))
    ;; (shell-command (concat "zprint " buffer-file-name))
    (shell-command (concat "lein cljfmt fix " buffer-file-name))
    (revert-buffer nil t)))

;; For autocomplete
;; (require 'ac-cider)
;; (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
;; (add-hook 'cider-mode-hook 'ac-cider-setup)
;; (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
;; (eval-after-load "auto-complete"
;;   '(progn
;;      (add-to-list 'ac-modes 'cider-mode)
;;      (add-to-list 'ac-modes 'cider-repl-mode)))

(use-package clojure-mode
  :bind
  (:map clojure-mode-map
        ("C-x M-q" . zprint-this)))

;; Clojurescript CIDER/figwheel
(require 'cider)
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")


;; não mexer com os espaços em branco ao salvar
;; (add-hook 'clojure-mode-hook (lambda ()
;;                                (remove-hook 'before-save-hook 'delete-trailing-whitespace)))

;; LSP - ainda esta' muito bugado...

;; (require 'lsp-mode)
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection '("bash" "-c" "clojure-lsp"))
;;                   :major-modes '(clojure-mode clojurec-mode clojurescript-mode)
;;                   :server-id 'clojure-lsp))
;; (add-to-list 'lsp-language-id-configuration '(clojure-mode . "clojure-mode"))
;; (setq lsp-enable-indentation nil)
;; (add-hook 'clojure-mode-hook #'lsp)
;; (add-hook 'clojurec-mode-hook #'lsp)
;; (add-hook 'clojurescript-mode-hook #'lsp)
