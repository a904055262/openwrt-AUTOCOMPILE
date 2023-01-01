#!/usr/bin/env bash
find package/feeds/ | grep smartdns  | xargs rm -rf
find package/feeds/ | grep mosdns  | xargs rm -rf