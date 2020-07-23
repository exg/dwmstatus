# See LICENSE file for copyright and license details.

include config.mk

SRC = dwmstatus.c
OBJ = ${SRC:.c=.o}

all: options dwmstatus

options:
	@echo dwmstatus build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

dwmstatus: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwmstatus ${OBJ} dwmstatus-${VERSION}.tar.gz

dist: clean
	mkdir -p dwmstatus-${VERSION}
	cp -R Makefile LICENSE config.mk \
		${SRC} dwmstatus-${VERSION}
	tar -cf dwmstatus-${VERSION}.tar dwmstatus-${VERSION}
	gzip dwmstatus-${VERSION}.tar
	rm -rf dwmstatus-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwmstatus ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwmstatus

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwmstatus

.PHONY: all options clean dist install uninstall
