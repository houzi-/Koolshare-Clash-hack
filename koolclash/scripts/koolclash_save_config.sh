#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

eval $(dbus export koolclash_)

# 从 DMZ 插件抄来的获取 LAN/WAN IP
lan_ip=$(ubus call network.interface.lan status | jsonfilter -e '@["ipv4-address"][0].address')
wan_ip=$(ubus call network.interface.wan status | grep \"address\" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
# fallback dns
fallbackdns=$(cat $KSROOT/koolclash/config/dns.yml)

# 检测是否能够读取面板上传的 Clash
if [ "$(cat /tmp/upload/clash.config.yaml)" == "undefined" ]; then
    echo_date "没有找到上传的配置文件！退出！"
    http_response 'notfound'
    exit 1
else
    echo_date "开始上传配置！"
    mkdir -p $KSROOT/koolclash/config/
    # 将上传的文件复制到 Config 目录中
    cp /tmp/upload/clash.config.yaml $KSROOT/koolclash/config/origin.yml
    sub_time=$(date +%Y-%m-%d\ %X)
    dbus set koolclash_config_version="<font color="#1bbf35">$sub_time</font>"
fi
# 删除 tmp 目录中上传的配置文件
rm -rf /tmp/upload/clash.config.yaml

sed -i '/^\-\-\-$/ d' $KSROOT/koolclash/config/origin.yml
sed -i '/^\.\.\.$/ d' $KSROOT/koolclash/config/origin.yml

echo_date "设置 redir-port 和 allow-lan 属性"
# 覆盖配置文件中的 redir-port 和 allow-lan 的配置
yq w -i $KSROOT/koolclash/config/origin.yml redir-port 23456
yq w -i $KSROOT/koolclash/config/origin.yml allow-lan true

# Change proxy mode
if [ "$koolclash_switch_config_mode" == "1" ]; then
    yq w -i $KSROOT/koolclash/config/origin.yml mode "Rule"
elif [ "$koolclash_switch_config_mode" == "2" ]; then
    yq w -i $KSROOT/koolclash/config/origin.yml mode "Global"
elif [ "$koolclash_switch_config_mode" == "3" ]; then
    yq w -i $KSROOT/koolclash/config/origin.yml mode "Direct"
fi

# 如果没有外部监听控制就使用 LAN IP:6170
if [ ! -n "$koolclash_api_host" ]; then
    dbus remove koolclash_api_host
    ext_control_ip=$lan_ip
else
    ext_control_ip=$koolclash_api_host
fi

yq w -i $KSROOT/koolclash/config/origin.yml external-controller "$ext_control_ip:6170"
# 启用 external-ui
yq w -i $KSROOT/koolclash/config/origin.yml external-ui "/koolshare/webs/koolclash/"
# 设置 secret
yq w -i $KSROOT/koolclash/config/origin.yml secret "clash"

cp $KSROOT/koolclash/config/origin.yml $KSROOT/koolclash/config/config.yaml

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

[ ! -z "$koolclash_firewall_blackip_base64" ] && dbus set koolclash_firewall_blackip_enable=1
[ ! -z "$koolclash_firewall_blackdomain_base64" ] && dbus set koolclash_firewall_blackdomain_enable=1