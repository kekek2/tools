#!/bin/sh

SRC_PATH=/tmp/ting-lang

echo ">>> Update ting-lang port"

if [ ! -d ${SRC_PATH} ]; then
    git clone ssh://git@78.157.94.34:7999/ting/opnsense-lang-tinged.git ${SRC_PATH}
fi

cd ${SRC_PATH}
git checkout ting
git pull
PORT_VERSION=$(git describe)
mkdir /tmp/lang
cp -Rf ${SRC_PATH}/* /tmp/lang
cd /tmp
tar -czf /tmp/ting-lang-${PORT_VERSION}.tar.gz lang
mv /tmp/ting-lang-${PORT_VERSION}.tar.gz /usr/ports/distfiles/
cd /usr/ports/ting/ting-lang
make clean
make makesum
make extract
rm -rf /tmp/lang
cd /usr/tools
make ports-ting-lang

