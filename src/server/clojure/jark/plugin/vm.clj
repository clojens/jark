(ns jark.plugin.vm
  (:gen-class)
  (:require [jark.jvm.sys :as jvm.sys]
            [jark.jvm.mem :as jvm.mem])
  (:import (java.lang.management RuntimeMXBean ManagementFactory)))

(defn gc
  "Run Garbage Collection on the JVM"
  []
  (jvm.mem/run-gc))

(defn stat
  "Display JVM runtime stats"
  []
  (let [mx      (ManagementFactory/getRuntimeMXBean)
        gmxs    (ManagementFactory/getGarbageCollectorMXBeans)
        cmx     (ManagementFactory/getCompilationMXBean)
        omx     (ManagementFactory/getOperatingSystemMXBean)
        props   {"Load Average"      (.getSystemLoadAverage omx)
                 "Heap Mem Total"    (jvm.mem/to-mb (jvm.mem/total-mem))
                 "Heap Mem Used"     (jvm.mem/to-mb (jvm.mem/used-mem))
                 "Heap Mem Free"     (jvm.mem/to-mb (jvm.mem/free-mem))
                 "GC Interval"       (map #(str (.getName %) ":" (.getCollectionTime %)) gmxs)
                 "JIT Name"          (.getName cmx)
                 "Processors"        (.getAvailableProcessors omx)
                 "Uptime"            (jvm.sys/uptime mx)
                 "PID"               (jvm.sys/pid)
                 "PWD"               (. (java.io.File. ".") getCanonicalPath)}]
    props))

(defn properties
  "Display JVM System information"
  []
  (sort (map #(.toString %) (System/getProperties))))
