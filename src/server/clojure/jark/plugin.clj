(ns jark.plugin
  (:gen-class)
  (:require [jark.jvm.classpath :as jvm.cp]
            [jark.util.ns :as util.ns])
  (:import (java.io File FileNotFoundException))
  (:refer-clojure :exclude [list find alias load]))

(defn list
  "List all loaded plugins"
  []
  (util.ns/plugins))

(defn load
  "Load a plugin"
  [plugin]
  (let [basename (.getParentFile (File. plugin))]
    (jvm.cp/add (.toString basename)))
  (load-file plugin))
