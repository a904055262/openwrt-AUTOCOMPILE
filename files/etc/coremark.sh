#!/bin/sh

if [ "$1" = 'firstbenchmark' ];then
	sed -i -E '/coremark\.sh\s+firstbenchmark/d' /etc/crontabs/root
fi

echo 开始执行coremark跑分: 
if ! command -v coremark >/dev/null;then
	echo '你没有安装coremark'
	exit 1
fi

score=$(coremark | grep -iE '^coremark 1\.0' | grep -Eo -m 1 ': [0-9.]+' | grep -Eo '[0-9.]+')
if [ "$score" ];then
	echo "coremark: $score"
	echo " | coremark: $score" > /etc/.coremarkscore
	exit 0
else
	echo 测试失败
	exit 1
fi
