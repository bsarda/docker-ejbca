# docker-ejbca

This is the EJBCA container on CentOS 7.2 1511.
This container requires an external database : postgresql / mariadb are compatible.
For a container that uses embedded database, use bsarda/ejbca-embedded.

Sample usage:  
`docker run -P -d --name pki --env DB_USER=ejbca --env DB_PASSWORD='P@ssw0rd!' --env DB_URL=jdbc:postgresql://192.168.63.5:4:5432/ejbca --env DB_DRIVER=org.postgresql.Driver bsarda/ejbca`  
`docker logs -f pki`  
When logs shows 'EJBCA Initialized.[...]', you should download the superadmin token  
`docker cp pki:/superadmin.p12 ~/`  
And install it in the user's personal store. Defaut password = ejbca  
Note the ports used to connect:  
`docker port pki`  

Open the interface from a brower, like https://192.168.63.5:32768/ejbca  

## Database settings
The database settings are to set according to the target DB. The user must be the db owner. At this time, only mariadb and postgresql are supported and tested.  
**database settings**
- DB_USER => database user => default: ejbca  
- DB_PASSWORD => database password => default: ejbca  
- DB_URL => database jdbc url => default: jdbc:mysql://127.0.0.1:3306/ejbca?characterEncoding=UTF-8  
  also available: jdbc:postgresql://127.0.0.1:5432/ejbca  
  adapt ip address/port as needed.
- DB_DRIVER => database driver => org.mariadb.jdbc.Driver  
also available: org.postgresql.Driver
- DB_NAME => database name => mysql  

## Options as environment vars
**cli user/pass**  
- EJBCA_CLI_USER => default 'ejbca'  
- EJBCA_CLI_PASSWORD => default 'ejbca'  
**keystore**  
- EJBCA_KS_PASS => keystore password => default 'foo123'  
**certificate authority**  
- CA_NAME => name (CN) of the cert authority => default 'ManagementCA'  
- CA_DN => DN of the cert authority => default 'CN=ManagementCA,O=EJBCA,C=FR'  
- CA_KEYSPEC => key size => default '2048'  
- CA_KEYTYPE => key type => default 'RSA'  
- CA_SIGNALG => signature algorithm => default 'SHA256WithRSA'  
- CA_VALIDITY => validity in days => default '3650' (10 years)  
**web server**  
- WEB_SUPERADMIN => superadmin name => default 'SuperAdmin'  
- WEB_JAVA_TRUSTPASSWORD => java truststore password => default 'changeit'  
- WEB_HTTP_PASSWORD => password for http server => default 'serverpwd'  
- WEB_HTTP_HOSTNAME => hostname of the http server => default 'localhost'  
- WEB_HTTP_DN => DN of the http server => default 'CN=localhost,O=EJBCA,C=FR'  
- WEB_SELFREG => enable self-service registration => default 'true'  


## Docker Compose

Check out the example docker-compose.yml. Container persistence is supported.

Start up containers with:
```
docker-compose -f docker-compose.yml up -d
```

Stop and remove containers with:
```
docker-compose -f docker-compose.yml down
```

Start them up again with existing data/config:
```
docker-compose -f docker-compose.yml up -d
```

If you want to delete the containers persistent data just remove the persistent volumes and start again
```
rm -rf /srv/docker/ejbca*
docker-compose -f docker-compose.yml up -d
```
 
 

## Persistent Volumes: 
(assumes /srv/docker base path for persistent volumes)

Mysql container db data files:
```
/srv/docker/ejbca-mysql/data:/var/lib/mysql
```

EJBCA Container state files:
```
/srv/docker/ejbca/etc/ejbca:/etc/ejbca
```
    
EJBCA base directory:    
```
/srv/docker/ejbca/opt/ejbca:/opt/ejbca
```

JBOSS base directory:    
```
/srv/docker/ejbca/opt/jboss:/opt/jboss
```

When using persistent volumes, grab the superadmin.p12 directly from the docker host:
```
scp root@myhost://srv/docker/ejbca/opt/ejbca/p12/superadmin.p12 .
```