---
layout: jark
---

# Roadmap


## 0.5 (plugins)

* Upgrade to the latest nREPL protocol
* Trap System exits
* Cookie-based authentication
* Named VM connections 
* Scripts can specify a VM that they can be run on (#!/usr/bin/env jark [--name])
* Interactive stacktraces in the repl
* More jark REPL commands ..
* Multiline support in REPL (sexp parser)
* Fully integrated lein plugin.

<hr>

## 0.4 (platforms) 

* Support jark on common OS platforms (Windows, GNU/Linux, Mac)
* Rewrite jark-client in OCaml to generate native binaries. Has minimum runtime dependencies.
* Server-side plugins 
* Enhanced REPL
* License: GPLv2 (client) 
* Release : 13 March 2012

<hr>

## 0.3 (nREPL protocol)

* jark-nrepl-server that implements the nrepl protocol (replaces nailgun server)
* Proof-of-concept nrepl-client written in python (replaces the nailgun client)
* Rich client REPL (jark repl)
** support jark commands within the repl
** completions - filenames and symbols on remote JVM
** Handle *out*, *err* and value coming from remote JVM
* License: EPL (that of clojure's)
* Release : 1 April 2011


## 0.2 (Scripting)

* Start and connect to multiple JVM instances 
* Scripting with jark (Connect to a running JVM or start one when running clojure scripts)
* Vimclojure integration
* Vm utilities - gc, threads, stats

## 0.1 (proof of concept)

* Nailgun-based system to manage classpaths and namespaces on a persistent JVM
* Add classpaths dynamically
* Install clojure packages from maven repositories with ease (cljr integration)
* Lookup clojure documentation on the web
* Command-line interface to NFA (Namespace Function Args)
* Build only on GNU/Linux
* License   : Apache License 2
* Release   : 7 March 2011