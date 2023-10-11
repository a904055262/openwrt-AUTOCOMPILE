#!/usr/bin/env bash
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

echo 开始本地环境准备
chmod +x getLatestTag.sh
version=$(./getLatestTag.sh | tail -n1)

if [ ! "$version" ];then
	echo -获取版本失败
	exit 1
fi

echo "最新RC或者正式版: $version"

git clone -b "$version" --depth=1 https://github.com/openwrt/openwrt.git
if [ $? -ne 0 ];then
	echo -clone代码失败
	exit 2
fi

cd openwrt

echo 更新feeds
./scripts/feeds update -a && ./scripts/feeds install -a || {
	echo -更新feeds失败
	exit 3
}


echo 添加自定义软件包
cp -vf ../addCusPackage-22.sh ./
chmod +x addCusPackage-22.sh
./addCusPackage-22.sh
if [ $? -ne 0 ];then
	echo -添加自定义软件包失败
	exit 4
fi


echo  主页CPU信息补丁
cp -vf ../patch-luci-status.sh ../luci-status-patch.patch ./
chmod +x patch-luci-status.sh
./patch-luci-status.sh

echo  fullcone补丁
cp -vf ../fullcone-patch.sh ./
chmod +x fullcone-patch.sh
./fullcone-patch.sh


echo chinadefault设置
# cp 复制整个文件夹的时候，
# 当目标文件夹存在的时候，  会把源文件夹复制到目标文件夹下
# 当目标文件夹不存在的时候，择把源文件夹里面所有东西复制到目标文件夹下

cp -vrf ../files .

cp -vf ../x86.23.05.config ../arm.23.05.config ../cprootfstobeikeyun.sh ../sh/getdiff.sh ./
chmod +x *.sh

echo OK
