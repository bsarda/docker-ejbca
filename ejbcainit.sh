#!/bin/bash
# set properties files
echo "#------- settings ejbca.properties --------" > $EJBCA_HOME/conf/ejbca.properties
echo "#jboss.config=all" >> $EJBCA_HOME/conf/ejbca.properties
echo "#jboss.farm.name=farm" >> $EJBCA_HOME/conf/ejbca.properties
echo "appserver.home=$JBOSS_HOME" >> $EJBCA_HOME/conf/ejbca.properties
echo "appserver.type=jboss" >> $EJBCA_HOME/conf/ejbca.properties
echo "ejbca.cli.defaultusername=$EJBCA_CLI_USER" >> $EJBCA_HOME/conf/ejbca.properties
echo "ejbca.cli.defaultpassword=$EJBCA_CLI_PASSWORD" >> $EJBCA_HOME/conf/ejbca.properties
echo "ejbca.passwordlogrounds=8" >> $EJBCA_HOME/conf/ejbca.properties

echo "#------- settings cesecore.properties --------" > $EJBCA_HOME/conf/cesecore.properties
echo "ca.keystorepass=$EJBCA_KS_PASS" >> $EJBCA_HOME/conf/cesecore.properties

echo "#------- settings install.properties --------" > $EJBCA_HOME/conf/install.properties
echo "ca.name=$CA_NAME" >> $EJBCA_HOME/conf/install.properties
echo "ca.dn=$CA_DN" >> $EJBCA_HOME/conf/install.properties
echo "ca.tokentype=soft" >> $EJBCA_HOME/conf/install.properties
echo "ca.tokenpassword=null" >> $EJBCA_HOME/conf/install.properties
echo "ca.keyspec=$CA_KEYSPEC" >> $EJBCA_HOME/conf/install.properties
echo "ca.keytype=$CA_KEYTYPE" >> $EJBCA_HOME/conf/install.properties
echo "ca.signaturealgorithm=$CA_SIGNALG" >> $EJBCA_HOME/conf/install.properties
echo "ca.validity=$CA_VALIDITY" >> $EJBCA_HOME/conf/install.properties
echo "ca.policy=null" >> $EJBCA_HOME/conf/install.properties

echo "#------- settings web.properties --------" > $EJBCA_HOME/conf/web.properties
echo "superadmin.cn=$WEB_SUPERADMIN" >> $EJBCA_HOME/conf/web.properties
echo "superadmin.dn=CN=\${superadmin.cn}" >> $EJBCA_HOME/conf/web.properties
echo "superadmin.password=ejbca" >> $EJBCA_HOME/conf/web.properties
echo "java.trustpassword=$WEB_JAVA_TRUSTPASSWORD" >> $EJBCA_HOME/conf/web.properties
echo "superadmin.batch=true" >> $EJBCA_HOME/conf/web.properties
echo "httpsserver.password=$WEB_HTTP_PASSWORD" >> $EJBCA_HOME/conf/web.properties
echo "httpsserver.hostname=$WEB_HTTP_HOSTNAME" >> $EJBCA_HOME/conf/web.properties
echo "httpsserver.dn=$WEB_HTTP_DN" >> $EJBCA_HOME/conf/web.properties
echo "web.selfreg.enabled=$WEB_SELFREG" >> $EJBCA_HOME/conf/web.properties

# deploy and install ear
cd $EJBCA_HOME
# deploy
ant deploy
rc=$?
if [[ $rc -ne 0 ]] ; then
  echo "Error while executing ant deploy, rc=$rc"; exit $rc
fi
# install
ant install
rc=$?
if [[ $rc -ne 0 ]] ; then
  echo "Error while executing ant install, rc=$rc"; exit $rc
fi

# copy key to root fs for easy copy
cp $EJBCA_HOME/p12/superadmin.p12 /superadmin.p12

