#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)
# From Koolshare DMZ Plugin
lan_ip=$(ubus call network.interface.lan status | jsonfilter -e '@["ipv4-address"][0].address')
wan_ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

fallbackdns=$(cat $KSROOT/koolclash/config/dns.yml)

# 如果没有外部监听控制就使用 LAN IP:6170
if [ ! -n "$koolclash_api_host" ]; then
    dbus remove koolclash_api_host
    ext_control_ip=$lan_ip
else
    ext_control_ip=$koolclash_api_host
fi

#---------------------------------------------------------------------
# 强制覆盖 DNS、Fake-IP 的设置

overwrite_dns_config() {
    # 确保启用 DNS
    yq w -i $KSROOT/koolclash/config/config.yaml dns.enable "true"
    # 修改端口
    yq w -i $KSROOT/koolclash/config/config.yaml dns.listen "0.0.0.0:23453"
    # 修改模式
    yq w -i $KSROOT/koolclash/config/config.yaml dns.enhanced-mode "fake-ip"
    # Fake IP Range
    yq w -i $KSROOT/koolclash/config/config.yaml dns.fake-ip-range "198.18.0.1/16"
}
#---------------------------------------------------------------------

start_clash() {
    echo_date "启动 Clash 进程..."
    start-stop-daemon -S -q -b -m \
        -p /tmp/run/koolclash.pid \
        -x $KSROOT/bin/clash \
        -- -d $KSROOT/koolclash/config/
}

start_clash_watchdog() {
    if [ "$koolclash_watchdog_enable" == "1" ]; then
        echo_date "启动 Clash 看门狗进程守护..."
        start-stop-daemon -S -q -b -m \
            -p /tmp/run/koolclash.pid \
            -x $KSROOT/scripts/koolclash_watchdog.sh
    fi
}

kill_clash() {
    [ -n "$(ps | grep koolclash_watchdog.sh | grep -v grep | awk '{print $1}')" ] && echo_date "关闭 Clash 看门狗..." && kill -9 $(ps | grep koolclash_watchdog.sh | grep -v grep | awk '{print $1}') >/dev/null 2>&1 
    [ -n "$(pidof clash)" ] && echo_date "关闭 Clash 进程..." && killall clash >/dev/null 2>&1 
}

case $1 in
update)
    sub_url=$(dbus get koolclash_suburl | sed -e 's;?;\\?;g' -e 's;&;\\&;g')
    curl=$(which curl)

    cp $KSROOT/koolclash/config/origin.yml $KSROOT/koolclash/config/origin-backup.yml
    rm -rf $KSROOT/koolclash/config/origin.yml

    if [ "x$curl" != "x" ] && [ -x $curl ]; then
        #$curl -L "$sub_url" -o $KSROOT/koolclash/config/origin.yml
		$KSROOT/scripts/koolclash_update_yaml.sh
		$KSROOT/koolclash/config/sub.sh
        sed -i '/^\-\-\-$/ d' $KSROOT/koolclash/config/origin.yml
        sed -i '/^\.\.\.$/ d' $KSROOT/koolclash/config/origin.yml
    else
        http_response 'nocurl'
        echo_date "路由器中没有 CURL 不能更新配置文件！"
        cp $KSROOT/koolclash/config/origin-backup.yml $KSROOT/koolclash/config/origin.yml
        exit 1
    fi

    if [ "$(yq r $KSROOT/koolclash/config/origin.yml port | sed 's|[0-9]||g')" == "" ]; then
        # 下载成功了
        echo_date "下载 Clash 配置文件成功！"
        rm -rf $KSROOT/koolclash/config/origin-backup.yml

        echo_date "设置 redir-port 和 allow-lan 属性"
        # 覆盖配置文件中的 redir-port 和 allow-lan 的配置
        yq w -i $KSROOT/koolclash/config/origin.yml redir-port 23456
        yq w -i $KSROOT/koolclash/config/origin.yml allow-lan true

        yq w -i $KSROOT/koolclash/config/origin.yml external-controller "$ext_control_ip:6170"
        # 启用 external-ui
        yq w -i $KSROOT/koolclash/config/origin.yml external-ui "/koolshare/webs/koolclash/"
		
        # Change proxy mode
        if [ "$koolclash_switch_config_mode" == "1" ]; then
            yq w -i $KSROOT/koolclash/config/origin.yml mode "rule"
        elif [ "$koolclash_switch_config_mode" == "2" ]; then
            yq w -i $KSROOT/koolclash/config/origin.yml mode "global"
        elif [ "$koolclash_switch_config_mode" == "3" ]; then
            yq w -i $KSROOT/koolclash/config/origin.yml mode "direct"
        fi		

        cp $KSROOT/koolclash/config/origin.yml $KSROOT/koolclash/config/config.yaml

        # 判断是否存在 DNS 字段、DNS 是否启用、DNS 是否使用 redir-host / fake-ip 模式
        if [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enable) == 'true' ] && [[ $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'fake-ip' || $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'redir-host' ]]; then
            if [ "$koolclash_dnsmode" == "2" ] && [ -n "$fallbackdns" ]; then
                # dnsmode 是 2 应该用自定义 DNS 配置进行覆盖
                echo_date "删除 Clash 配置文件中原有的 DNS 配置"
                yq d -i $KSROOT/koolclash/config/config.yaml dns

                echo_date "将提交的自定义 DNS 设置覆盖 Clash 配置文件..."
                # 将后备 DNS 配置以覆盖的方式与 config.yaml 合并
                yq m -x -i $KSROOT/koolclash/config/config.yaml $KSROOT/koolclash/config/dns.yml
				yq m -x -i $KSROOT/koolclash/config/config.yaml $KSROOT/koolclash/config/profile.yml
                dbus set koolclash_dnsmode=2
            else
                # 可能 dnsmode 是 2 但是没有自定义 DNS 配置；或者本来之前就是 1
                dbus set koolclash_dnsmode=1
            fi


            overwrite_dns_config
            echo_date "Clash 配置文件上传成功！"
            http_response 'success'
        else
            echo_date "在 Clash 配置文件中没有找到 DNS 配置！"
            if [ ! -n "$fallbackdns" ]; then
                echo_date "没有找到后备 DNS 配置！请前往「配置文件」提交后备 DNS 配置！"
                # 设置 DNS Mode 为 3
                dbus set koolclash_dnsmode=3
                http_response 'nofallbackdns'
            else
                echo_date "找到后备 DNS 配置！合并到 Clash 配置文件中..."

                dbus set koolclash_dnsmode=4
                # 将后备 DNS 配置以覆盖的方式与 config.yaml 合并
                echo_date "删除 Clash 配置文件中原有的 DNS 配置"
                yq d -i $KSROOT/koolclash/config/config.yaml dns
                yq m -x -i $KSROOT/koolclash/config/config.yaml $KSROOT/koolclash/config/dns.yml
				yq m -x -i $KSROOT/koolclash/config/config.yaml $KSROOT/koolclash/config/profile.yml

                overwrite_dns_config

                echo_date "Clash 配置文件上传成功！"
                http_response 'success'
            fi
        fi

        kill_clash
        start_clash
        sleep 1
        start_clash_watchdog
    else
        # 下载失败了
		echo_date "Clash 配置文件下载失败！"
        rm -rf $KSROOT/koolclash/config/origin.yml
        cp $KSROOT/koolclash/config/origin-backup.yml $KSROOT/koolclash/config/origin.yml
        rm -rf $KSROOT/koolclash/config/origin-backup.yml
        http_response 'fail'
    fi
    ;;
esac
