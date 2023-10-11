#!/bin/bash

tags=$(git ls-remote  --tags --refs  https://github.com/openwrt/openwrt v2[0-9].*| awk -F '/' '{print $NF}')
if [ ! "$tags" ];then
	echo 获取版本失败 >&2
	exit 1
fi

#echo "$tags"
tag_l=$(tail -n1 <<< $tags)
#echo $tag_l

if ! grep -q '-' <<< $tag_l;then
	echo $tag_l
	exit
fi

tags_r=$(grep -v '-' <<< $tags)
#echo "$tags_r"
tag_r_l=$(tail -n1 <<< $tags_r)
#echo $tag_r_l

#存在正式版
if [ "$(awk -F '-' '{print $1}' <<< $tag_l)" = "$tag_r_l" ];then
	echo $tag_r_l
else
	echo $tag_l
fi

 