#!/usr/bin/env bash

# 大佬打好补丁的包
# https://github.com/wongsyrone/lede-1/tree/master/package/network/utils/nftables
# https://github.com/wongsyrone/lede-1/tree/master/package/libs/libnftnl
# https://github.com/wongsyrone/lede-1/tree/master/package/network/config/firewall4
# https://github.com/wongsyrone/luci-1/tree/master/applications/luci-app-firewall
### https://github.com/fullcone-nat-nftables/nft-fullcone.git
# https://github.com/wongsyrone/lede-1/tree/master/package/external/nft-fullcone

#######补丁#######
##5.15
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/982-add-bcm-fullconenat-support.patch
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/983-bcm-fullconenat-mod-nft-masq.patch
##6.1
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/982-add-bcm-fullconenat-support.patch
# https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/983-bcm-fullconenat-mod-nft-masq.patch


#脚本所在路径
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
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
#['luci-app-firewall']='https://github.com/wongsyrone/luci-1/trunk/applications/luci-app-firewall'
['nft-fullcone']='https://github.com/wongsyrone/lede-1/trunk/package/external/nft-fullcone'
)

echo '开始下载其他补丁包'

mkdir -p fullconepatch
cd fullconepatch

for d in "${!dlAddr[@]}";do
	echo "-下载大佬打过补丁的: $d"
	rm -rf $d
	
	for i in {1..100};do
		echo $i
		
		if svn export "${dlAddr[$d]}" $d >/dev/null;then
			echo -成功
			break
		fi
		
		if (( i == 100));then 
			echo "下载$d失败，脚本退出，请重新运行脚本，尝试重新下载"
			exit 1
		fi
		
		sleep 1
		
		let i++ 
	done

done 

cd ..

patchlucifirewall(){
	# 给luci-app-firewall 打补丁
	echo 开始给 luci-app-firewall 打补丁

	local zonejs=feeds/luci/applications/luci-app-firewall/htdocs/luci-static/resources/view/firewall/zones.js
	if [ ! -f $zonejs ];then
		echo 找不到zonejs
		exit 1
	fi

	if grep -q 'Full-cone' $zonejs;then
		echo 已经打过了
		return 0
	fi

	cp $zonejs $zonejs.bak 

	local tmf=$(mktemp)
	cat <<-'EOF' > $tmf
		o = s.option(form.Flag, 'fullcone', _('Full-cone NAT'));
		o.rmempty = false;
		o.default = '0';
        o = s.option(form.Flag, 'brcmfullcone', _('broadcom Full-cone'));
		o.optional = true;
		o.depends('fullcone','1');
	EOF

	#cat $tmf

	local linenum=$(sed -n '/drop_invalid/{
			=;q
		}' $zonejs)
	if [ ! "$linenum" ];then
		echo 找不到修改点
		exit 1
	fi

	sed -i "$linenum r $tmf
		" $zonejs

	cat <<-'EOF' > $tmf
		o = s.taboption('general', form.Flag, 'fullcone4', _('IPv4 Full-cone NAT'));
		o.modalonly = true;
		o = s.taboption('general', form.Flag, 'fullcone6', _('IPv6 Full-cone NAT'));
		o.modalonly = true;
	EOF

	linenum=$(sed -n '/MSS clamping/{
			=;q
		}' $zonejs)

	if [ ! "$linenum" ];then
		echo 找不到修改点
		exit 1
	fi

	let linenum--

	sed -i "$linenum r $tmf
		" $zonejs

	echo luci-app-firewall 打补丁-成功
	
}

patchlucifirewall

echo 下载内核补丁
patches=(
#5.15
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/952-add-net-conntrack-events-support-multiple-registrant.patch
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/982-add-bcm-fullconenat-support.patch
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-5.15/983-bcm-fullconenat-mod-nft-masq.patch
##6.1
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/952-add-net-conntrack-events-support-multiple-registrant.patch
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/982-add-bcm-fullconenat-support.patch
https://raw.githubusercontent.com/wongsyrone/lede-1/master/target/linux/generic/hack-6.1/983-bcm-fullconenat-mod-nft-masq.patch
)


for p in "${patches[@]}";do
	echo 下载: $p
	
	patchver=$(sed -nE 's,.+/generic/(hack-[^/]+)/.+,\1,p' <<< $p)
	
	[ "$patchver" ] || continue
	
	mkdir -p target/linux/generic/$patchver
	cd target/linux/generic/$patchver

	if curl -sSfL --retry 3 --connect-timeout 5 -m 15 -O $p;then
		echo -补丁下载成功
		cd - > /dev/null
	else
		echo -补丁下载失败
		exit 1
	fi
	
done


#exit

echo '开始替换源文件'
cd fullconepatch

declare -A rPath
rPath=(
['nftables']='../package/network/utils/'
['libnftnl']='../package/libs/'
['firewall4']='../package/network/config/'
['nft-fullcone']='../package/'
['luci-app-firewall']='../feeds/luci/applications/'
)

for d in $(ls);do
	echo "替换 $d"
	rm -rf "${rPath[$d]}$d"
	cp -rf $d "${rPath[$d]}"
done

rm -rf ../tmp
echo '替换完成'







