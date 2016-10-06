#!/bin/sh

find /usr/core -type f -name "*" -not -path "/usr/core/.git/*" -not -path "/usr/core/.gitignore" -not -path "/usr/core/.editorconfig" -print0 | xargs -0 ufix
find /usr/plugins -type f -name "*" -not -path "/usr/plugins/.git/*" -not -path "/usr/plugins/.gitignore" -not -path "/usr/plugins/devel/ting-dev-repo/*" -not -path "/usr/plugins/devel/ting-plugin-havp/.git/*" -not -path "/usr/plugins/devel/ting-plugin-ndpi/.git/*"  -print0 | xargs -0 ufix
find /usr/ports/ting/ting-lang -type f -name "*" -print0 | xargs -0 ufix
find /usr/ports/ting/ting-update -type f -name "*" -print0 | xargs -0 ufix
find /root/dpi-daemon -type f -name "*" -not -path "/root/dpi-daemon/.git/*" -print0 | xargs -0 ufix
