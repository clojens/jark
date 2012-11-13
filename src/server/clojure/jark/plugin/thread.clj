(ns jark.plugin.thread
  (:gen-class)
  (:require [jark.util.pp :as pp]
            [jark.jvm.thread :as thread])
  (:refer-clojure :exclude [list])
  (:import (java.lang.management RuntimeMXBean ManagementFactory)))


(defn stat
  "Display JVM runtime stats"
  []
  (let [mx      (ManagementFactory/getRuntimeMXBean)
        gmxs    (ManagementFactory/getGarbageCollectorMXBeans)
        cmx     (ManagementFactory/getCompilationMXBean)
        omx     (ManagementFactory/getOperatingSystemMXBean)
        props   {"Load Average"      (.getSystemLoadAverage omx)
                 "JIT Name"          (.getName cmx)
                 "Processors"        (.getAvailableProcessors omx)
                 "Uptime"            (jvm.sys/uptime mx)
                 "PID"               (jvm.sys/pid)
                 "PWD"               (. (java.io.File. ".") getCanonicalPath)}]
    props))


(defn list
  "Display threads"
  ([tab-width]
     (let [bean  (ManagementFactory/getThreadMXBean)
           threads  (.dumpAllThreads bean false false)]
       (pp/print-table
        (map
         #(vector (.getThreadId %)
                  (.getThreadName %)
                  (.toString (.getThreadState %))
                  (thread/cpu bean %))
         threads) (Integer. tab-width))))
  ([] (list 22)))

(defn stacks
  "Display stacktrace for all threads"
  [tab-width]
  (let [bean  (ManagementFactory/getThreadMXBean)
        threads  (.dumpAllThreads bean false false)]
    (doseq [t threads]
      (thread/print-stacks t tab-width))))

(defn stack
  "Display stacktrace for given thread id"
  ([thread-id tab-width]
     (let [bean   (ManagementFactory/getThreadMXBean)
           threads  (.dumpAllThreads bean false false)]
       (doseq [t threads]
         (when  (.startsWith (.getThreadName t) thread-id)
           (thread/print-stacks t tab-width)))))
  ([thread-id] (stack thread-id 26))
  ([] (stacks 22)))
     
     
    
        
  
      
