#!/usr/bin/env bash

sdir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
cd "$sdir"

echo 复制rootfs到/opt/openwrt_packit目录
rootfs=bin/targets/armvirt/64/openwrt-armvirt-64-default-rootfs.tar.gz
if [ ! -e $rootfs ];then
	rootfs=bin/targets/armsr/armv8/openwrt-armsr-armv8-generic-rootfs.tar.gz
fi

if [ ! -e $rootfs ];then
	echo 不存在arm-rootfs文件
	exit 1
fi

if sudo cp -u -v  $rootfs /opt/openwrt_packit/openwrt-armvirt-64-default-rootfs.tar.gz;then
	echo 复制成功
else
	echo 复制失败
fi
