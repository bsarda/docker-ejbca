#!/bin/bash

# get sigterm from docker stop
trap 'echo "STOP";exit 0' SIGTERM

# launch db init
/bin/sh -c '/opt/dbinit.sh'

# set java home
JAVA_HOME=/usr/lib/jvm/$(ls /usr/lib/jvm/ -l | grep '^d' | awk '{print $9}')

# launch jboss init
/bin/sh -c '/opt/jbossinit.sh'

# if already initialized or not
if [ ! -f /etc/ejbca/init ]; then
        echo "This is the first launch - will init the configs, jboss, ant..."
	# launch ejbca init
	/bin/sh -c '/opt/ejbcainit.sh'
        # create flag file
        touch /etc/ejbca/init;
	# reload
	$APPSRV_HOME/bin/jboss-cli.sh -c --command=':reload'
else
        echo "EJBCA Already initialized, no need to reinit"
fi


