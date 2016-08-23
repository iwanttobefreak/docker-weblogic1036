#!/bin/bash
/u01/middleware1036/wlserver_10.3/common/bin/wlst.sh << EOF
startNodeManager(NodeManagerHome='/u01/middleware1036/wlserver_10.3/common/nodemanager',SecureListener="false")
exit()
EOF
