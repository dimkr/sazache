# this file is part of sazache.
#
# Copyright (c) 2016 Dima Krasner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include szl/Makefile.common

CFLAGS += -Iszl/src
LDFLAGS += -Lszl/src
LIBS += -lszl -ldl -lm

sazache: sazache.o szl/src/libszl.so
	$(CC) $(LDFLAGS) -o $@ sazache.o $(LIBS)

sazache.o: sazache.c sazache.inc
	$(CC) $(CFLAGS) -c -o $@ sazache.c

sazache.inc: sazache.szl
	sh szl/src/minify.sh < $^ > $@

szl/src/libszl.so:
	cd szl/doc; $(MAKE)
	cd szl/src; $(MAKE)

install: sazache
	cd szl/src; $(MAKE) install
	cd szl/doc; $(MAKE) install
	$(INSTALL) -m 755 sazache $(DESTDIR)/$(BIN_DIR)/sazache
	$(INSTALL) -D -m 644 sazache.1 $(DESTDIR)/$(MAN_DIR)/sazache.1
	$(INSTALL) -D -m 644 README $(DESTDIR)/$(DOC_DIR)/sazache/README
	$(INSTALL) -m 644 AUTHORS $(DESTDIR)/$(DOC_DIR)/sazache/AUTHORS
	$(INSTALL) -m 644 COPYING $(DESTDIR)/$(DOC_DIR)/sazache/COPYING

clean:
	rm -f sazache sazache.o sazache.inc
	cd szl/src; $(MAKE) clean
