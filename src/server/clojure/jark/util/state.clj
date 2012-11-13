(ns jark.util.state
  (:refer-clojure :exclude [get update]))
  

(def state (atom {}))

(defn get [key]
  (@state key))

(defn update [key val]
  (swap! state assoc key val))
