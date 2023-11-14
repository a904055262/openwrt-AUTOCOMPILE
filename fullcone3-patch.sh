#!/usr/bin/env bash

# 大佬打好补丁的包
# https://github.com/immortalwrt/immortalwrt/tree/openwrt-23.05/package/network/utils/fullconenat
# https://github.com/immortalwrt/luci/tree/openwrt-23.05/applications/luci-app-firewall
# https://github.com/immortalwrt/immortalwrt/tree/openwrt-23.05/package/network/config/firewall


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


# base system > firwall
# network > firewall > iptables-mod-fullconenat
# luci > applications > luci-app-firewall

echo '开始下载其他补丁包'

mkdir -p fullcone3patch

download -b openwrt-23.05 -d fullcone3patch https://github.com/immortalwrt/immortalwrt/ \
	package/network/config/firewall \
	package/network/utils/fullconenat 


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

	echo luci-app-firewall 打补丁-成功
	
}

patchlucifirewall


#exit

echo '开始替换源文件'
cd fullcone3patch

declare -A rPath
rPath=(
[firewall]='../package/network/config/'
[fullconenat]='../package/'
)

for d in *;do
	echo "替换 $d"
	rm -rf "${rPath[$d]}$d"
	cp -rf $d "${rPath[$d]}"
done

rm -rf ../tmp
echo '替换完成'







