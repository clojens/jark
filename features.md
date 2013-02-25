---
layout: jark
---
## Features


The following are some of the salient features of jark.

### Remote Clojure REPL
 REPL commands to modify classpath, inspect, debug and a lot more

### Command-line interface to Clojure programs

    jark -e "(+ 2 2)"
    echo "(+ 2 2)" | jark -e 
    jark -e < file.clj
    cat file.clj | jark -e


Any clojure function can be called from the command-line if all the arguments to the function are strings. `jark NAMESPACE FUNCTION ARGS*`
All Jark commands output JSON for parsing when passed a `--json` option
`jark --eval CLOJURE-EXPRESSION. --eval` takes input from STDIN. For example, any of the following work.

### Scripting

    #!/usr/bin/env jark -h HOST -p PORT
    (clojure code ...)

Standalone Clojure scripts can be written using the #! operator. 

### Remote JVM Management  

Monitor JVM performance `jark vm stat`  
Dynamically add classpath(s) `jark cp add`  
Run on-demand Garbage collection `jark vm gc`  
View thread info `jark thread list`  
View thread stacktrace `jark thread stack <PATTERN>`  

### Embeddable Server
 
    ;Add [jark "0.4.3"] to project.clj 
    (require 'clojure.tools.jark.server)
    (clojure.tools.jark.server/start PORT)

Alternatively, you can add the application-specific jars to classpath and start the server.

    cd your-lein-project
    # Add [jark "0.4.3"] to project.clj 
    lein deps
    jark -cp lib/*:* server start

### Plugins

Server-side plugin system.  
All plugins are written in Clojure

    jark plugin list
    => ns
       cp
       vm
       swank