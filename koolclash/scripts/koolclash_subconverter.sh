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

#---------------------------------------------------------------------
# subconverter在线订阅转换
decode_url_link () {
    local link=$1
    local len=$(echo $link | wc -L)
    local mod4=$(($len%4))

    if [ "$mod4" -gt "0" ]; then
        local var="===="
        local newlink=${link}${var:$mod4}
        echo -n "$newlink" | sed 's/-/+/g; s/_/\//g' | base64_decode -d
    else
        echo -n "$link" | sed 's/-/+/g; s/_/\//g' | base64_decode -d
    fi
}

start_stop_subconverter () {
    sub_process=$(pidof subconverter)
    if [ ! -n "$sub_process" ]; then
        $KSROOT/bin/subconverter/subconverter >/dev/null 2>&1 &
    else
        killall -9 all $KSROOT/bin/subconverter/subconverter >/dev/null 2>&1
    fi
}

sub_url_update () {
    links2=$(echo $url_base64)
    links=$(decode_url_link $links2)
    koolclash_sub_link=$(echo $links | sed -e 's/%0A/%7C/g')
    #curl=$(which curl)
    #wget=$(which wget)
    # 设置subconverter转换订阅URL模式
    dbus set koolclash_update_mode=2
    start_stop_subconverter
    sleep 3s
    subconverter_links="http://127.0.0.1:25500/sub?target=clash&new_name=true&url=$koolclash_sub_link&insert=false&config=ruleconfig%2FZHANG.ini&include=&exclude=&append_type=false&emoji=true&udp=false&fdn=true&sort=true&scv=false&tfo=false"
    UA='Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36'
    $curl -4sSk --user-agent "$UA" --connect-timeout 30 "$subconverter_links" > $KSROOT/koolclash/config/origin.yml
    if [ "$?" == "0" ]; then
        [ ! -s "$KSROOT/koolclash/config/origin.yml" ] && $curl -4sSk --user-agent "$UA" --connect-timeout 30 "$subconverter_links" > $KSROOT/koolclash/config/origin.yml
        if [ ! -s "$KSROOT/koolclash/config/origin.yml" ]; then
            http_response 'fail'
            exit 1
        else
            local blank1=$(cat $KSROOT/koolclash/config/origin.yml | grep -E "Redirecting|301")
            local blank2=$(cat $KSROOT/koolclash/config/origin.yml | grep "The following link doesn't contain any valid node info")		
            if [ -n "$blank1" ]; then
                if [ -n $(echo $subconverter_links | grep -E "^https") ]; then
                    $wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" --no-check-certificate -q -t3 -T30 -4 -O $KSROOT/koolclash/config/origin.yml "$subconverter_links"
                else
                    $wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" -q -t3 -T30 -4 -O $KSROOT/koolclash/config/origin.yml "$subconverter_links"
                fi
            fi
            if [ -n "$blank2" ]; then
                if [ -n $(echo $links | grep -E "^https") ]; then
                    $wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" --no-check-certificate -q -t3 -T30 -4 -O $KSROOT/koolclash/config/origin.yml "$subconverter_links"
                else
                    $wget --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" -q -t3 -T30 -4 -O $KSROOT/koolclash/config/origin.yml "$subconverter_links"
                fi
            fi
        fi

        start_stop_subconverter

        $KSROOT/scripts/koolclash_check_yaml.sh
        if [ $? == "1" ]; then
            sed -i 's/DNS/dns/g' $KSROOT/koolclash/config/origin.yml
            # 配置文件存在Proxy:开头的行数，将Proxy: ~替换成空格
            para0=$(sed -n '/^\.\.\./p' $KSROOT/koolclash/config/origin.yml)
            if [ -n "$para0" ] ; then
                sed -i 's/^\.\.\.//g' $KSROOT/koolclash/config/origin.yml
            fi

            para0=$(sed -n '/^\-\-\-/p' $KSROOT/koolclash/config/origin.yml)
            if [ -n "$para0" ] ; then
                sed -i 's/^\-\-\-//g' $KSROOT/koolclash/config/origin.yml
            fi

            # 配置文件存在Proxy:开头的行数，将Proxy: ~替换成空格
            para1=$(sed -n '/^Proxy: ~/p' $KSROOT/koolclash/config/origin.yml)
            if [ -n "$para1" ] ; then
                sed -i 's/Proxy: ~//g' $KSROOT/koolclash/config/origin.yml
            fi

            para2=$(sed -n '/^Proxy Group: ~/p' $KSROOT/koolclash/config/origin.yml)
            # 配置文件存在Proxy Group:开头的行数，将Proxy Group: ~替换成空格
            if [ -n "$para2" ] ; then
                sed -i 's/Proxy Group: ~//g' $KSROOT/koolclash/config/origin.yml
            fi

            # 配置文件存在奇葩声明，删除，重写
            pg_line=$(grep -n "Proxy Group" $KSROOT/koolclash/config/origin.yml | awk -F ":" '{print $1}' )
            if [ -n "$pg_line" ] ; then
                sed -i "$pg_line d" $KSROOT/koolclash/config/origin.yml
                sed -i "$pg_line i proxy-groups:" $KSROOT/koolclash/config/origin.yml
            fi

            para3=$(sed -n '/Rule: ~/p' $KSROOT/koolclash/config/origin.yml)
            # 配置文件存在Rule:开头的行数，将Rule: ~替换成空格
            if [ -n "$para3" ] ; then
                sed -i 's/Rule: ~//g' $KSROOT/koolclash/config/origin.yml
            fi

            # 配置文件存在Proxy:开头的行数，将Proxy:替换成proxies:
            para1=$(sed -n '/^Proxy:/p' $KSROOT/koolclash/config/origin.yml)
            if [ -n "$para1" ] ; then
                sed -i 's/Proxy:/proxies:/g' $KSROOT/koolclash/config/origin.yml
            fi

            para2=$(sed -n '/^Proxy Group:/p' $KSROOT/koolclash/config/origin.yml)
            # 当文件存在Proxy Group:开头的行数，将Proxy Group:替换成proxy-groups:
            if [ -n "$para2" ] ; then
                sed -i 's/Proxy Group:/proxy-groups:/g' $KSROOT/koolclash/config/origin.yml
            fi

            para3=$(sed -n '/Rule:/p' $KSROOT/koolclash/config/origin.yml)
            # 当文件存在Rule:开头的行数，将Rule:替换成rules:
            if [ -n "$para3" ] ; then
                sed -i 's/Rule:/rules:/g' $KSROOT/koolclash/config/origin.yml
            fi

            para4=$(sed -n '/^mixed-port:/p' $KSROOT/koolclash/config/origin.yml)
            # 当文件存在mixed-port:开头的行数，将mixed-port:替换成port:
            if [ -n "$para4" ] ; then
                sed -i 's/^mixed-port:/port:/g' $KSROOT/koolclash/config/origin.yml
            fi
        else
            http_response 'fail'
            exit 1            
        fi
	else
        start_stop_subconverter
        http_response 'fail'
        exit 1
    fi
}
#---------------------------------------------------------------------

