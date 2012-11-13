(ns jark.jvm.sys
  (:gen-class)
  (:import (java.net ServerSocket NetworkInterface))
  (:import (java.net ServerSocket))
  (:use [clojure.string :only (split)])
  (:refer-clojure :exclude [list])
  (:import (java.lang.management RuntimeMXBean ManagementFactory)))

(defn divmod [m n] [(quot m n) (rem m n)])

(defn fmt-time [ms]
  (let [[r ms] (divmod ms 1000)
        [r s ] (divmod  r 60)
        [r m ] (divmod  r 60)
        [d h ] (divmod  r 24)]
    (str d "d " h "h " m "m " s "." ms "s")))

(defn uptime [mx]
  (let [uptime    (.getUptime mx)
        uptime-ms (str (.toString uptime) "ms")]
    (str uptime-ms " (" (fmt-time uptime) ")")))

(defn pid []
  (or
   (first (.. ManagementFactory
              (getRuntimeMXBean)
              (getName)
              (split "@")))
   (System/getProperty "pid")))

(defn ip-addresses []
  (->> (java.net.NetworkInterface/getNetworkInterfaces)
       enumeration-seq
       (map bean)
       (filter (complement :loopback))
       (mapcat :interfaceAddresses)
       (map #(.. % (getAddress) (getHostAddress)))))

(defn random-port []
  (let [s     (new ServerSocket 0)
        port  (.getLocalPort s)]
    (.close s)
    port))
