#!/bin/bash
/u01/scripts/start_nodemanager.sh
/u01/scripts/start_AdminServer.sh
tail -f /u01/domains/mydomain/servers/AdminServer/logs/AdminServer.log
