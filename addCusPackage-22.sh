#!/usr/bin/env bash
sdir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
cd "$sdir"

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-autoreboot package/cus/luci-app-autoreboot
svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-vsftpd package/cus/luci-app-vsftpd
svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-cpufreq package/cus/luci-app-cpufreq

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-gowebdav package/cus/luci-app-gowebdav 
svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/gowebdav package/cus/gowebdav
ln -sf ../feeds/packages/lang package/lang

#svn co https://github.com/brvphoenix/luci-app-wrtbwmon/trunk/luci-app-wrtbwmon package/cus/luci-app-wrtbwmon
#svn co https://github.com/brvphoenix/wrtbwmon/branches/new/wrtbwmon package/cus/wrtbwmon

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-uugamebooster package/cus/luci-app-uugamebooster
svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/uugamebooster package/cus/uugamebooster 

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-timewol package/cus/luci-app-timewol

git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/cus/luci-app-wechatpush 
git clone -b js --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/cus/luci-app-unblockneteasemusic
git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata package/cus/luci-app-netdata


svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-usb-printer package/cus/luci-app-usb-printer
#svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/p910nd package/cus/p910nd

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-socat package/cus/luci-app-socat
#svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/socat package/cus/socat

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-msd_lite package/cus/luci-app-msd_lite
svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/net/msd_lite package/cus/msd_lite

svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/applications/luci-app-cpulimit package/cus/luci-app-cpulimit 
svn co https://github.com/immortalwrt/packages/branches/openwrt-23.05/utils/cpulimit package/cus/cpulimit



ln -sf ../feeds/luci/luci.mk package/luci.mk
rm -rf tmp
