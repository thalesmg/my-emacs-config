;;; ats2-mode.el --- Major mode to edit ATS2 source code

;; Copyright (C) 2007  Stefan Monnier
;; updated and modified by Matthew Danish <mrd@debian.org> 2008-2013
;; updated and modified by Varun Gandhi <theindigamer15@gmail.com> 2018

;; Author: Stefan Monnier <monnier@iro.umontreal.ca>
;; Keywords:

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'cl-lib)
(require 'compile)

(when (not (boundp 'xemacsp))
  (setq xemacsp (boundp 'xemacs-logo)))

;; Nice explanation on syntax table here.
;; https://www.emacswiki.org/emacs/EmacsSyntaxTable
;; TODO: Read through it and make sure everything here makes sense.
(defvar ats2-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; (*..*) for nested comments.
    (modify-syntax-entry ?\( "() 1n" st)
    (modify-syntax-entry ?\) ")( 4n" st)
    (modify-syntax-entry ?*  ". 23n" st)
    ;; C-like end-of-line comments.
    ;; See https://stackoverflow.com/q/25245469/2682729
    (modify-syntax-entry ?/  "< 1" st)
    (modify-syntax-entry ?/  "< 2" st)
    (modify-syntax-entry ?\n "> " st)
    ;; Strings.
    (modify-syntax-entry ?\" "\"" st)
    ;; Same problem as in Ada: ' starts a char-literal but can appear within
    ;; an identifier.  So we can either default it to "string" syntax and
    ;; let font-lock-syntactic-keywords correct its uses in symbols, or
    ;; the reverse.  We chose the reverse, which fails more gracefully.
    ;; Oh, and ' is also overloaded for '( '{ and '[  :-(
    (modify-syntax-entry ?\' "_ p" st)
    ;;
    (modify-syntax-entry ?\{ "(}" st)
    (modify-syntax-entry ?\} "){" st)
    (modify-syntax-entry ?\[ "(]" st)
    (modify-syntax-entry ?\] ")[" st)
    ;; Skip over @/# when going backward-sexp over @[...], #[...],
    ;; #ident and $ident.
    (modify-syntax-entry ?\@ ". p" st)
    (modify-syntax-entry ?\# ". p" st)
    (modify-syntax-entry ?\$ ". p" st)
    ;; Same thing for macro&meta programming.
    (modify-syntax-entry ?\` ". p" st)
    (modify-syntax-entry ?\, ". p" st)
    ;; Just a guess for now.
    (modify-syntax-entry ?\\ "\\" st)
    ;; TODO: Figure out what these comments are about.
    ;; Handle trailing +/-/* in keywords.
    ;; (modify-syntax-entry ?+ "_" st)
    ;; (modify-syntax-entry ?- "_" st)
    ;; (modify-syntax-entry ?* "_" st)
    ;; Symbolic identifiers are kind of like in SML, which is poorly
    ;; supported by Emacs.  Worse: there are 2 kinds, one where "!$#?" are
    ;; allowed and one where "<>" are allowed instead.  Hongwei, what's that
    ;; all about?
    (dolist (i '(?% ?& ?+ ?- ?. ?: ?= ?~ ?^ ?| ?< ?> ?! ?? ?\;))
      (modify-syntax-entry i "." st))
    st))

(defvar ats2-mode-font-lock-syntax-table
  (let ((st (copy-syntax-table ats2-mode-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    st))

;; Font-lock.

(defface ats-font-lock-metric-face
  '(;; (default :inherit font-lock-type-face)
    (t (:foreground "Wheat" :weight bold)))
  "Face used for termination metrics."
  :group 'ats-font-lock-faces)
(defvar ats-font-lock-metric-face 'ats-font-lock-metric-face)

(defun ats-context-free-search (regexp &optional limit)
  "Use inside a parenthesized expression to find a regexp at the same level."
  (let ((nest-lvl 0) foundp)
    (while (and (not (eobp))
                (or (null limit) (not (> (point) limit)))
                (not (minusp nest-lvl))
                (not (setq foundp
                           (and (zerop nest-lvl)
                                (looking-at regexp)))))
      (cond ((looking-at "(\\|\\[\\|{")
             (incf nest-lvl))
            ((looking-at ")\\|\\]\\|}")
             (decf nest-lvl)))
      (forward-char 1))
    foundp))

(defun ats-font-lock-mark-block ()
  (let ((lines 64))                     ; bit of a hack
    (set-mark (save-excursion (forward-line lines) (point)))
    (forward-line (- lines))))

(defun ats-font-lock-c-code-search (&optional limit)
  (interactive)
  ;; Font-lock mode works on regions that may not be large enough to
  ;; find both {% and %}.  Really, they should be treated like
  ;; comments and put into the syntax table.  Then the syntactic pass
  ;; would take care of C code.  However, there is only room for 2
  ;; kinds of comments in the table, and those are taken.  So the
  ;; keyword pass can try to get them.  But keyword pass doesn't
  ;; handle multiline keywords very well (because of region cutoff).
  ;; We can ignore the limit while searching, but coloration will not
  ;; happen outside the region anyway.  So it's going to be a little
  ;; screwy no matter what.  Not sure what to do about it.
  (setq limit nil)
  (let (begin end)
    (when (re-search-forward "%{" limit t)
      (setq begin (match-beginning 0))
      (when (re-search-forward "%}" limit t)
        (setq end (match-end 0))
        (when (and begin end)
          (store-match-data (list begin end))
          (point))))))

;; TODO: What does the author mean by "static-search"?
(defun ats-font-lock-static-search (&optional limit)
  (interactive)
  (when (null limit) (setq limit (point-max)))
  (let (foundp begin end (key-begin 0) (key-end 0) pt)
    (cl-flet ((store ()
             (store-match-data (list begin end key-begin key-end))))
      ;; attempt to find some statics to highlight and store the
      ;; points beginning and ending the region to highlight.  needs
      ;; to be a loop in order to handle cases like ( foo : type )
      ;; where initially it considers ( .. | .. ) but finds no '|'
      ;; char so it must then go inside and look for sub-regions like
      ;; ": type".
      ;;
      ;; Each branch of the cond must be sure to make progress, the
      ;; point must advance, or else infinite-loop bugs may arise.
      (while (and (not foundp) (< (point) limit))
        (setq key-begin 0 key-end 0)
        (cond
         ((re-search-forward "(\\|:[^=]\\|{\\|[^[:space:].:-]<" limit t)
          (setq pt (setq begin (match-beginning 0)))
          (when pt (goto-char pt))
          (cond
           ;; handle { ... }
           ((looking-at "{")
            (forward-char 1)
            (cond
             ((save-excursion
                (forward-word -1)
                (looking-at "where"))
              ;; except when preceeded by "where" keyword
              (setq pt nil))
             ((re-search-forward "}" limit t)
              (setq end (match-end 0))
              (store)
              (setq pt end)
              (setq foundp t))
             (t
              (setq pt nil))))
           ;; handle ( ... | ... )
           ;; FIXME: insert logic here to ignore this when we detect
           ;; a | due to a case.
           ((looking-at "(")
            (forward-char 1)
            (incf begin)
            (cond
             ((null (ats-context-free-search "|\\|)" limit))
              (setq pt nil))
             ((looking-at "|")
              (setq end (match-end 0))
              (store)
              (setq foundp t))
             ((looking-at ")")
              (setq pt nil)
              ;; no | found so scan for other things inside ( )
              (goto-char (1+ begin)))))
           ;; handle ... : ...
           ((looking-at ":[^=]")
            (forward-char 1)
            (let ((nest-lvl 0) finishedp)
              ;; emacs22 only:
              ;;(ats-context-free-search ")\\|\\_<=\\_>\\|," limit)
              (ats-context-free-search ")\\|[^=]=[^=]\\|,\\|\n\\|\\]" limit)
              (setq begin (1+ begin)
                    end (point)
                    key-begin (1- begin)
                    key-end begin)
              (store)
              (setq foundp t)))
           ((looking-at "[^[:space:].:-]<")
            (forward-char 2)
            (incf begin)
            (cond
             ((re-search-forward ">" limit t)
              (setq end (match-end 0))
              (store)
              (setq pt end)
              (setq foundp t))
             (t
              (setq pt nil))))
           (t
            (setq pt nil)
            (forward-char 1)
            (setq foundp t))))
         (t
          (setq foundp t)
          (setq pt nil)))))
    pt))

(defvar ats-word-keywords
  '("abstype" "abst0ype" "absprop" "absview" "absvtype" "absviewtype" "absvt0ype" "absviewt0ype"
    "and" "as" "assume" "begin" "break" "continue" "classdec" "datasort"
    "datatype" "dataprop" "dataview" "datavtype" "dataviewtype" "do" "dynload" "else"
    "end" "exception" "extern" "extype" "extval" "fn" "fnx" "fun"
    "prfn" "prfun" "praxi" "castfn" "if" "in" "infix" "infixl"
    "infixr" "prefix" "postfix" "implmnt" "implement" "primplmnt" "primplement" "lam"
    "llam" "fix" "let" "local" "macdef" "macrodef" "nonfix" "overload"
    "of" "op" "rec" "scase" "sif" "sortdef" "sta" "stacst"
    "stadef" "stavar" "staload" "symelim" "symintr" "then" "try" "tkindef"
    "type" "typedef" "propdef" "viewdef" "vtypedef" "viewtypedef" "val" "prval"
    "var" "prvar" "when" "where" "for" "while" "with" "withtype"
    "withprop" "withview" "withvtype" "withviewtype"))

(defun wrap-word-keyword (w)
  (concat "\\<" w "\\>"))

(defvar ats-special-keywords
  '("$arrpsz" "$arrptrsize" "$delay" "$ldelay" "$effmask" "$effmask_ntm" "$effmask_exn" "$effmask_ref"
    "$effmask_wrt" "$effmask_all" "$extern" "$extkind" "$extype" "$extype_struct" "$extval" "$lst"
    "$lst_t" "$lst_vt" "$list" "$list_t" "$list_vt" "$rec" "$rec_t" "$rec_vt"
    "$record" "$record_t" "$record_vt" "$tup" "$tup_t" "$tup_vt" "$tuple" "$tuple_t"
    "$tuple_vt" "$raise" "$showtype" "$myfilename" "$mylocation" "$myfunction" "#assert" "#define"
    "#elif" "#elifdef" "#elifndef" "#else" "#endif" "#error" "#if" "#ifdef"
    "#ifndef" "#include" "#print" "#then" "#undef"))

(defun wrap-special-keyword (w)
  (concat "\\" w "\\>"))

(defvar ats-keywords
  (append (list "\\<\\(s\\)?case[\+\*]?\\>")
          (mapcar 'wrap-word-keyword ats-word-keywords)
          (mapcar 'wrap-special-keyword ats-special-keywords)))

;; FIXME: This shouldn't be a global variable?
(defvar ats-whitespace-or-newline "[[:space:]\n]+")

;; Stolen from rust-mode.el
(defun ats-re-word (inner) (concat "\\<" inner "\\>"))
(defun ats-re-grab (inner) (concat "\\(" inner "\\)"))
(defconst ats-re-ident "[[:word:][:multibyte:]_][[:word:][:multibyte:]_[:digit:]]*")
(defun ats-re-item-def (itype)
  (concat (ats-re-word itype) ats-whitespace-or-newline (ats-re-grab ats-re-ident)))

(defvar ats-font-lock-keywords
  ;; FIXME: using preprocessor face for C code for now.
  (append
   '((ats-font-lock-c-code-search (0 font-lock-preprocessor-face t))
     ("\\.<[^>]*>\\." (0 'ats-font-lock-metric-face)) ;; TODO: what does this face do?
     (ats-font-lock-static-search ;; this function isn't working correctly.
      (0 'font-lock-constant-face)
      (1 'font-lock-keyword-face)))

   (list (list (mapconcat 'identity ats-keywords "\\|")
               '(0 'font-lock-keyword-face)))
   (mapcar #'(lambda (x)
               (list (ats-re-item-def (car x))
                     1 (cdr x)))
           '(("datatype" . font-lock-type-face)
             ("implement" . font-lock-function-name-face)
             ("fun" . font-lock-function-name-face)
             ("val" . font-lock-function-name-face)
             ("and" . font-lock-function-name-face)))))

(defvar ats-font-lock-syntactic-keywords
  '(("(\\(/\\)" (1 ". 1b"))             ; (/ does not start a comment.
    ("/\\(*\\)" (1 ". 3"))              ; /* does not start a comment.
    ("\\(/\\)///" (0 "< nb"))           ; Start a comment with no end.
    ;; Recognize char-literals.
    ("[^[:alnum:]]\\('\\)\\(?:[^\\]\\|\\\\.[[:xdigit:]]*\\)\\('\\)"
     (1 "\"'") (2 "\"'"))
    ))

(define-derived-mode c/ats2-mode c-mode "C/ATS"
  "Major mode to edit C code embedded in ATS code."
  (unless (local-variable-p 'compile-command)
    (setq-local compile-command
                (let ((file buffer-file-name))
                  (format "patsopt -tc -d %s" file)))
    (put 'compile-command 'permanent-local t))
  (setq indent-line-function 'c/ats2-mode-indent-line))

(defun c/ats2-mode-indent-line (&optional arg)
  (let (c-start c-end)
    (save-excursion
      (if (re-search-backward "%{[^$]?" 0 t)
          (setq c-start (match-end 0))
        (setq c-start 0)))
    (save-excursion
      (if (re-search-forward "%}" (point-max) t)
          (setq c-end (match-beginning 0))
        (setq c-start (point-max))))
    (save-restriction
      ;; restrict view of file to only the C code for the benefit of
      ;; the cc-mode indentation engine.
      (narrow-to-region c-start c-end)
      (c-indent-line arg))))

;;;###autoload
(define-derived-mode ats2-mode prog-mode "ATS2"
  "Major mode to edit ATS2 source code."
  (setq-local font-lock-defaults
              '(ats-font-lock-keywords nil nil ((?_ . "w") (?= . "_")) nil
                                       (font-lock-syntactic-keywords . ats-font-lock-syntactic-keywords)
                                       (font-lock-mark-block-function . ats-font-lock-mark-block)))
  (setq-local comment-start "(*")
  (setq-local comment-continue " *")
  (setq-local comment-end "*)")
  (setq indent-line-function 'tab-to-tab-stop)
  (setq tab-stop-list (loop for x from 2 upto 120 by 2 collect x))
  (setq indent-tabs-mode nil)
  (local-set-key (kbd "RET") 'newline-and-indent-relative)
  (unless (local-variable-p 'compile-command)
    (setq-local compile-command
                (let ((file buffer-file-name))
                  (format "patsopt -tc -d %s" file)))
    (put 'compile-command 'permanent-local t))
  ;; FIXME: This seems like a bad idea. We should replace it with a proper
  ;; variable so that it can be modified externally.
  (local-set-key (kbd "C-c C-c") 'compile)
  (cond
   ;; Emacs 21
   ((and (< emacs-major-version 22)
         (not xemacsp))
    (pushnew '("\\(syntax error: \\)?\\([^\n:]*\\): \\[?[0-9]*(line=\\([0-9]*\\), offs=\\([0-9]*\\))\\]?" 2 3 4)
             compilation-error-regexp-alist))
   ;; Emacs 22+ has an improved compilation mode
   ((and (>= emacs-major-version 22)
         (not xemacsp))
    (pushnew '(ats "\\(syntax error: \\)?\\([^\n:]*\\): \\[?[0-9]*(line=\\([0-9]*\\), offs=\\([0-9]*\\))\\]?\\(?: -- [0-9]*(line=\\([0-9]*\\), offs=\\([0-9]*\\))\\)?" 2 (3 . 5) (4 . 6))
             compilation-error-regexp-alist-alist)
    (pushnew 'ats compilation-error-regexp-alist))
   ;; XEmacs has something different, to be contrary
   (xemacsp
    (pushnew '(ats ("\\(syntax error: \\)?\\([^\n:]*\\): \\[?[0-9]*(line=\\([0-9]*\\), offs=\\([0-9]*\\))\\]?" 2 3 4))
             compilation-error-regexp-alist-alist)
    (unless (eql 'all compilation-error-regexp-systems-list)
      (pushnew 'ats compilation-error-regexp-systems-list))
    (compilation-build-compilation-error-regexp-alist)
    (message "WARNING! XEMACS IS DEAD AND DEPRECATED."))))


(defun newline-and-indent-relative ()
  (interactive)
  (newline)
  (indent-to-column (save-excursion
                      (forward-line -1)
                      (back-to-indentation)
                      (current-column))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.[dsh]ats\\'" . ats2-mode))

(provide 'ats2-mode)
