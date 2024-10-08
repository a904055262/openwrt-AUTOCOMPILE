#!/usr/bin/env bash
sdir=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)
cd "$sdir"

f=feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

t="Compiled: $(TZ='Asia/Shanghai' date '+%x %T')"

sed -i -E '/Firmware Version/{
	s~,\s*$~ + "'" / $t"'" ,~
}' "$f"

sed -n '/Firmware Version/p' "$f"
