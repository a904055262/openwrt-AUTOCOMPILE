#!/usr/bin/env bash
git clone  https://github.com/kongfl888/luci-app-adguardhome package/0/luci-app-adguardhome
svn co  https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/0/luci-app-openclash
svn co  https://github.com/kenzok8/openwrt-packages/trunk/smartdns package/0/smartdns
svn co  https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/0/luci-app-smartdns
git clone --depth=1 https://github.com/fw876/helloworld.git package/0/helloworld
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/0/luci-app-amlogic
svn co https://github.com/immortalwrt/packages/trunk/net/msd_lite package/0/msd_lite
svn co https://github.com/kenzok8/jell/trunk/luci-app-msd_lite package/0/luci-app-msd_lite
