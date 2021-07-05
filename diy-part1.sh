#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

git clone  https://github.com/jerrykuku/lua-maxminddb package/0/lua-maxminddb
git clone  https://github.com/kongfl888/luci-app-adguardhome package/0/luci-app-adguardhome
git clone  https://github.com/jerrykuku/luci-app-argon-config package/0/luci-app-argon-config
git clone  https://github.com/garypang13/luci-app-eqos package/0/luci-app-eqos
git clone  https://github.com/tty228/luci-app-serverchan package/0/luci-app-serverchan
git clone  https://github.com/jerrykuku/luci-app-vssr package/0/luci-app-vssr
git clone  https://github.com/jerrykuku/luci-theme-argon.git package/0/luci-theme-argon
rm -rf package/lean/luci-theme-argon
#git clone  https://github.com/destan19/OpenAppFilter
git clone  https://github.com/project-openwrt/openwrt-gowebdav.git package/0/openwrt-gowebdav
svn co  https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/0/luci-app-control-timewol
svn co  https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/0/luci-app-control-weburl
svn co  https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/0/luci-app-filebrowser
svn co  https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/0/luci-app-openclash

sed -i "s/LUCI_DEPENDS:=@arm/LUCI_DEPENDS:=/g" package/lean/luci-app-cpufreq/Makefile
