#!/usr/bin/env bash

exec 1>/root/autorestore.log 2>&1

echo wait 10
sleep 10

echo 删除自己
sed -E -i '/autorestoreop\.sh/d' /etc/rc.local

echo 查询备份磁盘
backdisk=$(blkid -L backupdisk || blkid -L nlf)
echo 备份磁盘: $backdisk

[ -b "$backdisk" ] || exit 1

echo 挂载备份磁盘
mdir=$(mktemp -d)
mount $backdisk "$mdir"

cd "$mdir"

echo 找到脚本路径
sn=$(find -name 'restoreop.sh' -type f | head -n 1)
echo "$sn"
[ "$sn" ] || exit 2

chmod +x "$sn"

echo 执行
echo $'y\ny' | "$sn"

