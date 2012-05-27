(ns cynojure-swank
  (:use swank.commands))

;;; cynojure-swank extension

(defslimefn resolve-symbol [sym ns-name]
  (if-let [the-ns (find-ns (symbol ns-name))]
    (when-let [the-class (ns-resolve the-ns (symbol sym))]
      (.getName ^Class the-class))))
