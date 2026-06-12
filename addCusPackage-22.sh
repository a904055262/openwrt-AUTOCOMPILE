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


echo -下载luci-app-wechatpush
$gitclone https://github.com/tty228/luci-app-wechatpush $basedir/luci-app-wechatpush



echo -下载bandix
download  https://github.com/timsaya/luci-app-bandix  \
	luci-app-bandix 
	
download  https://github.com/timsaya/openwrt-bandix  \
	openwrt-bandix


echo -下载immortalwrt app
download  https://github.com/immortalwrt/luci  \
	applications/luci-app-dufs 

download  https://github.com/immortalwrt/packages  \
	net/dufs 


echo -下载istoreos miniupnpd luci-app-upnp
find package -type l -name 'miniupnpd'  -delete 
find package -type l -name 'luci-app-upnp'  -delete 

download -b istoreos-24.10 https://github.com/jjm2473/packages \
	net/miniupnpd

download -b istoreos-24.10 https://github.com/jjm2473/luci  \
	applications/luci-app-upnp


echo -下载rtp2httpd
download https://github.com/stackia/rtp2httpd \
	openwrt-support/luci-app-rtp2httpd \
	openwrt-support/rtp2httpd

mv package/cus/luci-app-rtp2httpd/Makefile.versioned package/cus/luci-app-rtp2httpd/Makefile
mv package/cus/rtp2httpd/Makefile.versioned package/cus/rtp2httpd/Makefile

ln -sf ../feeds/luci/luci.mk package/luci.mk
ln -sf ../feeds/packages/lang package/lang

# 修改r8168加载顺序,在usb网卡驱动前加载 openwrt/package/kernel/r8168/Makefile
#AUTOLOAD:=$(call AutoProbe,r8168) > AUTOLOAD:=$(call AutoLoad,36,r8168)
# sed -E -i '/AUTOLOAD:/s/AutoProbe/AutoLoad,36/' package/kernel/r8168/Makefile
# grep 'AUTOLOAD:' package/kernel/r8168/Makefile

# sed -E -i '/AUTOLOAD:/s/AutoProbe/AutoLoad,36/' package/kernel/r8125/Makefile
# grep 'AUTOLOAD:' package/kernel/r8125/Makefile

# sed -E -i '/AUTOLOAD:/s/AutoProbe/AutoLoad,36/' package/kernel/r8126/Makefile
# grep 'AUTOLOAD:' package/kernel/r8126/Makefile


rm -rf tmp


