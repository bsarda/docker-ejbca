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
ENV JBOSS_HOME=/opt/jboss \
	APPSRV_HOME=/opt/jboss \
	EJBCA_HOME=/opt/ejbca \
    # db vars
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
	"/opt/"]

# install prereq
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
	yum install -y net-tools java-1.7.0-openjdk java-1.7.0-openjdk-devel ant ant-optional && \
	groupadd ejbca && useradd ejbca -g ejbca && \
	mv /opt/mariadb.repo /etc/yum.repos.d/ && \
	rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
	yum install -y MariaDB-client

# add files
ADD [	"ejbcainit.sh", \
	"jbossinit.sh", \
	"dbinit.sh", \
	"stop.sh", \
	"init.sh", \
	"jboss-modules-1.1.5.GA.jar", \
	"/opt/"]

# install prereq
RUN chmod 750 /opt/init.sh && chmod 750 /opt/dbinit.sh && chmod 750 /opt/jbossinit.sh && chmod 750 /opt/ejbcainit.sh && chmod 750 /opt/stop.sh

CMD ["/opt/init.sh"]
