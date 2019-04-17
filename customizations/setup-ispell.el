(require 'ispell)

(setq ispell-program-name "hunspell")

(setq ispell-local-dictionary-alist nil)
(add-to-list 'ispell-local-dictionary-alist (list "pt_BR" "[[:alpha:]]" "[^[:alpha:]]" "[']" t '("-d" "pt_BR") nil 'utf-8))
(add-to-list 'ispell-local-dictionary-alist (list "en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" t '("-d" "en_US") nil 'utf-8))
