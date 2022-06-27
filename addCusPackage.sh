#!/usr/bin/env bash
git clone  https://github.com/kongfl888/luci-app-adguardhome package/0/luci-app-adguardhome
svn co  https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/0/luci-app-openclash
svn co  https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall package/0/luci-app-passwall
svn co  https://github.com/kenzok8/openwrt-packages/trunk/smartdns package/0/smartdns
svn co  https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/0/luci-app-smartdns
git clone --depth=1 https://github.com/fw876/helloworld.git package/0/helloworld
git clone https://github.com/xiaorouji/openwrt-passwall package/0/passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 package/0/openwrt-passwall2
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/0/luci-app-amlogic
