FROM oraclelinux:6.8
MAINTAINER Jose Legido "jose@legido.com"

ARG ORACLE_USER
ARG ORACLE_PASSWORD

# USUARIS
RUN groupadd -g 1001 weblogic && useradd -u 1001 -g weblogic weblogic
RUN  mkdir /u01 && chown weblogic. /u01

# EINES
RUN yum install -y tar

COPY scrics/install_weblogic1036.sh /u01/install_weblogic1036.sh
COPY scrics/template1036.jar /u01/template1036.jar
RUN chown -R weblogic. /u01/*
RUN chmod +x /u01/install_weblogic1036.sh

USER weblogic

RUN /u01/install_weblogic1036.sh $ORACLE_USER $ORACLE_PASSWORD

#Esborrem programari d'instalacio
RUN rm /u01/install_weblogic1036.sh || rm /u01/template1036.jar || rm /u01/wls1036_generic.jar || rm /u01/jdk-7u79-linux-x64.tar.gz

CMD ["/u01/domains/mydomain/startWebLogic.sh"]
