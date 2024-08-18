#!/usr/bin/env bash

exec 1>/root/autorestore.log 2>&1

echo wait 20s
sleep 20

echo 删除自己
sed -E -i '/autorestoreop\.sh/d' /etc/rc.local

echo 查询备份磁盘
backdisk=$(lsblk -o path,label | grep 'backupdisk' | head -n1 |awk '{print $1}')
echo 备份磁盘: $backdisk

[ "$backdisk" ] || exit 1

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

