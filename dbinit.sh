#!/bin/bash

mkdir -p /etc/ejbca/
if [ ! -f /etc/ejbca/dbinit ]; then
        echo "This is the first launch - will init ssl certs, db parameters..."
    		echo "  Will use external database, from specified parameters"
    		echo "# ------------- Database configuration ------------------------" > $EJBCA_HOME/conf/database.properties
    		echo "database.name=$DB_NAME" >> $EJBCA_HOME/conf/database.properties
    		echo "database.url=$DB_URL" >> $EJBCA_HOME/conf/database.properties
    		echo "database.driver=$DB_DRIVER" >> $EJBCA_HOME/conf/database.properties
    		echo "database.username=$DB_USER" >> $EJBCA_HOME/conf/database.properties
    		echo "database.password=$DB_PASSWORD" >> $EJBCA_HOME/conf/database.properties

        # create flag file
        touch /etc/ejbca/dbinit;
else
        echo "DB Already initialized, no need to reinit"
fi
