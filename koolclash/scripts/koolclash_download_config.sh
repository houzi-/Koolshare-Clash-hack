#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

eval $(dbus export koolclash_)


# 检测是否能够读取面板上传的 Clash
if [ -f $KSROOT/koolclash/config/config.yaml ]; then
    echo_date "开始导出Clash配置！" >>/tmp/upload/koolclash_log.txt
    rm -rf $KSROOT/webs/files/config.yaml
    # 将clash配置文件复制到 files 目录中
    cp $KSROOT/koolclash/config/config.yaml $KSROOT/webs/files/config.yaml
    echo_date "Clash 配置导出成功！" >>/tmp/upload/koolclash_log.txt
    http_response 'success'	
else
    echo_date "没有找到Clash配置文件！退出！" >>/tmp/upload/koolclash_log.txt
    http_response 'notfound'
    exit 1
fi
