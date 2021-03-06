(require 'org)
(require 'org-journal)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))
;; para o org-agenda respeitar o .dir-locals.el, se houver
(add-hook 'org-agenda-mode-hook #'hack-dir-local-variables-non-file-buffer)

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(custom-set-variables
 '(org-format-latex-options
   '(:foreground default
     :background default
     :scale 1.8
     :html-foreground "Black"
     :html-background "Transparent"
     :html-scale 1.0
     :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))))

(setq org-log-done t)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)

(customize-set-variable 'org-journal-date-format "%a, %d/%m/%Y")
(customize-set-variable 'org-journal-file-format "%Y%m%d.org")
(customize-set-variable 'org-journal-dir "~/org/journal")

;; https://stackoverflow.com/a/28130043
(defun tmg/org-todo-custom-date (&optional arg)
  "Like org-todo-yesterday, but prompt the user for a date. The time
of change will be 23:59 on that day"
  (interactive "P")
  (let* ((hour (nth 2 (decode-time
                       (org-current-time))))
         (daysback (- (date-to-day (current-time-string)) (org-time-string-to-absolute (org-read-date))))
         (org-extend-today-until (+ 1 (* 24 (- daysback 1)) hour))
         (org-use-effective-time t)) ; use the adjusted timestamp for logging
    (if (eq major-mode 'org-agenda-mode)
        (org-agenda-todo arg)
      (org-todo arg))))

;; (require 'org-alert)
;; (setq org-alert-interval 300)
;; (org-alert-enable)
;; (setq alert-default-style 'libnotify)

;; (defun tmg/org-journal-new-entry-xerpa (prefix &optional time)
;;   ""
;;   (interactive "P")
;;   (require 'org-journal)
;;   (let ((old-org-journal-dir org-journal-dir))
;;     (ignore-errors
;;       (customize-set-variable 'org-journal-dir "~/dev/org-xerpa/")
;;       (call-interactively 'org-journal-new-entry nil [prefix time]))
;;     (customize-set-variable 'org-journal-dir old-org-journal-dir)))

(defun tmg-org-begin-src ()
  ""
  (interactive)
  (insert "#+BEGIN_SRC ")
  (set-mark (point))
  (insert "\n")
  (insert "\n#+END_SRC\n")
  (goto-char (mark))
  (pop-mark))
(define-key org-mode-map (kbd "C-c t s") 'tmg-org-begin-src)

(defun tmg-org-begin-quote ()
  ""
  (interactive)
  (insert "#+BEGIN_QUOTE\n")
  (set-mark (point))
  (insert "\n#+END_QUOTE\n")
  (goto-char (mark))
  (pop-mark))
(define-key org-mode-map (kbd "C-c t q") 'tmg-org-begin-quote)

(use-package org-roam
  :custom
  (org-roam-directory "~/org/org-roam/")
  (org-roam-db-location "~/org/org-roam.db")
  (org-roam-completion-system 'ivy))
