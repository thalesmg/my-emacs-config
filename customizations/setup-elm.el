

(require 'elm-mode)

(setq tmg--nvm-in-path nil)

;; Put NVM/NPM in path
(defun tmg--add-nvm-to-path ()
  "adds NVM to exec path, if not already"
  (if tmg--nvm-in-path
      nil
    (progn (shell-command (expand-file-name "$HOME/.zprofile"))
           (setq tmg--nvm-in-path t))))

(eval-after-load 'elm-mode '(tmg--add-nvm-to-path))

(with-eval-after-load 'elm-mode
  (setq exec-path (append exec-path '("/home/thales/.nvm/versions/node/v8.4.0/bin"))))
