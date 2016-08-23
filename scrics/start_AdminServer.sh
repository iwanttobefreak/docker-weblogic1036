#!/bin/bash
source /u01/middleware1036/wlserver_10.3/server/bin/setWLSEnv.sh
java weblogic.WLST << EOF
startServer(adminServerName='AdminServer',domainName='mydomain',url='t3://localhost:7001',username='weblogic',password='weblogic01',domainDir='/u01/domains/mydomain',jvmArgs='-Xms256m -Xmx512m -XX:CompileThreshold=8000 -XX:PermSize=128m -XX:MaxPermSize=256m')
exit()
EOF
