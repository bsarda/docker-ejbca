#!/bin/bash
touch /opt/letitrun

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
    while [[ `netstat -an | grep 8080 | wc -l` == 0 ]];
    do
        echo "Wating for JBoss reload"
        sleep 1;
    done
    echo "EJBCA Initialized. do a 'docker cp' on the /superadmin.p12 file to download su token"
else
    echo "EJBCA Already initialized, no need to reinit"
fi


# wait in an infinite loop for keeping alive pid1
trap '/bin/sh -c "/opt/stop.sh"' SIGTERM
while [ -f /opt/letitrun ]; do sleep 1; done
exit 0;
