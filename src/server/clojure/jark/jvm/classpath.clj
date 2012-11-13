(ns jark.jvm.classpath
  (:gen-class)
  (:import (java.net URL URLClassLoader))
  (:import (java.lang.reflect Method))
  (:import (java.io File))
  (:refer-clojure :exclude [list])
  (:use clojure.java.classpath)
  (:import (java.lang.management RuntimeMXBean ManagementFactory)))

(defn list []
  (map (memfn getPath) (.getURLs (ClassLoader/getSystemClassLoader))))

(defn exists?
  ([path]
   (exists? (list) path))

  ([cp path]
   (not (empty? (filter #(. (str %) contains path) cp)))))

(defn add [file]
  (let [#^URL url   (.. (File. file) toURI toURL) 
        cls         (. (URLClassLoader. (into-array URL [])) getClass) 
        acls        (into-array Class [(. url getClass)]) 
        aobj        (into-array Object [url]) 
        #^Method m  (. cls getDeclaredMethod "addURL" acls)]
    (doto m
      (.setAccessible true) 
      (.invoke (ClassLoader/getSystemClassLoader) aobj))
    nil))

(defn add-unless-exists [jar]
  (if (exists? jar)
    (println (str jar " already exists in classpath"))
    (do
      (add jar)
      (println (str "Added jar " jar)))))

(defn file? [path]
  (.isFile (File. path)))

(defn dir? [path]
  (.isDirectory (File. path)))

(defn jar? [path]
  (and (file? path) (clojure.java.classpath/jar-file? (File. path))))

(defn list-jars [path]
  (when (dir? path)
    (filter #(jar-file? (File. %)) (map (memfn getAbsolutePath) (file-seq (File. path))))))
