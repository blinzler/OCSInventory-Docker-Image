#!/bin/bash
if [ ! -d "$APACHE_RUN_DIR" ]; then
	mkdir "$APACHE_RUN_DIR"
	chown $APACHE_RUN_USER:$APACHE_RUN_GROUP "$APACHE_RUN_DIR"
fi
if [ -f "$APACHE_PID_FILE" ]; then
	rm "$APACHE_PID_FILE"
fi
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/log/ocsinventory-server
/usr/sbin/apache2ctl -D FOREGROUND