case $2 in
update)
    url=$(echo "$3" | base64 -d)
    url_base64=$(echo "$3")
    curl=$(which curl)
    wget=$(which wget)
	
    if [ "$url" == "" ]; then
        # 你提交个空的上来干嘛？是不是想删掉？
        dbus remove koolclash_subconverter_url
        http_response 'ok'
    else
        dbus set koolclash_subconverter_url="$url"

        cp $KSROOT/koolclash/config/origin.yml $KSROOT/koolclash/config/origin-backup.yml
        rm -rf $KSROOT/koolclash/config/origin.yml

        if [ "x$curl" != "x" ] && [ -x $curl ]; then
            #$curl -L "$sub_url" -o $KSROOT/koolclash/config/origin.yml
            sub_url_update
            sub_time=$(date +%Y-%m-%d\ %X)
            dbus set koolclash_config_version="<font color=#1bbf35>$sub_time</font>"
            sed -i '/^\-\-\-$/ d' $KSROOT/koolclash/config/origin.yml
            sed -i '/^\.\.\.$/ d' $KSROOT/koolclash/config/origin.yml
        else
            http_response 'nocurl'
            cp $KSROOT/koolclash/config/origin-backup.yml $KSROOT/koolclash/config/origin.yml
            exit 1
        fi

        if [ "$(yq r $KSROOT/koolclash/config/origin.yml port | sed 's|[0-9]||g')" == "" ]; then
            # 下载成功了
            rm -rf $KSROOT/koolclash/config/origin-backup.yml

            echo_date "设置 redir-port 和 allow-lan 属性"
            # 覆盖配置文件中的 redir-port 和 allow-lan 的配置
            yq w -i $KSROOT/koolclash/config/origin.yml redir-port 23456
            yq w -i $KSROOT/koolclash/config/origin.yml allow-lan true

            yq w -i $KSROOT/koolclash/config/origin.yml external-controller "$ext_control_ip:6170"
            # 启用 external-ui
            yq w -i $KSROOT/koolclash/config/origin.yml external-ui "/koolshare/webs/koolclash/"
            # 设置 secret
            yq w -i $KSROOT/koolclash/config/origin.yml secret "clash"

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
        else
            # 下载失败了
            rm -rf $KSROOT/koolclash/config/origin.yml
            cp $KSROOT/koolclash/config/origin-backup.yml $KSROOT/koolclash/config/origin.yml
            rm -rf $KSROOT/koolclash/config/origin-backup.yml
            http_response 'fail'
        fi
    fi
    ;;
esac
