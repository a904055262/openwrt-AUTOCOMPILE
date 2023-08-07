#!/usr/bin/env bash

#额外软件包目录
pf=package/cus/
echo 额外软件包目录：$pf

#脚本所在目录
shdir=$(cd $(dirname $0); pwd)
echo "脚本所在目录："$shdir

cd $shdir

echo "删除tmp文件夹"
rm -rf tmp
echo ----------
update(){

	[ ! "$1" ] && {
		echo 没有命令
		return 
	}
	
	local x
	echo $2："$1"
	for x in `seq 3`;do
		
		echo 开始第$x次尝试
		if $1 ;then 
			echo "升级成功"
			return 0
		else
			echo "升级失败"
		fi
	done
	echo "多次升级失败，脚本退出，请过段时间重试"
	exit 1
}

[ "$1" != 'true' ] && {
	update 'git pull' 'lede'
	update './scripts/feeds update -a' 'feed'
	update './scripts/feeds install -a ' 'feed'

	#echo 删除自带包
	#./delori.sh

}

if [ -d $pf ];then 
	echo 开始升级$pf的自定义包
	cd $pf

	for pack in $(ls);do
		if [ -d $pack ];then
			if [ -d $pack/.git ];then 
				cd $pack
				update "git pull" $pack
				cd ..
			elif [ -d $pack/.svn ];then
				cd $pack
				update "svn up" $pack
				cd ..
			fi
		fi
	done

fi
echo 全部升级成功！
