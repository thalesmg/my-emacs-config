(require 'wgrep)
(require 'wgrep-ag)

(add-hook 'ripgrep-search-mode-hook 'wgrep-ag-setup)
