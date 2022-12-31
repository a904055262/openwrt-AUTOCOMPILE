#!/usr/bin/env bash
git clone  https://github.com/kongfl888/luci-app-adguardhome package/0/luci-app-adguardhome
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/0/luci-app-openclash
git clone -b lede  https://github.com/pymumu/luci-app-smartdns package/0/luci-app-smartdns
git clone https://github.com/pymumu/openwrt-smartdns.git package/0/openwrt-smartdns
git clone --depth=1 https://github.com/fw876/helloworld.git package/0/helloworld
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/0/luci-app-amlogic
