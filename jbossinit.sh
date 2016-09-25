#!/bin/bash

mkdir -p /etc/ejbca/
if [ ! -f /etc/ejbca/jbossinit ]; then
    echo "This is the first launch - will init jboss..."
    # install
    case "$DB_DRIVER" in
        'org.postgres'*)
    				# install to jboss
    				mkdir -p $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/
    				mv /opt/postgresql-9.1-903.jdbc4.jar $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/
    				rm -f /opt/mariadb-java-client-1.5.2.jar

    				echo '<?xml version="1.0" encoding="UTF-8"?>'                           > $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '<module xmlns="urn:jboss:module:1.0" name="org.postgresql">'      >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '  <resources>'                                                    >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '    <resource-root path="postgresql-9.1-903.jdbc4.jar"/>'         >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '  </resources>'                                                   >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '  <dependencies>'                                                 >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '    <module name="javax.api"/>'                                   >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '    <module name="javax.transaction.api"/>'                       >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '    <module name="org.slf4j"/>'                                   >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '  </dependencies>'                                                >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml
    				echo '</module>'                                                        >> $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml

            # copy to other location for install
            mkdir -p $JBOSS_HOME/modules/org/postgresql/main
            cp $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/* $JBOSS_HOME/modules/org/postgresql/main/
    				# start jboss
            $APPSRV_HOME/bin/standalone.sh -b 0.0.0.0 &
    				while [[ `netstat -an | grep 8080 | wc -l` == 0 ]];
            do
        		        echo "Wating for JBoss start up"
          	        sleep 1;
            done
    				# install jdbc driver
    				$APPSRV_HOME/bin/jboss-cli.sh -c --command='/subsystem=datasources/jdbc-driver=org.postgresql.Driver:add(driver-name=org.postgresql.Driver,driver-module-name=org.postgresql,driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource)'
            $APPSRV_HOME/bin/jboss-cli.sh -c --command=':reload'
    				;;
        'org.mariadb'*)
          	# install to jboss
            mkdir -p $JBOSS_HOME/modules/org/mariadb/main/
            mv /opt/mariadb-java-client-1.5.2.jar $JBOSS_HOME/modules/org/mariadb/main/
          	rm -f /opt/postgresql-9.1-903.jdbc4.jar
          	# create module xml file
    				echo '<?xml version="1.0" encoding="UTF-8"?>'                           > $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '<module xmlns="urn:jboss:module:1.0" name="org.mariadb">'         >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '  <resources>'                                                    >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '    <resource-root path="mariadb-java-client-1.5.2.jar"/>'        >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '  </resources>'                                                   >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '  <dependencies>'                                                 >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '    <module name="javax.api"/>'                                   >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '    <module name="javax.transaction.api"/>'                       >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '    <module name="org.slf4j"/>'                                   >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '  </dependencies>'                                                >> $JBOSS_HOME/modules/org/mariadb/main/module.xml
    				echo '</module>'                                                        >> $JBOSS_HOME/modules/org/mariadb/main/module.xml

    				# start jboss
            $APPSRV_HOME/bin/standalone.sh -b 0.0.0.0 &
            while [[ `netstat -an | grep 8080 | wc -l` == 0 ]];
            do
                echo "Wating for JBoss start up"
                sleep 1;
            done
            # install jdbc driver
            $APPSRV_HOME/bin/jboss-cli.sh -c --command='/subsystem=datasources/jdbc-driver=org.mariadb.jdbc.Driver:add(driver-name=org.mariadb.jdbc.Driver,driver-module-name=org.mariadb,driver-xa-datasource-class-name=org.mariadb.jdbc.MySQLDataSource)'
        		$APPSRV_HOME/bin/jboss-cli.sh -c --command=':reload'
    				;;
        *)
        		echo "Incorrect DB name from parameters. Aborting."
    				exit 150
        		;;
    esac
    # create flag file
    touch /etc/ejbca/jbossinit;

else
    echo "JBoss Already initialized, no need to reinit"
    # start jboss
    $APPSRV_HOME/bin/standalone.sh -b 0.0.0.0 &
fi

# wait for reload complete
while [[ `netstat -an | grep 8080 | wc -l` == 0 ]];
do
	echo "Wating for JBoss start up"
	sleep 1;
done
