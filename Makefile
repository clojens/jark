
VERSION = 0.5.0

ARCH = $(shell uname)-$(shell uname -m)

PREFIX=debian/jark/usr

BIN_NAME = jark

OLIB = /usr/lib/ocaml
WLIB = /usr/i586-mingw32msvc/lib/ocaml/
WGET = wget --no-check-certificate -O -


# download and make dependencies within the project directory
TOP = $(shell pwd)
LEDIT = lib/ledit
GUT  = lib/gut
NREPL = lib/ocaml-nrepl-client

LIB = $(TOP)/lib
ANSITERM = lib/ANSITerminal-0.6/_build
# CAMLP5 = lib/camlp5/lib/ocaml/camlp5/
CAMLP5 = /usr/lib/ocaml/camlp5
CAMLP5DEP = $(TOP)/lib/camlp5

WIN_LIBS = $(WLIB)/unix,$(WLIB)/bigarray,$(WLIB)/str,$(WLIB)/nums,$(CAMLP5)/camlp5,$(CAMLP5)/gramlib,$(ANSITERM)/ANSITerminal,$(LEDIT)/ledit

LIBS = unix,bigarray,str,nums,$(CAMLP5)/camlp5,$(CAMLP5)/gramlib,$(TOP)/$(ANSITERM)/ANSITerminal,$(TOP)/$(LEDIT)/ledit

OCAMLBUILD = ocamlbuild -j 2 -quiet  -I src -I $(GUT)/src -I $(NREPL)/src -lflags -I,/usr/lib/ocaml/pcre  \
           -lflags -I,$(CAMLP5)  -lflags -I,$(TOP)/$(ANSITERM) -cflags -I,$(TOP)/$(ANSITERM) -cflags  -I,$(TOP)/$(LEDIT) -lflags  -I,$(TOP)/$(LEDIT) 

WOCAMLBUILD = ocamlbuild -j 2 -quiet -I $(GUT) -I $(NREPL) -I src -I src/plugins  -lflags -I,/usr/lib/ocaml/pcre \
           -lflags -I,$(CAMLP5) -lflags -I,$(ANSITERM) -cflags -I,$(ANSITERM) -cflags -I,$(LEDIT) -lflags  -I,$(LEDIT)

all:: native

native :
	$(OCAMLBUILD) -libs $(LIBS) main.native
	mkdir -p dist/bin
	cp _build/src/main.native dist/bin/$(BIN_NAME)-$(VERSION)-$(ARCH)
	rm -rf _build

upx :
	cd $(LEDIT)  && make && make ledit.cmxa 
	$(OCAMLBUILD) -libs $(LIBS) main.native
	if [ ! -d build/$(ARCH) ]; then mkdir -p build/$(ARCH); fi
	cp _build/src/main.native build/$(ARCH)/$(BIN_NAME)-un
	rm -f build/$(ARCH)/$(BIN_NAME)
	upx --brute --best -f -o build/$(ARCH)/$(BIN_NAME) build/$(ARCH)/$(BIN_NAME)-un
	rm -f build/$(BIN_NAME)-un
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

clean::
	rm -f *.cm[iox] *~ .*~ src/*~ #*#
	rm -rf html
	rm -f jark.{exe,native,byte}
	rm -f gmon.out
	rm -f jark*.tar.{gz,bz2}
	rm -rf jark

install : native
	mkdir -p $(PREFIX)/bin
	install -m 0755 build/$(ARCH)/$(BIN_NAME) $(PREFIX)/bin/

tar:
	rm -rf upload/jark-$(VERSION)-$(ARCH)
	mkdir -p upload
	cd upload && mkdir jark-$(VERSION)-$(ARCH)
	cp README.md upload/jark-$(VERSION)-$(ARCH)/README
	cp build/$(ARCH)/jark upload/jark-$(VERSION)-$(ARCH)/jark
	cd upload && tar zcf jark-$(VERSION)-$(ARCH).tar.gz jark-$(VERSION)-$(ARCH)/*

zip:
	rm -rf upload/jark-$(VERSION)-win32
	mkdir -p upload
	cd upload && mkdir jark-$(VERSION)-win32
	cp README.md upload/jark-$(VERSION)-win32/README
	cp build/Win32/jark.exe upload/jark-$(VERSION)-win32/jark.exe
	cd upload && zip -r jark-$(VERSION)-win32.zip jark-$(VERSION)-win32/*

deb:
	fakeroot dist/debian/rules clean
	fakeroot dist/debian/rules binary

deps: ansiterminal gut ledit nrepl

ansiterminal:
	if [ ! -e $(ANSITERM)/ANSITerminal.cmxa ]; then \
		mkdir -p $(LIB) ;\
		cd $(LIB) && $(WGET) https://forge.ocamlcore.org/frs/download.php/610/ANSITerminal-0.6.tar.gz 2> /dev/null | tar xzvf - ;\
		cd $(LIB)/ANSITerminal-0.6 && ocaml setup.ml -configure && ocaml setup.ml -build ;\
	fi

camlp5:
	if [ ! -e $(TOP)/$(CAMLP5)/camlp5.cmxa ]; then \
		mkdir -p $(LIB) ; \
		cd $(LIB) && $(WGET) http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.02.3.tgz 2> /dev/null | tar xzvf - ; \
		cd camlp5-6.02.3 && ./configure --prefix $(CAMLP5DEP) && make world.opt && make install ;\
		rm -rf $(LIB)/camlp5-6.02.3 ;\
	fi

gut:
	if [ ! -d $(GUT) ]; then \
		cd $(LIB) && git clone git://github.com/icylisper/gut.git ; \
	else \
		cd $(GUT) && git pull origin master ;\
	fi

ledit:
	if [ ! -d $(LEDIT) ]; then \
		cd $(LIB) && git clone git://github.com/icylisper/ledit.git  ; \
	        cd $(TOP)/$(LEDIT) && make && make ledit.cmxa ; \
	else \
		cd $(LEDIT) && git pull origin master && make && make ledit.cmxa ;\
	fi

nrepl:
	if [ ! -d $(NREPL) ]; then \
		cd $(LIB) && git clone git://github.com/icylisper/ocaml-nrepl-client.git ; \
	else \
		cd $(NREPL) && git pull origin master ;\
	fi

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
	ssh ${LINUX_64_HOST} "cd ~/jark-client && git pull && make upx && make tar && make deb"
	scp ${LINUX_64_HOST}:~/jark-client/upload/jark-${VERSION}-Linux-x86_64.tar.gz upload/
	scp ${LINUX_64_HOST}:~/*.deb upload/

linux32:
	ssh ${LINUX_32_HOST} "cd ~/jark-client && git pull && make && make tar"
	scp ${LINUX_32_HOST}:~/jark-client/upload/jark-${VERSION}-Linux-i386.tar.gz upload/

win32:
	ssh ${WIN_32_HOST} "cd ~/jark-client && git pull origin win32 && export PATH=${PATH}:/usr/i586-mingw32msvc/bin && make exe && make zip"
	scp ${WIN_32_HOST}:~/jark-client/upload/jark-${VERSION}-win32.zip upload/

