;;; -*- lexical-binding: nil; -*-
;;; ^^^ https://emacs.stackexchange.com/a/85747/24054
(load "ats2-mode.el")
(load "flycheck-ats2.el")

(require 'ats2-mode)
(require 'flycheck)
(require 'ats2-flycheck)

(add-hook 'ats-mode-hook 'flycheck-ats2-setup)
