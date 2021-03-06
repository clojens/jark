
VERSION = 0.4.4

ARCH = $(shell uname)-$(shell uname -m)

PREFIX=debian/jark/usr

JARK_BIN = dist/bin/jark-$(VERSION)-$(ARCH).bin

OLIB = /usr/lib/ocaml
WLIB = /usr/i586-mingw32msvc/lib/ocaml/
WGET = wget --no-check-certificate -O -

TOP = $(shell pwd)
LEDIT = lib/ledit
GUTS  = lib/guts
NREPL = lib/nrepl

LIB = $(TOP)/lib
ANSITERM = lib/ansiterminal/_build
CAMLP5 = /usr/lib/ocaml/camlp5
CAMLP5DEP = $(TOP)/lib/camlp5

WIN_LIBS = $(WLIB)/unix,$(WLIB)/bigarray,$(WLIB)/str,$(WLIB)/nums,$(CAMLP5)/camlp5,$(CAMLP5)/gramlib,$(ANSITERM)/ANSITerminal,$(LEDIT)/ledit

LIBS = unix,bigarray,str,nums,$(CAMLP5)/camlp5,$(CAMLP5)/gramlib,$(TOP)/$(ANSITERM)/ANSITerminal,$(TOP)/$(LEDIT)/ledit

OCAMLBUILD = ocamlbuild -j 2 -quiet  -I src -I $(GUTS) -I $(NREPL) -lflags -I,/usr/lib/ocaml/pcre  \
           -lflags -I,$(CAMLP5)  -lflags -I,$(TOP)/$(ANSITERM) -cflags -I,$(TOP)/$(ANSITERM) -cflags  -I,$(TOP)/$(LEDIT) -lflags  -I,$(TOP)/$(LEDIT) 

WOCAMLBUILD = ocamlbuild -j 2 -quiet -I $(GUTS) -I $(NREPL) -I src -I src/plugins  -lflags -I,/usr/lib/ocaml/pcre \
           -lflags -I,$(CAMLP5) -lflags -I,$(ANSITERM) -cflags -I,$(ANSITERM) -cflags -I,$(LEDIT) -lflags  -I,$(LEDIT)

all:: deps native

native :
	$(OCAMLBUILD) -libs $(LIBS) main.native
	mkdir -p dist/bin
	cp _build/src/main.native $(JARK_BIN)
	rm -rf _build

clean::
	rm -f *.cm[iox] *~ .*~ src/*~ #*#
	rm -rf html
	rm -f jark.{exe,native,byte}
	rm -f gmon.out
	rm -f jark*.tar.{gz,bz2}
	rm -rf jark
	cd $(LEDIT)  && make clean && rm -rf *.cm[iox] *~
	cd $(NREPL)  && rm -rf *.cm[iox] *~
	cd $(GUTS)  && rm -rf *.cm[iox] *~
	cd lib/ansiterminal && make clean && rm -rf *.cm[iox] *~

install : native
	mkdir -p $(PREFIX)/bin
	install -m 0755 $(JARK_BIN) $(PREFIX)/bin/jark

upx :
	mv $(JARK_BIN) $(JARK_BIN)-un
	upx --brute --best -f -o $(JARK_BIN) $(JARK_BIN)-un
	rm -f $(JARK_BIN)-un
	rm -rf _build

byte : 
	$(OCAMLBUILD) -libs $(LIBS) main.byte
	cp _build/src/main.byte jark.byte

native32 :
	$(OCAMLBUILD) -libs $(LIBS) -ocamlopt "ocamlopt.32" main.native
	cp _build/src/main.native jark.native
	rm -rf _build

exe :
	cd $(LEDIT)  && make -f Makefile.win32 && make -f Makefile.win32 ledit.cmxa 
	$(WOCAMLBUILD) -libs $(WIN_LIBS) -ocamlc i586-mingw32msvc-ocamlc -ocamlopt i586-mingw32msvc-ocamlopt  main.native
	mkdir -p build/Win32
	cp _build/src/main.native build/Win32/jark.exe
	rm -rf _build

zip:
	rm -rf upload/jark-$(VERSION)-win32
	mkdir -p upload
	cd upload && mkdir jark-$(VERSION)-win32
	cp README.md upload/jark-$(VERSION)-win32/README
	cp build/Win32/jark.exe upload/jark-$(VERSION)-win32/jark.exe
	cd upload && zip -r jark-$(VERSION)-win32.zip jark-$(VERSION)-win32/*

deb:
	ln -sf dist/debian debian
	fakeroot debian/rules clean
	fakeroot debian/rules binary
	rm debian

deps: ansiterminal ledit

ansiterminal:
		if [ ! -e $(ANSITERM)/ANSITerminal.cmxa ]; then \
			mkdir -p $(LIB) ;\
			cd $(LIB)/ansiterminal && ocaml setup.ml -configure && ocaml setup.ml -build ;\
		fi	

ledit:
	cd $(TOP)/$(LEDIT) && make && make ledit.cmxa 

deps-win32: ansiterminal camlp5-win32

camlp5-win32:
	if [ ! -e $(CAMLP5)/camlp5.cmxa ]; then \
		mkdir -p $(LIB) ; \
		cd $(LIB) && $(WGET) http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.02.3.tgz 2> /dev/null | tar xzvf - ; \
		cd camlp5-6.02.3 && ./configure --prefix $(CAMLP5DEP) --no-opt && make world.opt && make install ;\
		rm -rf $(LIB)/camlp5-6.02.3 ;\
	fi

LINUX_64_HOST=vagrant@33.33.33.20
LINUX_32_HOST=vagrant@33.33.33.21
WIN_32_HOST=vagrant@33.33.33.22

linux64: 
	ssh ${LINUX_64_HOST} "cd ~/jark-client && git pull && make && make upx"
	scp ${LINUX_64_HOST}:~/jark-client/dist/bin/jark-$(VERSION)-Linux-x86_64.bin dist/bin/
	ssh ${LINUX_64_HOST} "make deb"
	scp ${LINUX_64_HOST}:~/*.deb dist/debian/

linux32:
	ssh ${LINUX_32_HOST} "cd ~/jark-client && git pull && make && make tar"
	scp ${LINUX_32_HOST}:~/jark-client/upload/jark-${VERSION}-Linux-i386.tar.gz upload/

win32:
	ssh ${WIN_32_HOST} "cd ~/jark-client && git pull origin win32 && export PATH=${PATH}:/usr/i586-mingw32msvc/bin && make exe && make zip"
	scp ${WIN_32_HOST}:~/jark-client/upload/jark-${VERSION}-win32.zip upload/

