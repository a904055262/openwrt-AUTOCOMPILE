#!/usr/bin/env bash
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

basedir=package/cus
mkdir -p $basedir

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



gitclone='git clone --depth 1 --filter tree:0 '

echo -下载luci-app-ipv6clientfilter
$gitclone https://github.com/a904055262/luci-app-ipv6clientfilter $basedir/luci-app-ipv6clientfilter
echo -下载luci-app-wechatpush
$gitclone https://github.com/tty228/luci-app-wechatpush $basedir/luci-app-wechatpush
echo -下载luci-app-unblockneteasemusic
$gitclone -b js  https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git $basedir/luci-app-unblockneteasemusic


echo -下载immortalwrt app
download -b openwrt-23.05 https://github.com/immortalwrt/luci  \
	applications/luci-app-cpufreq \
	applications/luci-app-gowebdav \
	applications/luci-app-uugamebooster \
	applications/luci-app-usb-printer \
	applications/luci-app-socat \
	applications/luci-app-msd_lite \
	applications/luci-app-cpulimit
	
download -b openwrt-23.05 https://github.com/immortalwrt/packages  \
	net/gowebdav \
	net/uugamebooster \
	net/msd_lite \
	utils/cpulimit

echo -下载luci-app-openclash
download -b dev https://github.com/vernesong/OpenClash     luci-app-openclash

echo -下载wrtbwmon luci-app-wrtbwmon
download -b new https://github.com/brvphoenix/wrtbwmon  wrtbwmon
download  https://github.com/brvphoenix/luci-app-wrtbwmon  luci-app-wrtbwmon


echo -下载istoreos miniupnpd luci-app-upnp
find package -type l -name 'miniupnpd'  -delete 
find package -type l -name 'luci-app-upnp'  -delete 

download -b istoreos-23.05 https://github.com/jjm2473/packages    net/miniupnpd
download -b istoreos-23.05 https://github.com/jjm2473/luci    applications/luci-app-upnp

# echo -下载passwall2
# download  https://github.com/xiaorouji/openwrt-passwall2  luci-app-passwall2

# echo -下载passwall2 依赖
# download https://github.com/xiaorouji/openwrt-passwall-packages  \
	# tcping brook hysteria naiveproxy \
	# shadowsocks-rust \
	# shadowsocksr-libev \
	# simple-obfs tuic-client v2ray-plugin gn 
	


ln -sf ../feeds/luci/luci.mk package/luci.mk
ln -sf ../feeds/packages/lang package/lang

rm -rf tmp


