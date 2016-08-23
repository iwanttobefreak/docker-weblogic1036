#!/bin/bash
if [ -z "$ORACLE_USER" ]
then
  exit 0
fi

v_usuario_oracle="$ORACLE_USER"
v_contrasenya_oracle=$ORACLE_PASSWORD

v_weblogic_user=weblogic
v_weblogic_password=weblogic01
v_ruta_binarios=/u01/middleware1036
v_java=/u01/java/bin/java
v_template=/u01/install/template1036.jar
v_ruta_dominio=/u01/domains
v_nou_template=/tmp/$$_nou_template.jar
v_nombre_dominio=mydomain
v_cookie=/tmp/$$_cookie
v_download=http://download.oracle.com/otn/nt/middleware/11g/wls/1036/wls1036_generic.jar
v_software=/u01/install/wls1036_generic.jar
v_tmp_silent=/tmp/$$_silent.xml

cd /u01/install

# Descarga de JVM
curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b 'oraclelicense=accept-dbindex-cookie' \
-OL http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz

v_Site2pstoreToken=`curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" -L $v_download | grep site2pstoretoken | awk -Fsite2pstoretoken {'print $2'}|awk -F\= {'print  $2'}|awk -F\" {'print $2'}`

curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0"  \
-d 'ssousername='$v_usuario_oracle'&password='$v_contrasenya_oracle'&site2pstoretoken='$v_Site2pstoreToken \
-o /dev/null \
https://login.oracle.com/sso/auth -c $v_cookie

echo '.oracle.com	TRUE	/	FALSE	0	oraclelicense	accept-dbindex-cookie' >> $v_cookie

curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b $v_cookie \
-OL $v_download

#Instalacion JVM
tar -xzvf /u01/install/jdk-7u79-linux-x64.tar.gz -C /u01/install
mv /u01/install/jdk1.7.0_79 /u01/java

#Instalación Weblogic
echo '<?xml version="1.0" encoding="UTF-8"?>
<domain-template-descriptor>

<input-fields>
   <data-value name="BEAHOME"                   value="'$v_ruta_binarios'" />
   <data-value name="USER_INSTALL_DIR"          value="'$v_ruta_binarios'" />
   <data-value name="INSTALL_NODE_MANAGER_SERVICE"   value="no" />
   <data-value name="COMPONENT_PATHS" value="WebLogic Server" />
</input-fields>
</domain-template-descriptor>' > $v_tmp_silent

$v_java -jar $v_software -mode=silent -silent_xml=$v_tmp_silent

source $v_ruta_binarios/wlserver_10.3/server/bin/setWLSEnv.sh

$v_java weblogic.WLST <<EOF
readTemplate('$v_template')
set('Name','$v_nombre_dominio')
writeTemplate('$v_nou_template')
closeTemplate()
createDomain('$v_nou_template','$v_ruta_dominio/$v_nombre_dominio','$v_weblogic_user','$v_weblogic_password')
exit()
EOF
