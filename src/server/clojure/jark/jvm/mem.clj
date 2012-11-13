(ns jark.jvm.mem)

(defn mb [bytes]
  (int (/ bytes (* 1024.0 1024.0))))

(defn to-mb [x] (str (mb x) " MB"))

(defn runtime []
  (. Runtime getRuntime))

(defn total-mem []
  (. (runtime) totalMemory))

(defn free-mem []
  (. (runtime) freeMemory))

(defn used-mem []
  (- (total-mem) (free-mem)))

(defn gc-recur []
  (let [rt (runtime)]
    (loop [m1 (used-mem)
	   m2 1000000000000
	   i 0]
	(. rt runFinalization)
	(. rt gc)
	(. Thread yield)
	(if (and (< i 500)
          (< m1 m2))
          (recur (used-mem) m1 (inc i))))))

(defn run-gc  []
  (let [before (used-mem)]
    (loop [i 0]
      (gc-recur)
      (if (< i 4)
        (recur (inc i))))
    (str "Freed " (mb (- before (used-mem))) " MB of memory")))

