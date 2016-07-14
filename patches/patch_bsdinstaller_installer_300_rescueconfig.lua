--- /usr/ports/opnsense/bsdinstaller/files/installer/300_rescueconfig.lua.orig	2016-07-14 14:36:07.286744968 +0300
+++ /usr/ports/opnsense/bsdinstaller/files/installer/300_rescueconfig.lua	2016-07-14 15:46:31.563454288 +0300
@@ -83,6 +83,9 @@
 	cmds = CmdChain.new()
 	if POSIX.stat("/tmp/hdrescue/conf", "type") == "directory" then
 		cmds:add("${root}bin/cp /tmp/hdrescue/conf/config.xml /conf/config.xml");
+		if POSIX.stat("/tmp/hdrescue/conf/config.xml.sum", "type") == "regular" then
+			cmds:add("${root}bin/cp /tmp/hdrescue/conf/config.xml.sum /conf/config.xml.sum");
+		end
 		if POSIX.stat("/tmp/hdrescue/conf/backup", "type") == "directory" then
 			cmds:add("${root}bin/cp -r /tmp/hdrescue/conf/backup /conf");
 		end
