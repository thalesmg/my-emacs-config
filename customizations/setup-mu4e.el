(when (file-directory-p "/usr/share/emacs/site-lisp/mu4e")

  ;; https://f-santos.gitlab.io/2020-04-24-mu4e.html
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
  (require 'mu4e)

  ;; SMTP settings:
  (setq send-mail-function 'smtpmail-send-it)    ; should not be modified
  (setq smtpmail-smtp-server "smtp.mail.me.com") ; host running SMTP server
  (setq smtpmail-smtp-service 587)               ; SMTP service port number
  (setq smtpmail-stream-type 'starttls)          ; type of SMTP connections to use

  ;; Mail folders:
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-sent-folder   "/Sent")
  (setq mu4e-trash-folder  "/Trash")

  ;; The command used to get your emails (adapt this line, see section 2.3):
  (setq mu4e-get-mail-command "mbsync --config ~/.config/mbsync/.mbsyncrc appleaccount")
  ;; Further customization:
  (setq
   ;; mu4e-html2text-command "w3m -T text/html" ; how to handle html-formatted emails
   mu4e-headers-date-format "%Y-%m-%d"
   mu4e-update-interval 300                  ; seconds between each mail retrieval
   mu4e-headers-auto-update t                ; avoid to type `g' to update
   mu4e-view-show-images t                   ; show images in the view buffer
   mu4e-compose-signature-auto-include nil   ; I don't want a message signature
   mu4e-use-fancy-chars t)                   ; allow fancy icons for mail threads

  ;; Do not reply to yourself:
  (setq mu4e-compose-reply-ignore-address '("no-?reply" "your.own@email.address"))

  )
