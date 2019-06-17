(require 'org)
(require 'org-journal)

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

(setq org-log-done t)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)

(customize-set-variable 'org-journal-date-format "%a, %d/%m/%Y")
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

(defun tmg-org-journal-new-entry-zen (prefix &optional time)
  ""
  (interactive "P")
  (require 'org-journal)
  (let ((old-org-journal-dir org-journal-dir))
    (ignore-errors
      (customize-set-variable 'org-journal-dir "~/zen/org/")
      (call-interactively 'org-journal-new-entry nil [prefix time]))
    (customize-set-variable 'org-journal-dir old-org-journal-dir)))
