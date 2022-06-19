#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)

mkdir -p $KSROOT/koolclash/chn

curl=$(which curl)
wget=$(which wget)

ipdb_url="https://ispip.clang.cn/all_cn.txt"

rm -rf /tmp/upload/koolclash_log.txt && touch /tmp/upload/koolclash_log.txt
sleep 1

if [ "x$wget" != "x" ] && [ -x $wget ]; then
    command="$wget --no-check-certificate $ipdb_url -O $KSROOT/koolclash/all_cn.txt"
elif [ "x$curl" != "x" ] && [ test -x $curl ]; then
    command="$curl -k --compressed $ipdb_url -o $KSROOT/koolclash/all_cn.txt"
else
    echo_date "没有找到 wget 或 curl，无法更新 CHN 数据库！" >>/tmp/upload/koolclash_log.txt
    http_response 'nodl'
    exit 1
fi

echo_date "开始下载最新 CHN 数据库..." >>/tmp/upload/koolclash_log.txt
$command

if [ ! -f "$KSROOT/koolclash/all_cn.txt" ]; then
    echo_date "下载 CHN 数据库失败！" >>/tmp/upload/koolclash_log.txt
    exit 1
fi

echo_date "下载完成，开始复制" >>/tmp/upload/koolclash_log.txt
cp -rf $KSROOT/koolclash/all_cn.txt $KSROOT/koolclash/chn

version=$(ls --full-time /koolshare/koolclash/all_cn.txt | awk '{print $6}')

cp -rf $KSROOT/koolclash/chn/all_cn.txt $KSROOT/koolclash/config/china_ip_route.ipset

echo_date "更新 CHN 数据库至 $version 版本" >>/tmp/upload/koolclash_log.txt
dbus set koolclash_chn_version=$version

echo_date "清理临时文件..." >>/tmp/upload/koolclash_log.txt
rm -rf $KSROOT/koolclash/all_cn.txt
rm -rf $KSROOT/koolclash/chn

echo_date "CHN 数据库更新完成！" >>/tmp/upload/koolclash_log.txt
echo_date "注意！新版 CHN 数据库将在下次启动 Clash 时生效！" >>/tmp/upload/koolclash_log.txt

sleep 1

echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt

http_response 'ok'
exit 0