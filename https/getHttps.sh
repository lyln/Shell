#!/bin/bash
DOMAIN=$1
# get cert file
./certbot-auto  certonly --standalone -m lijd@rgbvr.com -d $DOMAIN

# cp to  
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem /opt/deploy/https
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem /opt/deploy/https

# cd https
cd /opt/deploy/https
openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out fullchain_and_key.p12 -name tomcat  -passin admin123 -passout admin123
#.jks证书
keytool -importkeystore -deststorepass admin123 -destkeypass admin123 -destkeystore rgbvrkeystore.jks -srckeystore fullchain_and_key.p12 -srcstoretype PKCS12 -srcstorepass rgbvradmin -alias tomcat
