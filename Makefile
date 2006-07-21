#!/usr/bin/make

VERSION=$(shell cat ChangeLog  |grep Version | sed "s/.*: *//" | head -1)
DISTRIBUTION=/tmp/rad_eap_test-${VERSION}.tar.bz2
FILES=rad_eap_test README ChangeLog COPYING $(wildcard patches/*)
PUB_TARGET=semik@wiki.eduroam.cz:/var/www/non-ssl/rad_eap_test/
PUB_FILES=${DISTRIBUTION} README ChangeLog

${DISTRIBUTION}: ${FILES}
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
