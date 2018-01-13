(require 'boot.repl)

(swap! boot.repl/*default-dependencies*
       concat '[[cider/cider-nrepl "0.15.0-snapshot"]])

(swap! boot.repl/*default-middleware*
       conj 'cider.nrepl/cider-middleware)
