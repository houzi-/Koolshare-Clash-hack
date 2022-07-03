#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

eval $(dbus export koolclash_)


dbus set koolclash_switch_config_mode=3
yq w -i $KSROOT/koolclash/config/config.yaml mode "direct"
http_response 'direct'
