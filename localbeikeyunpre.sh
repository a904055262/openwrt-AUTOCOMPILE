#!/usr/bin/env bash
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

sudo mkdir -p /opt
if [ ! -d /opt/openwrt_packit ];then
	sudo git clone --depth=1 https://github.com/a904055262/openwrt_packit /opt/openwrt_packit
	if [ $? -ne 0 ];then
		echo clone失败
		exit 1
	fi
else
	(
		cd /opt/openwrt_packit
		sudo git pull
	)
fi

sudo mkdir -p /opt/kernel
sudo cp -vrf beikeyun-kernel/* /opt/kernel/

sudo cp -vrf beikeyun/* /opt/openwrt_packit/

echo OK
