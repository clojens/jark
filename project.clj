(defproject jark "0.5.0"
  :description "Tool to interact with a persistent JVM"
  :dependencies [[org.clojure/clojure           "1.2.1"]
                 [org.clojure/java.classpath    "0.1.0"]
                 [org.clojure/data.json         "0.1.1"]
                 [org.clojure/tools.namespace   "0.1.0"]
                 [server-socket                 "1.0.0"]
                 [swank-clojure                 "1.4.0"]
                 [org.clojure/tools.nrepl       "0.0.5"]
                 [clj-stacktrace                "0.2.5"]]

  :source-path "src/server/clojure"
  :java-source-path "src/server/java"
  :java-options {:debug "true"}
  :aot [jark.server
        jark.plugin])
