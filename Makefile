#!/usr/bin/make

VERSION=$(shell cat ChangeLog  |grep Version | sed "s/.*: *//" | head -1)
DISTRIBUTION=/tmp/rad_eap_test-${VERSION}.tar.bz2
FILES=rad_eap_test README ChangeLog COPYING $(wildcard patches/*)
PUB_TARGET=semik@wiki.eduroam.cz:/var/www/non-ssl/rad_eap_test/

${DISTRIBUTION}: ${FILES}
	(mkdir /tmp/rad_eap_test-${VERSION}; \
	 tar jcf ${DISTRIBUTION} ${FILES}; \
	 cd /tmp/rad_eap_test-${VERSION}; \
	 tar jxf ${DISTRIBUTION}; \
	 cd ..; \
	 pwd ;\
	 tar jcf ${DISTRIBUTION} rad_eap_test-${VERSION})

tar: ${DISTRIBUTION}

publish: tar
	scp ${DISTRIBUTION} README ${PUB_TARGET}

all: tar publish
