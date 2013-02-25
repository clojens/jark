---
layout: jark
---

## Getting Started

Download the appropriate binary for your Architecture from [here](/jark/download.html)
   
    ;Add [jark "0.4.3"] to project.clj 
    (ns your.namespace
      (:require [clojure.tools.nrepl :as nrepl]))
    (nrepl/start-server 9000)

And then use the jark client to connect it and execute a plugin or namespace. For example:

    jark -h HOST -p PORT server stat

Alternatively, you can add the application-specific jars to classpath and start the server.

    cd your-lein-project
    # Add [jark "0.4.3"] to project.clj 
    lein deps
    jark -cp lib/*:* server start

We can start multiple servers on different ports


    # project1
    jark -cp lib/*:* -p 9001 server start 
    # project2
    jark -cp lib/*:* -p 9002 server start 

Default HOST is localhost and default port is 9000

    jark [-h HOST -p PORT] cp add <DIR or JAR>
    jark [-h HOST -p PORT] cp list
    jark [-h HOST -p PORT] vm stat
    jark [-h HOST -p PORT] vm threads
    jark [-h HOST -p PORT] ns find <PATTERN>
    jark [-h HOST -p PORT] ns load <CLJ-FILE>
    jark [-h HOST -p PORT] repl
    ...

Any clojure function can be run from the command line. 

    jark <NAMESPACE> <FUNCTION> <ARGS>

Start swank and connect via SLIME

    jark swank start [4005]
    # M-x slime-connect REMOTE-IP PORT

## Command line options:

    $ jark
    usage: jark OPTIONS server|repl|<plugin>|<namespace> [<command>|<function>] [<args>]
    OPTIONS:
       -F  --force-install
       -S  --show-config
       -c  --clojure-version (1.3.0)
      -cp  --classpath
       -d  --debug
       -e  --eval
       -f  --config-file
       -h  --host (localhost)
       -i  --install-root ($HOME/.cljr)
       -j  --jvm-opts (-Xms256m -Xmx512m)
       -o  --output-format json|plain (plain)
       -p  --port (9000)
       -s  --server-version (0.4.0)
       -v  --version
       -w  --http-client (wget)

To see available server plugins: `jark plugin list`
To see commands for a plugin: `jark <plugin>`

## REPL

Now, launch a repl and write some clojure!

    jark [-h HOST -p PORT] repl
    user>> (defn add [x y] (let [s (+ x y)] (println s) s)) 
    => #'user/add
    user>> (add 2 3)
    5
    => 5

Notice that the REPL prints the returned value, prefixed by '=>'.

### REPL Commands

REPL command is a cool feature. Below is the complete list of REPL commands:

    REPL Commands:
    /clear
    /cp [list add]
    /debug [true false]
    /inspect var
    /ns namespace
    /readline [true false]
    /server [version info]
    /vm [info stat]

Switch on/off the nREPL debug-mode

    user>> /debug on
    debug is ON
    user>> (+ 2 2)
    put : (+ 2 2)
    got : {'status': 'done', 'ns': 'user', 'id': 'localhost:9000-repl', 'value': '4\n'}
    4
    user>> /debug off

### REPL keyboard shortucts

*Line edit (emacs-style)*  

|Kill-line|C-k|  
|backward-char|C-b|  
|backward-delete-char|C-h|  
|backword-word|M-b|  
|beginning-of-line|C-a|  
|capitalize-word|M-c|  
|clear|C-l|  
|delete-char-or-end-of-file|C-d|  
|downcase-word|M-l|  
|end-of-line|C-e|  
|forward-char|C-f|  
|forward-word|M-f|  
|interrupt|C-c|  
|kill-word|M-d|  
|transpose-chars|C-t|  
|unix-line-discard|C-u|  
|yank|C-y|  

*History*  

|beginning-of-history|M-<|  
|end-of-history|M->|  
|next-history|C-n|  
|previous-history|C-p|  
|reverse-search-history|C-r|  

*Completions*

|Complete-file-name|C-i|  

Caveat: The jark REPL does not work on Windows, yet.

## Scripting with jark

**file: factorial**  

{% highlight clojure %}
#!/Usr/bin/env jark

(ns factorial)

(defn compute [n]
   (apply * (take n (iterate inc 1))))

(println "Factorial of 10 :" (compute 10))
{% endhighlight %}

And then run it as:
    $ ./factorial
    => Factorial of 10  : 3628800

Jark also takes input from STDIN. One can pipe any expression to <code>jark</code>.

     $ echo "(+ 2 2)" | jark -e
     $ cat factorial | jark -e 
