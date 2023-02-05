#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)

curl=$(which curl)
$curl -I -k -s --user-agent "Clash" $koolclash_subconverter_url | grep -i "Subscription-Userinfo:" > /tmp/header.txt

if [ "$koolclash_update_mode" == "2" ]; then
    if grep -i 'Subscription-Userinfo:' /tmp/header.txt >/dev/null 2>&1
    then
        total=$(cat /tmp/header.txt | awk '{printf $4}' | sed -e 's/total=//g' -e 's/;//g')
        down=$(cat /tmp/header.txt | awk '{printf $3}' | sed -e 's/download=//g' -e 's/;//g')
        up=$(cat /tmp/header.txt | awk '{printf $2}' | sed -e 's/upload=//g' -e 's/;//g')
        time=$(cat /tmp/header.txt | awk '{printf $5}' | sed -e 's/expire=//g' -e 's/;//g')
        use_all=$(expr $down + $up)
        val_1=$(expr $total / 1073741824)
        val_2=$(expr $use_all / 1073741824)
        TOTAL=$(echo $val_1)
        USED=$(echo $val_2)
        expiration_time=$(date -d @$time '+%Y-%m-%d')
        dbus set koolclash_sub_expiration_time="<font color=#1bbf35>$expiration_time</font>"
        dbus set koolclash_sub_information="show"
        http_response "$TOTAL>$USED"
	else
        dbus set koolclash_sub_information="hide"
    fi
else
    dbus set koolclash_sub_information="hide"
fi