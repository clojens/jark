
# jark

Jark is a tool to run clojure code on the JVM, interactively and remotely.
It has 2 components - a client written in OCaml and a server written in Clojure/Java. The client is compiled to native code and is extremely tiny (~300KB). 
The client uses the nREPL protocol to transfer clojure data structures over the wire. 

## BUILD

### Client

Install opam from http://opam.ocamlpro.com/

    opam switch 3.12.1
    opam install guts ocaml-nrepl-client ANSITerminal ledit-sexp
    cp dist/bin/jark-`uname`-`uname -m` PATH

### Server 

Install lein

    lein uberjar


## USAGE

Add dependency `[jark "0.5.0"]` to project.clj

    jark -cp lib/* server start
    jark PLUGIN COMMAND ARGS
    e.g jark cp list
        jark thread list 

## COMMUNITY

Mailing list: https://groups.google.com/group/clojure-jark  
    
Catch us on #jark on irc.freenode.net

## AUTHORS:
Martin DeMello
Abhijith Gopal
Isaac Praveen 

Contributors:

* Lucas Stadler  

## Thanks

* Abhijith Gopal
* Ambrose Bonnaire Sergeant
* Chas Emerick (for nREPL)
* Phil Hagelberg (for Leiningen)
* Rich Hickey (for Clojure)


## License

Copyright © 2012 Martin DeMello and Isaac Praveen

Licensed under the GPLv2
