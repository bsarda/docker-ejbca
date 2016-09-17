# written by Benoit Sarda
# ejbca container. uses bsarda/jboss by copy/paste.
#
#   bsarda <b.sarda@free.fr>
#
FROM centos:centos7.2.1511
MAINTAINER Benoit Sarda <b.sarda@free.fr>

# expose
EXPOSE 8080 8442 8443

# declare vars
ENV JBOSS_HOME=/opt/jboss-as-7.1.1.Final \
	APPSRV_HOME=/opt/jboss-as-7.1.1.Final \
	EJBCA_HOME=/opt/ejbca_ce_6_3_1_1 \
    # db vars 
	DB_USE_EMBEDDED=true \
	DB_USER=ejbca \
	DB_PASSWORD=ejbca \
	DB_URL=jdbc:mysql://127.0.0.1:3306/ejbca?characterEncoding=UTF-8 \
	DB_DRIVER=org.mariadb.jdbc.Driver \
	DB_NAME=mysql \
    # ebjca configs
	EJBCA_CLI_USER=ejbca \
	EJBCA_CLI_PASSWORD=ejbca \
	EJBCA_KS_PASS=foo123 \
    # ca config
	CA_NAME=ManagementCA \
	CA_DN=CN=ManagementCA,O=EJBCA,C=FR \
	CA_KEYSPEC=2048 \
	CA_KEYTYPE=RSA \
	CA_SIGNALG=SHA256WithRSA \
	CA_VALIDITY=3650 \
    # web config
	WEB_SUPERADMIN=SuperAdmin \
	WEB_JAVA_TRUSTPASSWORD=changeit \
	WEB_HTTP_PASSWORD=serverpwd \
	WEB_HTTP_HOSTNAME=localhost \
	WEB_HTTP_DN=CN=localhost,O=EJBCA,C=FR \
	WEB_SELFREG=true

# add files
ADD [	"jboss-as-7.1.1.Final.tar.gz", \
	"ejbca_ce_6_3_1_1.tar.gz", \
	"mariadb-java-client-1.5.2.jar", \
	"postgresql-9.1-903.jdbc4.jar", \
	"mariadb.repo", \
	"ejbcainit.sh", \
	"jbossinit.sh", \
	"dbinit.sh", \
	"init.sh", \
	"/opt/"]

# install prereq
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
	yum install -y net-tools java-1.7.0-openjdk java-1.7.0-openjdk-devel ant ant-optional && \
	groupadd ejbca && useradd ejbca -g ejbca && \
	mv /opt/mariadb.repo /etc/yum.repos.d/ && \
	chmod 750 /opt/init.sh && chmod 750 /opt/dbinit.sh && chmod 750 /opt/jbossinit.sh && chmod 750 /opt/ejbcainit.sh

# add the env for java home, once its installed
### ENV JAVA_HOME=/usr/lib/jvm/$(ls /usr/lib/jvm/ -l | grep '^d' | awk '{print $9}')

### sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' $APPSRV_HOME/standalone/configuration/standalone.xml
### /opt/jboss-as-7.1.1.Final/bin/standalone.sh -b 0.0.0.0 &
### cd /opt/ejbca_ce_6_3_1_1
### ant deploy
### ant install
### pid=$(ps -edf | grep standalone.sh | awk 'NR==1{print $2}')
### kill -SIGINT $pid
### /opt/jboss-as-7.1.1.Final/bin/standalone.sh -b 0.0.0.0
### cp $EJBCA_HOME/p12/superadmin.p12 /superadmin.p12

### CMD ["/bin/sh","-c","/opt/init.sh"]
CMD ["/opt/init.sh"]
