;;; cynojure-swank extension

(swank.commands/defslimefn resolve-symbol [sym ns-name]
 (when-let [the-class (ns-resolve (find-ns (symbol ns-name))
				  (symbol sym))]
   (.getName the-class)))
