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

(defun tmg/org-journal-new-entry-emqx (prefix &optional time)
  ""
  (interactive "P")
  (require 'org-journal)
  (let ((old-org-journal-dir org-journal-dir))
    (ignore-errors
      (customize-set-variable 'org-journal-dir "~/dev/org-emqx/journal")
      (call-interactively 'org-journal-new-entry nil [prefix time]))
    (customize-set-variable 'org-journal-dir old-org-journal-dir)))

(defun tmg/org-journal-ensure-emqx-dir ()
  ""
  (interactive)
  (let* ((today (format-time-string "%Y%m%d"))
         (dir (concat "~/dev/org-emqx/journal/" today)))
    (make-directory dir)))

(defun tmg/org-begin-src ()
  ""
  (interactive)
  (insert "#+BEGIN_SRC ")
  (set-mark (point))
  (insert "\n")
  (insert "\n#+END_SRC\n")
  (goto-char (mark))
  (pop-mark))
(define-key org-mode-map (kbd "C-c t s") 'tmg/org-begin-src)

(defun tmg/org-begin-quote ()
  ""
  (interactive)
  (insert "#+BEGIN_QUOTE\n")
  (set-mark (point))
  (insert "\n#+END_QUOTE\n")
  (goto-char (mark))
  (pop-mark))
(define-key org-mode-map (kbd "C-c t q") 'tmg/org-begin-quote)

(defun tmg/slugify (string)
  (replace-regexp-in-string
   "[^a-z0-9-]" "-"
   (downcase string)))

(defun tmg/trim-string (string)
  (replace-regexp-in-string
   "^[ \t]*" ""
   (replace-regexp-in-string
    "[ \t]$" ""
    string)))

(defun tmg/org-heading-custom-id-of (heading-title)
  (concat "sec:" (tmg/trim-string (tmg/slugify heading-title))))

(defun tmg/org-list-all-headings ()
  (let ((headings '()))
    (org-map-entries
     (lambda ()
       (pcase (org-heading-components)
         (`(,level ,_ ,_ ,_ ,title ,_)
          (setq headings
                (append headings
                        (list `(:level ,level
                                :title ,title
                                :target ,(tmg/org-heading-custom-id-of title)))))))))
    headings))

(defun tmg/org-insert-all-heading-targets ()
  (org-map-entries
   (lambda ()
     (pcase (org-heading-components)
       (`(,_ ,_ ,_ ,_ ,title ,_)
        (when (not (org-entry-get (point) "CUSTOM_ID"))
          (let ((custom-id (tmg/org-heading-custom-id-of title)))
            (org-entry-put (point) "CUSTOM_ID" custom-id))))))))

(defun org-dblock-write:tmg/table-of-contents (&optional params)
  (let ((max-depth (or (plist-get params :max-depth) 1))
        (headings (tmg/org-list-all-headings)))
    (tmg/org-insert-all-heading-targets)
    (dolist (heading headings)
      (when (<= (plist-get heading :level) max-depth)
        (let ((title (plist-get heading :title))
              (level (plist-get heading :level))
              (target (plist-get heading :target)))
          (dotimes (_ (- level 1))
            (insert "  "))
          (insert "- ")
          (org-insert-link nil (concat "#" target) title)
          (insert "\n"))))))

(defun tmg/org-table-of-contents (&optional params)
  "generate a table of contents for the current buffer.
`C-c C-x x' to call `org-dynamic-block-insert-dblock', `C-c C-c'
to update the dynamic block."
  (interactive)
  (pcase (org-find-dblock "tmg/table-of-contents")
    (`nil
     (org-create-dblock
      '(:name "tmg/table-of-contents" :max-depth 1)))
    (start (goto-char start)))
  (org-update-dblock))

(org-dynamic-block-define "tmg/table-of-contents" #'tmg/org-table-of-contents)

(defun tmg/rows-to-org-table (rows &optional headers)
  (let ((beg (point))
        (insert-row (lambda (xs)
                      (insert (string-join xs "\t"))
                      (insert "\n"))))
    (when headers
      (funcall insert-row headers))
    (dolist (row rows)
      (funcall insert-row row))
    (org-table-convert-region beg (point) '(16))
    (when headers
      (goto-char beg)
      (org-table-insert-hline))))

(defmacro tmg/--wrap-org-roam-fn (fn)
  (let ((fn-name (intern (concat "tmg/" (symbol-name fn)))))
   `(defun ,fn-name ()
      (interactive)
      (let ((ivy-mode-before ivy-mode))
        (unwind-protect
            (progn
              (ivy-mode +1)
              (,fn))
          (ivy-mode ivy-mode-before))))))

(tmg/--wrap-org-roam-fn org-roam-node-find)
(tmg/--wrap-org-roam-fn org-roam-node-insert)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  (org-roam-db-autosync-mode)
  :custom
  (org-roam-directory "~/org/org-roam/")
  (org-roam-db-location "~/org/org-roam.db")
  (org-roam-completion-system 'ivy))
