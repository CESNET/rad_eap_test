#!/usr/bin/make

VERSION=$(shell cat ChangeLog  |grep Version | sed "s/.*: *//" | head -1)
DISTRIBUTION=/tmp/rad_eap_test-${VERSION}.tar.bz2
FILES=rad_eap_test README ChangeLog COPYING doc/rad_eap_test.1 $(wildcard patches/*)
PUB_TARGET=semik@wiki.eduroam.cz:/var/www/non-ssl/rad_eap_test/
PUB_FILES=${DISTRIBUTION} README ChangeLog rad_eap_test.html

rad_eap_test.html: doc/rad_eap_test.1
	man2html <doc/rad_eap_test.1 | grep -v '^Content-type: text/html' | \
	sed "s/<A HREF=\"\/cgi-bin\/man\/man2html\">Return to Main Contents<\/A>//" | \
	sed "s/\/cgi-bin\/man\/man2html/http:\/\/packages.debian.org\/unstable\/doc\/man2html.html/" >rad_eap_test.html

${DISTRIBUTION}: ${FILES} rad_eap_test.html
	(mkdir /tmp/rad_eap_test-${VERSION}; \
	 tar jcf ${DISTRIBUTION} ${FILES}; \
	 cd /tmp/rad_eap_test-${VERSION}; \
	 tar jxf ${DISTRIBUTION}; \
	 find -type f -exec chmod 644 {} \; ; \
	 chmod 755 rad_eap_test ; \
	 find -type d -exec chmod 755 {} \; ; \
	 cd ..; \
	 pwd ;\
	 tar -j -c --owner=root --group=staff -f ${DISTRIBUTION} rad_eap_test-${VERSION})

tar: ${DISTRIBUTION}

publish: tar
	scp ${PUB_FILES} ${PUB_TARGET}

all: tar publish
