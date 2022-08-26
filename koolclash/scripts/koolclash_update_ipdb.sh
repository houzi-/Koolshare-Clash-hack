#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

mkdir -p $KSROOT/koolclash/ipdb

curl=$(which curl)
wget=$(which wget)

ipdb_url="http://www.ideame.top/mmdb/lite/Country.mmdb"

rm -rf /tmp/upload/koolclash_log.txt && touch /tmp/upload/koolclash_log.txt
sleep 1

if [ "x$wget" != "x" ] && [ -x $wget ]; then
    command="$wget --no-check-certificate $ipdb_url -q -O $KSROOT/koolclash/Country.mmdb"
else
    echo_date "没有找到 wget 或 curl，无法更新 IP 数据库！" >>/tmp/upload/koolclash_log.txt
    http_response 'nodl'
    exit 1
fi

echo_date "开始下载最新 IP 数据库..." >>/tmp/upload/koolclash_log.txt
$command

if [ ! -f "$KSROOT/koolclash/Country.mmdb" ]; then
    echo_date "下载 IP 数据库失败！" >>/tmp/upload/koolclash_log.txt
    exit 1
fi

echo_date "下载完成，开始复制" >>/tmp/upload/koolclash_log.txt
cp -rf $KSROOT/koolclash/Country.mmdb $KSROOT/koolclash/ipdb

chmod 644 $KSROOT/koolclash/ipdb/*
version=$(ls --full-time /koolshare/koolclash/Country.mmdb | awk '{print $6}')

cp -rf $KSROOT/koolclash/ipdb/Country.mmdb $KSROOT/koolclash/config

echo_date "更新 IP 数据库至 $version 版本" >>/tmp/upload/koolclash_log.txt
dbus set koolclash_ipdb_version=$version

echo_date "清理临时文件..." >>/tmp/upload/koolclash_log.txt
rm -rf $KSROOT/koolclash/Country.mmdb
rm -rf $KSROOT/koolclash/ipdb

echo_date "IP 数据库更新完成！" >>/tmp/upload/koolclash_log.txt
echo_date "注意！新版 IP 数据库将在下次启动 Clash 时生效！" >>/tmp/upload/koolclash_log.txt

sleep 1

echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt

http_response 'ok'
exit 0
