---
layout: jark
---

## Getting Started

{% highlight bash %}
curl -L https://github.com/downloads/icylisper/jark-client/jark-0.4.3-`uname`-`uname -m`.bin > jark
chmod +x jark
{% endhighlight %}
or find the appropriate client binary from [downloads page](/jark/download.html)
   
{% highlight clojure %}
;Add [jark "0.4.3"] to project.clj 
(ns your.namespace
  (:require [clojure.tools.nrepl :as nrepl]))
(nrepl/start-server 9000)
{% endhighlight %}

And then use the jark client to connect it and execute a plugin or namespace. For example:

{% highlight bash %}
jark -h HOST -p PORT server stat
{% endhighlight %}

Alternatively, you can add the application-specific jars to classpath and start the server.

{% highlight bash %}
cd your-lein-project
# Add [jark "0.4.3"] to project.clj 
lein deps
jark -cp lib/*:* server start
{% endhighlight %}

We can start multiple servers on different ports

{% highlight bash %}
# project1
jark -cp lib/*:* -p 9001 server start 
# project2
jark -cp lib/*:* -p 9002 server start 
{% endhighlight %}

Default HOST is localhost and default port is 9000

{% highlight bash %}
jark [-h HOST -p PORT] cp add <DIR or JAR>
jark [-h HOST -p PORT] cp list
jark [-h HOST -p PORT] vm stat
jark [-h HOST -p PORT] vm threads
jark [-h HOST -p PORT] ns find <PATTERN>
jark [-h HOST -p PORT] ns load <CLJ-FILE>
jark [-h HOST -p PORT] repl
...
{% endhighlight %}

Any clojure function can be run from the command line. 

{% highlight bash %}
jark <NAMESPACE> <FUNCTION> <ARGS>
{% endhighlight %}

Start swank and connect via SLIME

{% highlight bash %}
jark swank start [4005]
# M-x slime-connect REMOTE-IP PORT
{% endhighlight %}


## Command line options:

{% highlight bash %}
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

To see available server plugins:
       jark plugin list
To see commands for a plugin:
       jark <plugin>
{% endhighlight %}
