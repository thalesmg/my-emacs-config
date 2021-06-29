(require 'elfeed)

(load "~/org/diversos/elfeed.el" t)

(setq elfeed-feeds
      (if (boundp 'tmg/elfeed-feeds)
          tmg/elfeed-feeds
        '())
      )
