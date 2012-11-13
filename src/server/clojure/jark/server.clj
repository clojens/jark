(ns jark.server
  (:gen-class)
  (:require [jark.jvm.sys :as jvm.sys]
            [jark.util.ns :as util.ns]
            [jark.util.pp :as util.pp]
            [jark.util.state :as util.state]
            [clojure.tools.nrepl :as nrepl])
  (:use server.socket)
  (:use clojure.data.json))

(defn version [] "0.4.2")

(def dispatch
     (partial util.ns/dispatch-module-cmd util.pp/pp-form))

(def dispatch-json
     (partial util.ns/dispatch-module-cmd json-str))

(defn active-ip-address
  []
  (last (jvm.sys/ip-addresses)))

(defn stat []
  {"PID"  (jvm.sys/pid)
   "host" (active-ip-address)
   "port" (util.state/get :port)
   "clojure-version" (clojure-version)
   "server-version"  (version)})

(defn pid []
  (jvm.sys/pid))

(defn remote-server? [] true)

(defn -main [port]
  (create-repl-server (jvm.sys/random-port))
  (nrepl/start-server (Integer. port))
  (util.state/update :port (Integer. port))
  (System/setSecurityManager nil))
