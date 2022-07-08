#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)

BOM=$(grep -I -r -l $'\xEF\xBB\xBF' $KSROOT/koolclash/config/origin.yml)
if [ -n "$BOM" ]; then
	sed -i $'s/\xef\xbb\xbf//' $KSROOT/koolclash/config/origin.yml
fi

para1=$(sed -n '/^port:/p' $KSROOT/koolclash/config/origin.yml)
para1_1=$(sed -n '/^mixed-port:/p' $KSROOT/koolclash/config/origin.yml)
if [ -n "$para1_1" ] ; then
    sed -i 's/^mixed-port:/port:/g' $KSROOT/koolclash/config/origin.yml
fi

proxies_line=$(cat $KSROOT/koolclash/config/origin.yml | grep -n "^proxies:" | awk -F ":" '{print $1}')
port_line=$(cat $KSROOT/koolclash/config/origin.yml | grep -n "^port:" | awk -F ":" '{print $1}' | head -1)

if [ -z "$port_line" ] ; then
	return 0
fi
if [ -z "$proxies_line" ]; then
	return 0
fi
if [ -z "$para1" ] && [ -z "$para1_1" ]; then
	return 0
else
	return 1
fi	