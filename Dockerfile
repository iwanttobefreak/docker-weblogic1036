FROM oraclelinux:6.6
MAINTAINER Jose Legido "jose@legido.com"

# USUARIS
RUN groupadd -g 1001 weblogic && useradd -u 1001 -g weblogic weblogic

# EINES
RUN yum install -y tar
