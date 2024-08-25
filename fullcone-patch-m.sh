#!/usr/bin/env bash

# 大佬打好补丁的包

# 6.6
# https://github.com/immortalwrt/immortalwrt/tree/master/package/libs/libnftnl
# https://github.com/immortalwrt/immortalwrt/tree/master/package/network/utils/fullconenat-nft
# https://github.com/immortalwrt/immortalwrt/tree/master/package/network/config/firewall4
# https://github.com/immortalwrt/immortalwrt/tree/master/package/network/utils/nftables
# https://github.com/immortalwrt/luci/tree/master/applications/luci-app-firewall


#######补丁#######
##6.6
# https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-6.6/952-add-net-conntrack-events-support-multiple-registrant.patch


#脚本所在路径
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

# download -b branch -d tdir repo  dir1 dir2 .. dirN
download(){
	#set -x
	OPTIND=1
	# branch 获取
	local opt branch tdir
	while getopts 'd:b:' opt;do
		case $opt in
			b)
				branch=$OPTARG
			;;
			d)
				tdir=$OPTARG
			;;
			
		esac
	done
	
	[ "$branch" ] && {
		branch=" -b $branch "
	}
	
	if [ ! "$tdir" ];then 
		tdir=$basedir
		if [ ! "$tdir" ];then
			tdir=dldir
		fi
	fi
	
	
	if [ ! -d "$tdir" ];then
		mkdir -p "$tdir"
	fi
	
	shift $(($OPTIND - 1))
	OPTIND=1


	# 下载指定文件夹
	local repo=$1 
	shift 1
	#set +x
	

	local tmpdir=$(mktemp -d)
	
	while ! git clone --no-checkout $branch --depth 1 --filter tree:0  "$repo" "$tmpdir";do
		echo retry clone
		sleep 1
	done
	
	(
		cd "$tmpdir"
		git sparse-checkout set  "$@"
		while ! git checkout ;do
			echo retry checkout
			sleep 1
		done
	)
	
	# 复制到目标文件夹
	local dir
	for dir in "$@";do
		echo "$dir"
		rm -rf "$tdir/$(basename "$dir")"
		mv "$tmpdir/$dir" "$tdir"
	done
	
}


# network > firewall > nftables
# libraries > libnftnl
# base system > firwall4
# kenerl modules > netfilter extensions > kmod-nft-fullcone
# luci > applications > luci-app-firewall


echo '开始下载其他补丁包'

mkdir -p fullconepatch

download -d fullconepatch https://github.com/immortalwrt/immortalwrt \
	package/libs/libnftnl \
	package/network/utils/fullconenat-nft \
	package/network/config/firewall4 \
	package/network/utils/nftables 

download -d fullconepatch https://github.com/immortalwrt/luci \
	applications/luci-app-firewall

echo 下载内核补丁
patches=(
https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-6.6/952-add-net-conntrack-events-support-multiple-registrant.patch
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
['fullconenat-nft']='../package/'
['luci-app-firewall']='../feeds/luci/applications/'
)

for d in *;do
	echo "替换 $d"
	rm -rf "${rPath[$d]}$d"
	cp -rf $d "${rPath[$d]}"
done

rm -rf ../tmp
echo '替换完成'







