#!/bin/sh

# Copyright (c) 2015-2016 Franco Fichtner <franco@opnsense.org>
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

PLUGINS_MARKER="plugins"

if [ "$FORCE" != "$PLUGINS_MARKER" ]; then
    check_packages ${PLUGINS_MARKER} ${@}
fi

if [ -z "${*}" ]; then
	PLUGINS_LIST=$(make -C ${PLUGINSDIR} list)
else
	PLUGINS_LIST="${*}"
fi

setup_stage ${STAGEDIR}
setup_base ${STAGEDIR}
setup_clone ${STAGEDIR} ${PLUGINSDIR}

extract_packages ${STAGEDIR}

for PLUGIN in ${PLUGINS_LIST}; do
	PLUGIN_NAME=$(make -C ${PLUGINSDIR}/${PLUGIN} name)
	PLUGIN_DEPS=$(make -C ${PLUGINSDIR}/${PLUGIN} depends)

	remove_packages ${STAGEDIR} ${PLUGIN_NAME}
	install_packages ${STAGEDIR} ${PLUGIN_DEPS} git
	custom_packages ${STAGEDIR} ${PLUGINSDIR}/${PLUGIN}
done

bundle_packages ${STAGEDIR} ${PLUGINS_MARKER}
