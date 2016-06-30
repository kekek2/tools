#!/bin/sh

echo "PHP code sizes (bytes)"
echo -n "	core:		"
find -E /usr/core -type f -regex '.*\.(php|inc)' -ls | awk '{sum = sum+$7 }; END { print sum }'
echo -n "	os-ndpi:	"
find -E /usr/plugins/devel/ting-plugin-ndpi -type f -regex '.*\.(php|inc)' -ls | awk '{sum = sum+$7 }; END { print sum }'
echo -n "	os-havp:	"
find -E /usr/plugins/devel/ting-plugin-havp -type f -regex '.*\.(php|inc)' -ls | awk '{sum = sum+$7 }; END { print sum }'
echo -n "	ting-lang:	"
find -E /usr/ports/ting/ting-lang/work/lang -type f -regex '.*\.(php|inc)' -ls | awk '{sum = sum+$7 }; END { print sum }'

echo "Shell code sizes (bytes)"
echo -n "	ting-update:	"
find -E /usr/ports/ting/ting-update/work/src -type f -regex '.*\.(sh)' -ls | awk '{sum = sum+$7 }; END { print sum }'

echo "C code sizes (bytes)"
echo -n "	os-ndpi:	"
find -E /root/dpi-daemon -type f -regex '.*\.(c|h)' -ls | awk '{sum = sum+$7 }; END { print sum }'
echo -n "	ting-update:	"
find -E /usr/ports/ting/ting-update/work/src -type f -regex '.*\.(c|h)' -ls | awk '{sum = sum+$7 }; END { print sum }'

echo "Executable code sizes (bytes)"
echo -n "	os-ndpi:	"
find -E /usr/plugins/devel/ting-plugin-ndpi/src/bin -type f -ls | awk '{sum = sum+$7 }; END { print sum }'

echo "PHP files count"
echo -n "	core:		"
find -E /usr/core -type f -regex '.*\.(php|inc)' -ls | grep -c ''
echo -n "	os-ndpi:	"
find -E /usr/plugins/devel/ting-plugin-ndpi -type f -regex '.*\.(php|inc)' -ls | grep -c ''
echo -n "	os-havp:	"
find -E /usr/plugins/devel/ting-plugin-havp -type f -regex '.*\.(php|inc)' -ls | grep -c ''
echo -n "	ting-lang:	"
find -E /usr/ports/ting/ting-lang/work/lang -type f -regex '.*\.(php|inc)' -ls | grep -c ''

echo "Shell files count"
echo -n "	ting-update:	"
find -E /usr/ports/ting/ting-update/work/src -type f -regex '.*\.(sh)' -ls | grep -c ''

echo "C code files count"
echo -n "	os-ndpi:	"
find -E /root/dpi-daemon -type f -regex '.*\.(c|h)' -ls | grep -c ''
echo -n "	ting-update:	"
find -E /usr/ports/ting/ting-update/work/src -type f -regex '.*\.(c|h)' -ls | grep -c ''

