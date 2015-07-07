#!/usr/bin/env python
import os
import json
t=os.popen("""netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a,
S[a]}'|cut -d' ' -f 1""")
ports = []
for port in  t.readlines():
        r = os.path.basename(port.strip())
        ports += [{'{#TCPSTATUS}':r}]
print json.dumps({'data':ports},sort_keys=True,indent=4,separators=(',',':'))
