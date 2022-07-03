#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)

enable=`echo ${2:0:1}`
time=`echo ${2:2}`

dbus set koolclash_update_sub_enable=$enable
dbus set koolclash_update_sub_time=$time

sub_enable=$(dbus get koolclash_update_sub_enable)
sub_time=$(dbus get koolclash_update_sub_time)

rm -rf /tmp/upload/koolclash_log.txt && touch /tmp/upload/koolclash_log.txt
sleep 1

if [ "$koolclash_enable" == "1" ]; then
    if [ "$sub_enable" == "1" ]; then
        [ ! -f  "/etc/crontabs/root" ] && touch /etc/crontabs/root
        CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
        if [ -f "$KSROOT/koolclash/config/sub.sh" ]; then
            sed -i '/koolclash_update_sub_cron/d' /etc/crontabs/root >/dev/null 2>&1
            echo_date "每天 $sub_time 点定时更新 Clash 配置文件命令写入CRON中..." >>/tmp/upload/koolclash_log.txt && echo  "0 $sub_time * * * $KSROOT/scripts/koolclash_update_sub_cron.sh update" >> /etc/crontabs/root
        else
            echo_date "更新 Clash 配置文件命令写入CRON失败！" >>/tmp/upload/koolclash_log.txt
	fi
    else
        CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
        [ ! -z "$CRONTAB_SUB" ] && echo_date "删除定时更新 Clash 配置文件CRON..." >>/tmp/upload/koolclash_log.txt && sed -i '/koolclash_update_sub_cron/d' /etc/crontabs/root >/dev/null 2>&1
    fi
else
    if [ "$sub_enable" == "1" ]; then
        CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
        [ ! -z "$CRONTAB_SUB" ] && echo_date "删除定时更新 Clash 配置文件CRON..." >>/tmp/upload/koolclash_log.txt && sed -i '/koolclash_update_sub_cron/d' /etc/crontabs/root >/dev/null 2>&1
    fi
fi

http_response "ok"
