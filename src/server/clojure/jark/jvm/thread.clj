(ns jark.jvm.thread
  (:gen-class)
  (:use [clojure.string :only (join split)])
  (:require [clj-stacktrace.core :as st]
            [jark.util.pp :as pp])
  (:import (java.lang.management RuntimeMXBean ManagementFactory)))

(defn daemon? [thread]
  (.isDaemon thread))

(defn daemon? [thread]
  (.isDaemon thread))

(defn deadlocked? [thread] false)

(defn cpu-time [bean thread]
  (.getThreadCpuTime bean (.getThreadId thread)))

(defn cpu [bean thread]
  (let [threads (.dumpAllThreads bean false false)
        total   (reduce + (map #(cpu-time bean %) threads))
        my      (cpu-time bean thread)
        percent (* (float (/ my total)) 100)]
    (format "%.3f" percent)))

(defn stacks [thread]
  (map #(st/parse-trace-elem %)
       (seq (.getStackTrace thread))))

(defn print-stacks [thread tab-width]
  (println (.getThreadName thread))
  (pp/print-table
     (map
       #(if (contains? % :clojure)
          (vector "cljr"                  
                  (str (:fn %) (when (:anon-fn true) "/anon"))
                  (:ns %)
                  (str (:file %) ":" (:line %))
                  (.getThreadId thread))
          (vector "java"
                  (:method %)
                  (:class %)
                  (str (:file %) ":" (:line %))
                  (.getThreadId thread)))
        
      (stacks thread)) (Integer. tab-width)))

