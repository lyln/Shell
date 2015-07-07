#!/usr/bin/env python
import os
import json
list=open("/etc/zabbix/scripts/list.txt",'r')
web=[]
for site in list.readlines():
        r = os.path.basename(site.strip())
        web += [{'{#SITENAME}':r}]
print json.dumps({'data':web},sort_keys=True,indent=4,separators=(',',':'))
