#!/bin/sh

# Copyright (c) 2014-2016 Franco Fichtner <franco@opnsense.org>
# Copyright (c) 2010-2011 Scott Ullrich <sullrich@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

set -e

. ./common.sh && $(${SCRUB_ARGS})

SERIALIMG="${IMAGESDIR}/${PRODUCT_RELEASE}-serial-${ARCH}.img"
VGAIMG="${IMAGESDIR}/${PRODUCT_RELEASE}-vga-${ARCH}.img"

# rewrite the disk label, because we're install media
LABEL="${LABEL}_Install"

sh ./clean.sh memstick

setup_stage ${STAGEDIR}
setup_base ${STAGEDIR}
setup_kernel ${STAGEDIR}
setup_packages ${STAGEDIR} ting os-ndpi
make_brand_boot ${STAGEDIR}
setup_mtree ${STAGEDIR}

echo ">>> Building memstick image(s)..."

cat > ${STAGEDIR}/etc/fstab << EOF
# Device	Mountpoint	FStype	Options	Dump	Pass#
/dev/ufs/${LABEL}	/	ufs	ro,noatime	1	1
tmpfs		/tmp		tmpfs	rw,mode=01777	0	0
EOF

setup_entropy ${STAGEDIR}

makefs -t ffs -B little -o label=${LABEL} ${VGAIMG} ${STAGEDIR}

echo "-S${SERIAL_SPEED} -D" > ${STAGEDIR}/boot.config

cat > ${STAGEDIR}/boot/loader.conf << EOF
boot_multicons="YES"
boot_serial="YES"
console="comconsole,vidconsole"
comconsole_speed="${SERIAL_SPEED}"
autoboot_delay="2"
EOF

sed -i '' -e "s:</system>:${SERIAL_CONFIG}</system>:" ${STAGEDIR}${CONFIG_XML}

sed -i '' -Ee 's:^ttyu0:ttyu0	"/usr/libexec/getty std.9600"	cons25	on  secure:' ${STAGEDIR}/etc/ttys

setup_entropy ${STAGEDIR}

makefs -t ffs -B little -o label=${LABEL} ${SERIALIMG} ${STAGEDIR}

setup_bootcode()
{
	local dev

	dev=$(mdconfig -a -t vnode -f "${1}")
	gpart create -s BSD "${dev}"
	gpart bootcode -b "${STAGEDIR}"/boot/boot "${dev}"
	gpart add -t freebsd-ufs "${dev}"
	mdconfig -d -u "${dev}"
}

setup_bootcode ${VGAIMG}
setup_bootcode ${SERIALIMG}

echo "done:"

ls -lah ${IMAGESDIR}/*
