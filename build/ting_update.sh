#!/bin/sh

SRC_PATH=/tmp/ting-update

echo ">>> Update ting-update port"

if [ ! -d ${SRC_PATH} ]; then
    git clone ssh://git@78.157.94.34:7999/ting/update.git ${SRC_PATH}
fi

cd ${SRC_PATH}
git checkout tinged
git pull
PORT_VERSION=$(git describe)
mkdir /tmp/src
cp -Rf ${SRC_PATH}/* /tmp/src
cd /tmp
tar -czf /tmp/ting-update-${PORT_VERSION}.tar.gz src
mv /tmp/ting-update-${PORT_VERSION}.tar.gz /usr/ports/distfiles/
cd /usr/ports/ting/ting-update
make clean
make makesum
make extract
rm -rf /tmp/src
cd /usr/tools
make ports-ting-update

