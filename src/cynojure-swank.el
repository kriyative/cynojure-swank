;;; cynojure-swank extensions

(defvar javadoc-alist
  '(("^\\(java[x]?\.\\|org\.ietf\.\\|org\.omg\.\\|org\.w3c\.\\|org\.xml\.\\)" .
     "file://opt/java/docs/api/")))

(defun javadoc-root (sym)
  (let ((m (find-if (lambda (x) (string-match (car x) sym)) javadoc-alist)))
    (when m (cdr m))))

(defun trim-trailing-dot (str)
  (let ((len (length str)))
    (if (and (< 0 len) (eq (aref str (1- len)) ?.))
	(substring-no-properties str 0 (1- len))
      str)))

(defun slime-javadoc (symbol-name)
  "Get JavaDoc documentation on Java class at point."
  (interactive (list (slime-read-symbol-name "JavaDoc info for: ")))
  (or symbol-name (error "No symbol given"))
  (let ((class-name (slime-eval
                     (list 'resolve-symbol
                           (first
                            (split-string (trim-trailing-dot symbol-name)
                                          "/"))
                           (slime-current-package)))))
    (if class-name
        (browse-url
         (concat (javadoc-root class-name)
                 (subst-char-in-string ?$
                                       ?.
                                       (subst-char-in-string ?.
                                                             ?/
                                                             class-name))
                 ".html"))
      (message "No javadoc found for %s" symbol-name))))

(provide 'cynojure-swank)
