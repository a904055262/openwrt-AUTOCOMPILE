#!/bin/sh

services="aria2
banip
cpulimit
ddns
frpc
frps
msd_lite
mwan3
natmap
netdata
omcproxy
p910nd
samba4
socat
timewol
udpxy
usb_printer
uugamebooster"

for s in $services; do 
	echo "$s"
	service "$s" disable
	service "$s" stop
done
