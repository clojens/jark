(ns jark.plugin.cp
  (:require [jark.jvm.classpath :as jvm.cp])
  (:use [clojure.string :only (split)])
  (:refer-clojure :exclude [list])
  (:import (java.net URL URLClassLoader))
  (:gen-class))

(defn ls
  "Lists all the entries in CLASSPATH"
  []
  (jvm.cp/list))

(defn list
  "Lists all the entries in CLASSPATH"
  []
  (jvm.cp/list))

(defn exists?
  "Checks if the given entry exists in CLASSPATH"
  [path]
  (jvm.cp/exists? path))

(defn add
  "Adds an entry to CLASSPATH"
  ([] "Usage: jark cp add PATH(s)")
  ([#^String path]
   (jvm.cp/add path)
   (cond
     (jvm.cp/jar? path) (jvm.cp/add path)
     (jvm.cp/dir? path) (let [jars (jvm.cp/list-jars path)]
                          (if (empty? jars)
                            (println "Warn: No jars found in directory. Adding only top-level directory")
                            (doseq [jar (jvm.cp/list-jars path)]
                              (jvm.cp/add-unless-exists jar))))
     :else "Not a valid path")))

