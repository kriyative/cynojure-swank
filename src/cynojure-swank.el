;;; cynojure-swank extensions

(defvar javadoc-alist
  '(("^\\(java[x]?\.\\|org\.ietf\.\\|org\.omg\.\\|org\.w3c\.\\|org\.xml\.\\)" .
     "file://opt/java/docs/api/")))

(defun javadoc-root (sym)
  (let ((m (find-if (lambda (x) (string-match (car x) sym)) javadoc-alist)))
    (when m (cdr m))))

(defun trim-trailing-char (str ch)
  (let ((len (length str)))
    (if (and (< 0 len) (eq (aref str (1- len)) ch))
	(substring str 0 (1- len))
      str)))

(defun slime-javadoc (class-name)
  "Get JavaDoc documentation on Java class at point."
  (interactive (list
                (cond
                 ((slime-connected-p)
		  (or (slime-eval
		       (list 'resolve-symbol
			     (first
			      (split-string (trim-trailing-char (substring-no-properties
								 (symbol-name 
								  (symbol-at-point)))
								?.)
					    "/"))
			     (slime-current-package)))
		      (symbol-name (slime-read-symbol-name "JavaDoc info for: "))))

                 ((ignore-errors (mark))
                  (buffer-substring-no-properties (region-beginning) (region-end)))

                 (t (symbol-name (symbol-at-point))))))
  (or class-name (error "No symbol given"))
  (let* ((root (and class-name (javadoc-root class-name)))
         (dots-to-slashes (subst-char-in-string ?. ?/ class-name))
         (canon-class-name (subst-char-in-string ?$ ?. dots-to-slashes)))
    (if (and root canon-class-name)
        (browse-url (concat root canon-class-name ".html"))
      (message "No javadoc found for %s" class-name))))

(provide 'cynojure-swank)
