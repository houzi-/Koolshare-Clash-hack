#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

eval $(dbus export koolclash_)

#提取 Clash 配置认证码
secret=$(yq r $KSROOT/koolclash/config/config.yaml secret)
#提取 Clash 配置监听端口和 IP 地址
ipaddr_port=$(yq r $KSROOT/koolclash/config/config.yaml external-controller)

curl -sv \
-H "Authorization: Bearer $secret" \
-X PATCH "http://$ipaddr_port/configs/"  -d "{\"mode\": \"rule\"}" 2>&1

curl -sv \
-H "Authorization: Bearer $secret" \
-X DELETE "http://$ipaddr_port/connections"  2>&1

dbus set koolclash_switch_config_mode=1
yq w -i $KSROOT/koolclash/config/config.yaml mode "rule"
http_response 'rule'
