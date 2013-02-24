---
layout: jark
---

## Building the client for different Architectures

### Compiling client on MacOSX/Linux

Dependencies: OCaml >= 3.12

Install findlib

{% highlight bash %}
brew install https://github.com/toots/homebrew/raw/master/Library/Formula/ocaml-findlib.rb  (on macOSX)
apt-get install ocaml-findlib (Debian/Ubuntu)
{% endhighlight %}

Clone the jark repository and compile

{% highlight bash %}
git clone https://github.com/icylisper/jark.git
cd jark-client
make deps
export PATH=$PATH:`PWD`/deps/bin
make 
cp build/jark-0.4.0-$(uname)$(uname -m)/jark <PATH>
{% endhighlight %}

### Cross-compiling client for Win32 on Debian/Ubuntu

{% highlight bash %}
apt-get install mingw32-ocaml
git clone https://github.com/icylisper/jark-client.git
cd jark-client 
git checkout win32
make deps-win32
make exe
# generates build/Win32/jark.exe
{% endhighlight %}
