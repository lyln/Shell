#!/usr/bin/env python
import os
import json
t=os.popen("""sudo cat /data/log/nginx/xxx.access.log|awk '{print $9}'|sort|uniq -c |sort -n |awk '{print $NF}'""")
ports = []
for port in  t.readlines():
        r = os.path.basename(port.strip())
        ports += [{'{#CODESTATUS}':r}]
print json.dumps({'data':ports},sort_keys=True,indent=4,separators=(',',':'))
