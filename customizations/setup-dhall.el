;;; -*- lexical-binding: nil; -*-
;;; ^^^ https://emacs.stackexchange.com/a/85747/24054
(require 'dhall-mode)
(require 'lsp-mode)

(add-hook 'dhall-mode-hook #'lsp)
