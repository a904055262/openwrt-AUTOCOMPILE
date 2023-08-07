#!/usr/bin/env bash
make ./package/feeds/luci/luci-base/clean -j8
make ./package/feeds/luci/luci-mod-status/clean -j8

make ./package/feeds/luci/luci-base/compile -j8
make ./package/feeds/luci/luci-mod-status/compile -j8
