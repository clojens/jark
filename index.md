---
layout: jark
---

# About 

Startup time of the JVM is too slow and therefore the command-line applications launching it are slow as well. There are tools like [Nailgun](http://www.martiansoftware.com/nailgun/) that partly solve the problem. However, there isn't a tool that is Clojure-aware, secure and extensible.

Jark helps run clojure programs on the JVM, interactively and remotely using the nREPL protocol. It has 2 components - a client written in OCaml and a server written in Clojure/Java. The client is compiled to native code and is extremely tiny (~200KB). 

The system is designed to be

* Interactive 
* Lightweight
* OS agnostic
* Extensible 
* Secure
* Embeddable (Server)
* Clojure-aware
