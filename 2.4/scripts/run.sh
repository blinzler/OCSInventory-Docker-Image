#!/bin/bash
if [ ! -d "$HTTPD_RUN_DIR" ]; then
	mkdir "$HTTPD_RUN_DIR"
	chown $HTTPD_RUN_USER:$HTTPD_RUN_GROUP "$HTTPD_RUN_DIR"
fi
if [ -f "$HTTPD_PID_FILE" ]; then
	rm "$HTTPD_PID_FILE"
fi
/usr/sbin/apache2ctl -D FOREGROUND
