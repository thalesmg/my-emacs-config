;;; -*- lexical-binding: nil; -*-
;;; ^^^ https://emacs.stackexchange.com/a/85747/24054
(require 'wgrep)
(require 'wgrep-ag)

(add-hook 'ripgrep-search-mode-hook 'wgrep-ag-setup)
