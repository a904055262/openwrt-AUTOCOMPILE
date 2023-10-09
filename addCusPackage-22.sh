#!/usr/bin/env bash
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

download() {
	echo 命令: "$@"
	
	local i 
	for i in {1..3};do
		echo $i
		
		if "$@" >/dev/null ;then
			echo -成功
			break
		fi
		
		if ((i == 3));then
			echo -失败
			exit 1
		fi
		
		sleep 1
		let i++
	done
	
}

basedir=package/cus
mkdir -p $basedir

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-autoreboot $basedir/luci-app-autoreboot
download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-vsftpd $basedir/luci-app-vsftpd
download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-cpufreq $basedir/luci-app-cpufreq
download svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash $basedir/luci-app-openclash

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-gowebdav $basedir/luci-app-gowebdav 
download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/gowebdav $basedir/gowebdav
ln -sf ../feeds/packages/lang package/lang

#download svn co https://github.com/brvphoenix/luci-app-wrtbwmon/trunk/luci-app-wrtbwmon $basedir/luci-app-wrtbwmon
#download svn co https://github.com/brvphoenix/wrtbwmon/branches/new/wrtbwmon $basedir/wrtbwmon

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-uugamebooster $basedir/luci-app-uugamebooster
download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/uugamebooster $basedir/uugamebooster 

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-timewol $basedir/luci-app-timewol

download git clone --depth=1 https://github.com/tty228/luci-app-wechatpush $basedir/luci-app-wechatpush 
download git clone -b js --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git $basedir/luci-app-unblockneteasemusic
download git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata $basedir/luci-app-netdata


download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-usb-printer $basedir/luci-app-usb-printer
#download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/p910nd $basedir/p910nd

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-socat $basedir/luci-app-socat
#download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/socat $basedir/socat

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-msd_lite $basedir/luci-app-msd_lite
download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/msd_lite $basedir/msd_lite

download svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-cpulimit $basedir/luci-app-cpulimit 
download svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/utils/cpulimit $basedir/cpulimit

find package -type l -name 'miniupnpd'  -delete 
find package -type l -name 'luci-app-upnp'  -delete 
download svn co https://github.com/jjm2473/packages/branches/istoreos-23.05/net/miniupnpd $basedir/miniupnpd
download svn co https://github.com/jjm2473/luci/branches/istoreos-23.05/applications/luci-app-upnp $basedir/luci-app-upnp

ln -sf ../feeds/luci/luci.mk package/luci.mk

rm -rf tmp


