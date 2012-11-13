(ns jark.plugin.ns
  (:gen-class)
  (:require [jark.util.ns :as util.ns]
            [jark.jvm.classpath :as jvm.cp]
            [jark.util.state :as util.state]
            [jark.util.pp :as pp])
  (:refer-clojure :exclude [list find alias load methods])
  (:import (java.io File FileNotFoundException)
           (com.stuartsierra ClasspathManager)))

(defn list
  "List all namespaces in the classpath. Optionally takes a namespace prefix"
  ([]
   (sort (util.ns/namespaces)))
  ([module]
   (util.ns/starting-with (str module "."))))

(defn find
  "Find all namespaces containing the given name"
  ([] "Usage: jark ns find PATTERN")
  ([module]
     (util.ns/containing-str module)))

(defn load
  "Loads the given clj file, and adds relative classpath"
  ([] "Usage: jark ns load FILE")
  ([file]
     (let [basename (.getParentFile (File. file))]
       (jvm.cp/add (.toString basename)))
     (load-file file)))

(defn run
  "Runs a given java class containing main static method"
  [& args]
  (ClasspathManager/main (into-array args)))

(defn alias
  "Show or set  alias for the given namespace"
  ([] (util.state/get :ns-alias))
  ([namespace] (alias (util.state/get :ns-alias))) 
  ([namespace alias]
     (let [aliases (into (util.state/get :ns-alias) {alias namespace})]
     (util.state/update :ns-alias aliases)
     (str namespace " is aliased to " alias))))

(defn methods [object]
  (pp/print-table (sort (set (map
                              #(vector "" (.getName %) (.getReturnType %))
                              (set (.getMethods (type 'a))))))
                  26))
