;;; -*- lexical-binding: nil; -*-
;;; ^^^ https://emacs.stackexchange.com/a/85747/24054
(require 'psc-ide)

(add-hook 'purescript-mode-hook
  (lambda ()
    (psc-ide-mode)
    (company-mode)
    (flycheck-mode)
    (turn-on-purescript-indentation)))
