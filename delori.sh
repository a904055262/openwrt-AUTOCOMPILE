#!/usr/bin/env bash
echo 删除原来的包
#find package/feeds/ | grep smartdns  | xargs rm -rf
#find package/feeds/ | grep mosdns  | xargs rm -rf
find ./package/feeds/ -name 'smartdns'  -type l -exec rm -rf {} \;
find ./package/feeds/ -name 'luci-app-mosdns'  -type l -exec rm -rf {} \;
find ./package/feeds/ -name 'mosdns'  -type l -exec rm -rf {} \;
