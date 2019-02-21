
#####Download the dependencies
```
wget http://downloads.sourceforge.net/project/ejbca/ejbca6/ejbca_6_3_1_1/ejbca_ce_6_3_1_1.zip
wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
wget http://repo1.maven.org/maven2/org/jboss/modules/jboss-modules/1.1.5.GA/jboss-modules-1.1.5.GA.jar
```

#####Repackage EJBCA source release from .zip to .tar.gz (Docker does not support .zip)
```
unzip -q ejbca_ce_6_3_1_1.zip
tar zcf ejbca_ce_6_3_1_1.tar.gz ejbca_ce_6_3_1_1
rm -rf ejbca_ce_6_3_1_1 ejbca_ce_6_3_1_1.zip
```

#####Build the container image
```
docker build --tag ejbca .
```