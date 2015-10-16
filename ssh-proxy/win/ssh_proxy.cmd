cd /d %~dp0
echo y | putty\plink.exe -v -C -N -D 8527 -i putty\private.ppk user@ip

-D 8527为本地代理端口
user@ip vps的用户和ip地址