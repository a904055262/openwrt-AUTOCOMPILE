#!/usr/bin/env bash

# 大佬打好补丁的包
# https://github.com/wongsyrone/lede-1/tree/master/package/network/utils/nftables
# https://github.com/wongsyrone/lede-1/tree/master/package/libs/libnftnl
# https://github.com/wongsyrone/lede-1/tree/master/package/network/config/firewall4
# https://github.com/wongsyrone/luci-1/tree/master/applications/luci-app-firewall
# https://github.com/fullcone-nat-nftables/nft-fullcone.git
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch
#脚本所在路径
sdir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
cd "$sdir"


# network > firewall > nftables
# libraries > libnftnl
# base system > firwall4
# kenerl modules > netfilter extensions > kmod-nft-fullcone
# luci > applications > luci-app-firewall

declare -A dlAddr
dlAddr=(
['nftables']='https://github.com/wongsyrone/lede-1/trunk/package/network/utils/nftables'
['libnftnl']='https://github.com/wongsyrone/lede-1/trunk/package/libs/libnftnl'
['firewall4']='https://github.com/wongsyrone/lede-1/trunk/package/network/config/firewall4'
['luci-app-firewall']='https://github.com/wongsyrone/luci-1/trunk/applications/luci-app-firewall'
['nft-fullcone']='https://github.com/fullcone-nat-nftables/nft-fullcone.git'
)

echo '开始下载其他补丁包'

mkdir -p fullconepatch
cd fullconepatch

for d in "${!dlAddr[@]}";do

	if grep -q 'fullcone' <<< $d;then 
		bin='git clone --depth=1'
		binU='git pull'
	else
		bin='svn co'
		binU='svn up'
	fi
	
	echo "-
	下载大佬打过补丁的: $d"
	if [ ! -d $d ];then 
		$bin ${dlAddr[$d]} $d
		if [ $? -ne 0 ];then 
			echo '下载$d失败，脚本退出，请重新运行脚本，尝试重新下载'
			exit 1
		fi
	else 
		echo '发现已经下载好的，尝试更新'
		cd $d
		$binU
		cd - > /dev/null
	fi
done 

echo 下载内核补丁

curl -f -L --connect-timeout 10 -m 90 -O https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch
if [ $? -eq 0 ];then 
	echo 所有补丁包全部就位
else
	echo 下载内核补丁失败
	exit 1
fi


#exit

echo '开始替换源文件'

declare -A rPath
rPath=(
['nftables']='../package/network/utils/'
['libnftnl']='../package/libs/'
['firewall4']='../package/network/config/'
['nft-fullcone']='../package/'
['luci-app-firewall']='../feeds/luci/applications/'
['952-add-net-conntrack-events-support-multiple-registrant.patch']='../target/linux/generic/hack-5.15/'
)

for d in "${!rPath[@]}";do
	echo "替换 $d"
	rm -rf "${rPath[$d]}$d"
	cp -rf $d "${rPath[$d]}"
done

rm -rf ../tmp
echo '替换完成'







