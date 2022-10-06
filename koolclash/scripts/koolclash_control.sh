#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export koolclash_)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
lan_ip=$(ubus call network.interface.lan status | jsonfilter -e '@["ipv4-address"][0].address')
wan_ip=$(ubus call network.interface.wan status | jsonfilter -e '@["ipv4-address"][0].address')

ONSTART=$(ps -l | grep $PPID | grep -v grep | grep "S99koolclash")

#get_lan_cidr() {
#    netmask=$(uci get network.lan.netmask)
#    # Assumes there's no "255." after a non-255 byte in the mask
#    local x=${netmask##*255.}
#    set -- 0^^^128^192^224^240^248^252^254^ $(((${#netmask} - ${#x}) * 2)) ${x%%.*}
#    x=${1%%$3*}
#    suffix=$(($2 + (${#x} / 4)))
#    prefix=$(ubus call network.interface.lan status | jsonfilter -e '@["ipv4-address"][0].address' | cut -d "." -f1,2,3)
#    echo $prefix.0/$suffix
#}

#--------------------------------------------------------------------------
#restore_dnsmasq_conf() {
#    echo_date "删除 KoolClash 的 dnsmasq 配置..."
#    rm -rf /tmp/dnsmasq.d/koolclash.conf
#
#    echo_date "还原 DHCP/DNS 中 resolvfile 配置..."
#    uci set dhcp.@dnsmasq[0].resolvfile=/tmp/resolv.conf.auto
#    uci set dhcp.@dnsmasq[0].noresolv=0
#    uci commit dhcp
#}

restore_start_file() {
    echo_date "删除 KoolClash 的防火墙配置"

    uci -q batch <<-EOT
	  delete firewall.ks_koolclash
	  commit firewall
	EOT
}

kill_process() {
    if [ -n "$(ps | grep koolclash_watchdog.sh | grep -v grep | awk '{print $1}')" ]; then
        echo_date "关闭 Clash 看门狗..."
        kill -9 $(ps | grep koolclash_watchdog.sh | grep -v grep | awk '{print $1}') >/dev/null 2>&1
    fi
    if [ -n "$(pidof clash)" ]; then
        echo_date "关闭 Clash 进程..."
        killall clash
    fi
    #if [ -n "$(ps | grep clash | grep -v grep | awk '{print $1}')" ]; then
    #    echo_date "关闭 Clash 其它进程..."
    #    kill -9 $(ps | grep clash | grep -v grep | awk '{print $1}') >/dev/null 2>&1
    #fi
}

#create_dnsmasq_conf() {
#    echo_date "删除 DHCP/DNS 中 resolvfile 和 cachesize 配置"
#    dhcp_server=$(uci get dhcp.@dnsmasq[0].server 2>/dev/null)
#    if [ $dhcp_server ]; then
#        uci delete dhcp.@dnsmasq[0].server >/dev/null 2>&1
#    fi
#    uci delete dhcp.@dnsmasq[0].resolvfile
#    uci delete dhcp.@dnsmasq[0].cachesize
#    uci set dhcp.@dnsmasq[0].noresolv=1
#    uci commit dhcp
#
#    touch /tmp/dnsmasq.d/koolclash.conf
#    echo_date "修改 dnsmasq 配置使 dnsmasq 将所有的 DNS 请求转发给 Clash"
#    echo "no-resolv" >>/tmp/dnsmasq.d/koolclash.conf
#    echo "server=127.0.0.1#23453" >>/tmp/dnsmasq.d/koolclash.conf
#    echo "cache-size=0" >>/tmp/dnsmasq.d/koolclash.conf
#}

load_rule_mode() {
    if [ "$(cat /koolshare/koolclash/config/config.yaml | grep "mode: Rule")" == "mode: Rule" ]; then
        echo_date "代理模式为 Rule"
        dbus set koolclash_switch_config_mode=1
    fi
    if [ "$(cat /koolshare/koolclash/config/config.yaml | grep "mode: Global")" == "mode: Global" ]; then
        echo_date "代理模式为 Global"
        dbus set koolclash_switch_config_mode=2
    fi
    if [ "$(cat /koolshare/koolclash/config/config.yaml | grep "mode: Direct")" == "mode: Direct" ]; then
        echo_date "代理模式为 Direct"
        dbus set koolclash_switch_config_mode=3
    fi
}

node_memory() {
    if [ "$koolclash_node_memory_enable" == "1" ]; then
        yq w -i $KSROOT/koolclash/config/config.yaml profile.store-selected "true"
	else
        yq w -i $KSROOT/koolclash/config/config.yaml profile.store-selected "false"        
	fi
}

restart_dnsmasq() {
    # Restart dnsmasq
    echo_date "重启 dnsmasq..."
    /etc/init.d/dnsmasq restart >/dev/null 2>&1
}

dns_forward() {
    touch /tmp/dnsmasq.d/koolclash.conf
    echo "no-resolv" >>/tmp/dnsmasq.d/koolclash.conf
    echo "server=127.0.0.1#23453" >>/tmp/dnsmasq.d/koolclash.conf
    echo "cache-size=0" >>/tmp/dnsmasq.d/koolclash.conf
    restart_dnsmasq
}

del_dns_forward() {
    rm -rf /tmp/dnsmasq.d/koolclash.conf >/dev/null 2>&1
    restart_dnsmasq
}

#--------------------------------------------------------------------------------------
auto_start() {
    # nat start
    echo_date "添加 KoolClash 防火墙规则"
    uci -q batch <<-EOT
	  delete firewall.ks_koolclash
	  set firewall.ks_koolclash=include
	  set firewall.ks_koolclash.type=script
	  set firewall.ks_koolclash.path=/koolshare/scripts/koolclash_control.sh
	  set firewall.ks_koolclash.family=any
	  set firewall.ks_koolclash.reload=1
	  commit firewall
	EOT

    if [ -L "/etc/rc.d/S99koolclash.sh" ]; then
        rm -rf /etc/rc.d/S99koolclash.sh
    fi
    ln -sf $KSROOT/init.d/S99koolclash.sh /etc/rc.d/S99koolclash.sh
}

#--------------------------------------------------------------------------------------
start_clash_process() {
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

#--------------------------------------------------------------------------
flush_nat() {
    echo_date "删除 KoolClash 添加的 iptables 规则"
    # flush iptables rules
    iptables -t nat -D PREROUTING -p tcp -j koolclash >/dev/null 2>&1
    iptables -t nat -D PREROUTING -d 8.8.4.4/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456 >/dev/null 2>&1
    iptables -t nat -D PREROUTING -d 8.8.8.8/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456 >/dev/null 2>&1
    iptables -t nat -D PREROUTING -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1
    iptables -t nat -D PREROUTING -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1
    iptables -t mangle -D PREROUTING -p udp -j koolclash >/dev/null 2>&1

    iptables -t nat -D OUTPUT -j koolclash_output >/dev/null 2>&1
    iptables -t nat -D OUTPUT -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1
    iptables -t nat -D OUTPUT -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1

    iptables -t nat -F koolclash >/dev/null 2>&1 && iptables -t nat -X koolclash >/dev/null 2>&1
    iptables -t nat -F koolclash_output >/dev/null 2>&1 && iptables -t nat -X koolclash_output >/dev/null 2>&1
    iptables -t mangle -F koolclash >/dev/null 2>&1 && iptables -t mangle -X koolclash >/dev/null 2>&1	

    echo_date "删除 KoolClash 添加的 ipset 名单"
    # flush ipset rules
    ipset -F koolclash_white >/dev/null 2>&1 && ipset -X koolclash_white >/dev/null 2>&1
    ipset -F koolclash_chn_white >/dev/null 2>&1 && ipset -X koolclash_chn_white >/dev/null 2>&1
    ipset -F koolclash_white_ac_ips >/dev/null 2>&1 && ipset -X koolclash_white_ac_ips >/dev/null 2>&1
    ipset -F koolclash_white_ac_macs >/dev/null 2>&1 && ipset -X koolclash_white_ac_macs >/dev/null 2>&1
    ipset -F koolclash_black_ac_ips >/dev/null 2>&1 && ipset -X koolclash_black_ac_ips >/dev/null 2>&1
    ipset -F koolclash_black_ac_macs >/dev/null 2>&1 && ipset -X koolclash_black_ac_macs >/dev/null 2>&1

    ipset -F koolclash_white_ports >/dev/null 2>&1 && ipset -X koolclash_white_ports >/dev/null 2>&1
    ipset -F koolclash_black_ports >/dev/null 2>&1 && ipset -X koolclash_black_ports >/dev/null 2>&1

    echo_date "删除 KoolClash 添加的路由表信息"	
    # flush routing table
    ip rule del fwmark 0x162 table 0x162 >/dev/null 2>&1
    ip route del local 0.0.0.0/0 dev lo table 0x162 >/dev/null 2>&1
}

#--------------------------------------------------------------------------
#creat_ipset() {
#    ipset -! create koolclash_white nethash && ipset flush koolclash_white
#    ipset -! create koolclash_black nethash && ipset flush koolclash_black
#}

#--------------------------------------------------------------------------
gen_special_ip() {
    cat <<-EOF | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}"
		0.0.0.0/8
		10.0.0.0/8
		100.64.0.0/10
		127.0.0.0/8
		169.254.0.0/16
		172.16.0.0/12
		192.168.0.0/16
		224.0.0.0/4
		240.0.0.0/4
		$lan_ip
		$wan_ip
	EOF
}
#--------------------------------------------------------------------------

add_white_black_ip() {
    chn_ip="$KSROOT/koolclash/config/china_ip_route.ipset"
    # black ip/cidr
#    ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24"
#    for ip in $ip_tg; do
#        ipset -! add koolclash_black $ip >/dev/null 2>&1
#    done

    # white ip/cidr
    echo_date '应用局域网 IP 白名单'
#    ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 $lan_ip"
#    for ip in $ip_lan; do
#        ipset -! add koolclash_white $ip >/dev/null 2>&1
#    done
    ipset -! restore <<-EOF || return 1
	  create koolclash_white hash:net hashsize 64
	  $(gen_special_ip | sed -e "s/^/add koolclash_white /")
	EOF

    echo_date '应用CHNRoute IP/CIDR 规则'
    ipset -! restore <<-EOF || return 1
	  create koolclash_chn_white hash:net hashsize 64
	  $(cat $chn_ip | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" | sed -e "s/^/add koolclash_chn_white /")
	EOF

    if [ ! -z $koolclash_firewall_whiteip_base64 ]; then
        ip_white=$(echo $koolclash_firewall_whiteip_base64 | base64_decode | sed '/\#/d')
        echo_date '应用外网目标 IP/CIDR 白名单'
        for ip in $ip_white; do
            ipset -! add koolclash_white $ip >/dev/null 2>&1
        done
    fi

    if [ ! -z $koolclash_firewall_whitedomain_base64 ]; then
        ip_white_domain=$(echo $koolclash_firewall_whitedomain_base64 | base64_decode)
        echo_date '应用外网目标域名白名单'
        ISP_DNS=$(ubus call network.interface.wan status | jsonfilter -e '@["dns-server"][0]')
        rm -rf /tmp/dnsmasq.d/koolclash_ipset.conf >/dev/null 2>&1
        #rm -rf /tmp/dnsmasq.d/koolclash_white_server.conf >/dev/null 2>&1
        echo "#for koolclash white_domain" >> /tmp/dnsmasq.d/koolclash_ipset.conf
        #echo "#for koolclash white_domain_server" >> /tmp/dnsmasq.d/koolclash_white_server.conf
        for domain in $ip_white_domain; do
            echo "$domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/koolclash_white/g" >> /tmp/dnsmasq.d/koolclash_ipset.conf
            #echo "$domain" | sed "s/^/server=&\//g" | sed "s/$/\/$ISP_DNS/g" >> /tmp/dnsmasq.d/koolclash_white_server.conf
        done
    else
        rm -rf /tmp/dnsmasq.d/koolclash_ipset.conf >/dev/null 2>&1
        #rm -rf /tmp/dnsmasq.d/koolclash_white_server.conf >/dev/null 2>&1
    fi

	if [ ! -n "$(ipset -L | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        ipset create koolclash_white_ac_ips hash:net >/dev/null 2>&1
        ipset create koolclash_white_ac_macs hash:mac >/dev/null 2>&1
    fi
	if [ ! -n "$(ipset -L | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        ipset create koolclash_black_ac_ips hash:net >/dev/null 2>&1
        ipset create koolclash_black_ac_macs hash:mac >/dev/null 2>&1
    fi

	if [ ! -n "$(ipset -L | grep "koolclash_white_ports")" ]; then
        ipset create koolclash_white_ports bitmap:port range 0-65535 >/dev/null 2>&1
    fi
	if [ ! -n "$(ipset -L | grep "koolclash_black_ports")" ]; then
        ipset create koolclash_black_ports bitmap:port range 0-65535 >/dev/null 2>&1
    fi
}

#--------------------------------------------------------------------------
#get_mode_name() {
#    case "$1" in
#    0)
#        echo "不通过 Clash"
#        ;;
#    1)
#        echo "通过 Clash"
#        ;;
#    esac
#}

#get_default_port_name() {
#    case "$1" in
#    80443)
#        echo "80, 443"
#        ;;
#    1)
#        echo "常用 HTTP 协议端口"
#        ;;
#    all)
#        echo "全部端口"
#        ;;
#    0)
#        echo "自定义口"
#        ;;
#    esac
#}

port_access_control() {
    common_http_port="21 22 80 8080 8880 2052 2082 2086 2095 443 2053 2083 2087 2096 8443"

    if [ "$koolclash_firewall_default_mode" == "1" ]; then
        if [ "$koolclash_firewall_default_port_mode" == "80443" -o "$koolclash_firewall_default_port_mode" == "1" -o "$koolclash_firewall_default_port_mode" == "all" ]; then
            case $koolclash_firewall_default_port_mode in
            80443)
                echo_date "仅转发【80,443】端口的流量到 Clash，剩余端口直连"
                ipset add koolclash_black_ports 80
                ipset add koolclash_black_ports 443
                ;;
            1)
                echo_date "仅转发【常用 HTTP 端口】端口的流量到 Clash，剩余端口直连"
                for i in $common_http_port; do
                    ipset add koolclash_black_ports $i
                done
                ;;
            all)
                echo_date "转发【所有端口】端口的流量到 Clash"
                ;;
            esac
        fi
    fi

    if [ "$koolclash_firewall_default_mode" == "0" ]; then
        if [ "$koolclash_firewall_base_port_mode" == "80443" -o "$koolclash_firewall_base_port_mode" == "1" -o "$koolclash_firewall_base_port_mode" == "0" ]; then
            case $koolclash_firewall_base_port_mode in
            80443)
                echo_date "仅【80,443】端口直连，剩余端口的流量转发到 Clash"
                ipset add koolclash_white_ports 80
                ipset add koolclash_white_ports 443
                ;;
            1)
                echo_date "仅【常用 HTTP 端口】端口直连，剩余端口的流量转发到 Clash"
                for i in $common_http_port; do
                    ipset add koolclash_white_ports $i
                done
                ;;
            0)
                echo_date "仅【以下端口】端口全部直连，剩余端口的流量转发到 Clash"
                echo_date $(echo $koolclash_firewall_default_port_user | base64 -d)

                custom_port=$(echo $koolclash_firewall_default_port_user | base64 -d)
                for i in $custom_port; do
                    ipset add koolclash_white_ports $i
                done
                ;;
            esac     
        fi
    fi
}

#--------------------------------------------------------------------------
apply_nat_rules() {
    #----------------------BASIC RULES---------------------

    #-------------------------------------------------------
    # 局域网黑名单（不走ss）/局域网黑名单（走ss）
    # 其余主机默认模式
    # iptables -t nat -A koolclash -j $(get_action_chain $ss_acl_default_mode)

    # 设置运行模式
    dbus set koolclash_switch_run_mode=1

    echo_date "iptables 创建 koolclash 链并添加到 PREROUTING 中"
    iptables -t nat -N koolclash
    iptables -t nat -N koolclash_output
    iptables -t mangle -N koolclash

    # Add routing table
    [ ! -n "$(ip rule list | grep 0x162)" ] && ip rule add fwmark 0x162 table 0x162
    ip route add local 0.0.0.0/0 dev lo table 0x162

    # Redirect Google DNS to 23456
    [ "$(iptables -t nat -C PREROUTING -d 8.8.4.4/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A PREROUTING -d 8.8.4.4/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456
    [ "$(iptables -t nat -C PREROUTING -d 8.8.8.8/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A PREROUTING -d 8.8.8.8/32 -p tcp -m comment --comment "KoolClash Google DNS Hijack" -m tcp --dport 53 -j REDIRECT --to-ports 23456
    [ "$(iptables -t nat -C PREROUTING -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53
    [ "$(iptables -t nat -C PREROUTING -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53
    # Traffic import koolclash
    [ "$(iptables -t nat -C PREROUTING -p tcp -j koolclash >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A PREROUTING -p tcp -j koolclash
    [ "$(iptables -t mangle -C PREROUTING -p udp -j koolclash >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t mangle -A PREROUTING -p udp -j koolclash

    [ "$(iptables -t nat -C OUTPUT -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A OUTPUT -p tcp -m tcp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53
    [ "$(iptables -t nat -C OUTPUT -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A OUTPUT -p udp -m udp --dport 53 -m comment --comment "KoolClash DNS Hijack" -j REDIRECT --to-ports 53
    [ "$(iptables -t nat -C OUTPUT -j koolclash_output >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A OUTPUT -j koolclash_output

    # IP Whitelist
    [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A koolclash -m set --match-set koolclash_white dst -j RETURN
    if [ "$koolclash_return_chnip" == "1" ]; then
        [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set --match-set koolclash_chn_white dst -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_white_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set --match-set koolclash_white_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_white_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set --match-set koolclash_white_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        if [ "$koolclash_firewall_base_port_mode" == "80443" -o "$koolclash_firewall_base_port_mode" == "1" -o "$koolclash_firewall_base_port_mode" == "0" ]; then
            [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
            iptables -t nat -A koolclash -m set --match-set koolclash_white_ports src -j RETURN
        fi
    else
        [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set --match-set koolclash_white_ports src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t nat -C koolclash -m set ! --match-set koolclash_black_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set ! --match-set koolclash_black_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t nat -C koolclash -m set ! --match-set koolclash_black_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set ! --match-set koolclash_black_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        continue
    else
        [ "$(iptables -t nat -C koolclash -m set ! --match-set koolclash_black_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash -m set ! --match-set koolclash_black_ports src -j RETURN
    fi
    # Redirect all tcp traffic to 23456
    [ "$(iptables -t nat -C koolclash -p tcp -j REDIRECT --to-ports 23456 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A koolclash -p tcp -j REDIRECT --to-ports 23456

    # Exclude port traffic
    mangle_dest_port=`ubus call uci get '{ "config": "firewall", "type": "rule" }' | grep dest_port | sed -e 's/^[ \t]*//g' | sed -e 's/"dest_port": "//g' -e 's/".*//g'`
    for mangle_dest_port in $mangle_dest_port; do
        [ "$(iptables -t mangle -C koolclash -p udp -m udp --sport "$mangle_dest_port" -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -p udp -m udp --sport "$mangle_dest_port" -j RETURN
    done

    src_dport=`ubus call uci get '{ "config": "firewall", "type": "redirect" }' | grep port | sed -e 's/^[ \t]*//g' | grep dport | sed -e 's/"src_dport": "//g' -e 's/".*//g'`
    for src_dport in $src_dport; do
        [ "$(iptables -t nat -C koolclash_output -s "$lan_ip" -p tcp -m tcp --dport "$src_dport" -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -s "$lan_ip" -p tcp -m tcp --dport "$src_dport" -j RETURN
        [ "$(iptables -t mangle -C koolclash -s "$lan_ip" -p udp -m udp --dport "$src_dport" -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -s "$lan_ip" -p udp -m udp --dport "$src_dport" -j RETURN
    done
    dest_port=`ubus call uci get '{ "config": "firewall", "type": "redirect" }' | grep port | sed -e 's/^[ \t]*//g' | grep dest | sed -e 's/"dest_port": "//g' -e 's/".*//g'`
    for dest_port in $dest_port; do
        [ "$(iptables -t nat -C koolclash_output -s "$lan_ip" -p tcp -m tcp --sport "$dest_port" -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -s "$lan_ip" -p tcp -m tcp --sport "$dest_port" -j RETURN
        [ "$(iptables -t mangle -C koolclash -s "$lan_ip" -p udp -m udp --sport "$dest_port" -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -s "$lan_ip" -p udp -m udp --sport "$dest_port" -j RETURN
    done

    # IP Whitelist
    [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A koolclash_output -m set --match-set koolclash_white dst -j RETURN
    if [ "$koolclash_return_chnip" == "1" ]; then
        [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set --match-set koolclash_chn_white dst -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_white_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_white_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        if [ "$koolclash_firewall_base_port_mode" == "80443" -o "$koolclash_firewall_base_port_mode" == "1" -o "$koolclash_firewall_base_port_mode" == "0" ]; then
            [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
            iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ports src -j RETURN
        fi
    else
        [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ports src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t nat -C koolclash_output -m set ! --match-set koolclash_black_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set ! --match-set koolclash_black_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t nat -C koolclash_output -m set ! --match-set koolclash_black_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set ! --match-set koolclash_black_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        continue
    else
        [ "$(iptables -t nat -C koolclash_output -m set ! --match-set koolclash_black_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -A koolclash_output -m set ! --match-set koolclash_black_ports src -j RETURN
    fi
    # Redirect all tcp traffic to 23456
    [ "$(iptables -t nat -C koolclash_output -d 198.18.0.0/16 -p tcp -j REDIRECT --to-ports 23456 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t nat -A koolclash_output -d 198.18.0.0/16 -p tcp -j REDIRECT --to-ports 23456
    # IP Whitelist
    [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t mangle -A koolclash -m set --match-set koolclash_white dst -j RETURN
    if [ "$koolclash_return_chnip" == "1" ]; then
        [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set --match-set koolclash_chn_white dst -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_white_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set --match-set koolclash_white_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_white_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set --match-set koolclash_white_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        if [ "$koolclash_firewall_base_port_mode" == "80443" -o "$koolclash_firewall_base_port_mode" == "1" -o "$koolclash_firewall_base_port_mode" == "0" ]; then
            [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
            iptables -t mangle -A koolclash -m set --match-set koolclash_white_ports src -j RETURN
        fi
    else
        [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_white_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set --match-set koolclash_white_ports src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 1 ]; then
        [ "$(iptables -t mangle -C koolclash -m set ! --match-set koolclash_black_ac_ips src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set ! --match-set koolclash_black_ac_ips src -j RETURN
    fi
    if [ "$koolclash_acl_mode" == 2 ]; then
        [ "$(iptables -t mangle -C koolclash -m set ! --match-set koolclash_black_ac_macs src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set ! --match-set koolclash_black_ac_macs src -j RETURN
    fi
    if [ "$koolclash_firewall_default_port_mode" == "all" ]; then
        continue
    else
        [ "$(iptables -t mangle -C koolclash -m set ! --match-set koolclash_black_ports src -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -A koolclash -m set ! --match-set koolclash_black_ports src -j RETURN
    fi
    # Exclude port traffic
    [ "$(iptables -t mangle -C koolclash -p udp -m udp --dport 53 -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t mangle -A koolclash -p udp -m udp --dport 53 -j RETURN
    [ "$(iptables -t mangle -C koolclash -p udp -j TPROXY --on-port 23456 --on-ip 0.0.0.0 --tproxy-mark 0x162 >/dev/null 2>&1;echo $?)" == "1" ] && \
    iptables -t mangle -A koolclash -p udp -j TPROXY --on-port 23456 --on-ip 0.0.0.0 --tproxy-mark 0x162
}

# =======================================================================================================
load_nat() {
    echo_date "开始加载 nat 规则!"
    #flush_nat
    #creat_ipset
    add_white_black_ip
    port_access_control
    apply_nat_rules
}

load_clash_white_black() {
    if [ "$koolclash_firewall_blackip_enable" == "1" ]; then
        if [ ! -z "$koolclash_firewall_blackip_base64" ]; then
            ip_black=$(echo $koolclash_firewall_blackip_base64 | base64_decode | sed '/\#/d')
            echo_date '应用外网目标 IP/CIDR 黑名单'
            if [ ! -z "$koolclash_firewall_blackip_base64_old" ]; then
                ip_black_old=$(echo $koolclash_firewall_blackip_base64_old | base64_decode | sed '/\#/d')
                for ip in $ip_black_old; do
                    SRC_IP_CIDR=$(echo $ip | sed 's/\/.*//g' | awk -F "." -v OFS='.' '{print $1,$2,$3,$4"\\/32"}' | sort | uniq)
                    sed -i "s/- \"SRC-IP-CIDR,$SRC_IP_CIDR,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
                done
                dbus remove koolclash_firewall_blackip_base64_old
            fi
            for ip in $ip_black; do
                SRC_IP_CIDR=$(echo $ip | sed 's/\/.*//g' | awk -F "." -v OFS='.' '{print $1,$2,$3,$4"\\/32"}' | sort | uniq)
                sed -i "s/- \"SRC-IP-CIDR,$SRC_IP_CIDR,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
            done
            yaml_line=$(cat $KSROOT/koolclash/config/config.yaml | grep -n "DOMAIN-SUFFIX,local," | awk -F ":" '{print $1}')
            for ip in $ip_black; do
                SRC_IP_CIDR=$(echo $ip | sed 's/\/.*//g' | awk -F "." -v OFS='.' '{print $1,$2,$3,$4"\\/32"}' | sort | uniq)
                sed -i "$yaml_line i\- \"SRC-IP-CIDR,$SRC_IP_CIDR,\\\U0001F530 节点选择\"" $KSROOT/koolclash/config/config.yaml
            done
            dbus set koolclash_firewall_blackip_enable=0
            dbus set koolclash_firewall_blackip_base64_old=$koolclash_firewall_blackip_base64
        else
            if [ ! -z "$koolclash_firewall_blackip_base64_old" ]; then
                ip_black=$(echo $koolclash_firewall_blackip_base64_old | base64_decode | sed '/\#/d')
                for ip in $ip_black; do
                    SRC_IP_CIDR=$(echo $ip | sed 's/\/.*//g' | awk -F "." -v OFS='.' '{print $1,$2,$3,$4"\\/32"}' | sort | uniq)
                    sed -i "s/- \"SRC-IP-CIDR,$SRC_IP_CIDR,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
                done
                dbus remove koolclash_firewall_blackip_base64_old
            fi
        fi
    fi

    if [ "$koolclash_firewall_blackdomain_enable" == "1" ]; then
        if [ ! -z "$koolclash_firewall_blackdomain_base64" ]; then
            ip_black_domain=$(echo $koolclash_firewall_blackdomain_base64 | base64_decode | sed '/\#/d')
            echo_date '应用外网目标域名黑名单'
            if [ ! -z "$koolclash_firewall_blackdomain_base64_old" ]; then
                ip_black_domain_old=$(echo $koolclash_firewall_blackdomain_base64_old | base64_decode | sed '/\#/d')
                for domain in $ip_black_domain_old; do
                    sed -i "s/- \"DOMAIN-SUFFIX,$domain,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
                done
                dbus remove koolclash_firewall_blackdomain_base64_old
            fi
            for domain in $ip_black_domain; do
                sed -i "s/- \"DOMAIN-SUFFIX,$domain,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
            done
            yaml_line=$(cat $KSROOT/koolclash/config/config.yaml | grep -n "DOMAIN-SUFFIX,local," | awk -F ":" '{print $1}')
            for domain in $ip_black_domain; do
                sed -i "$yaml_line i\- \"DOMAIN-SUFFIX,$domain,\\\U0001F530 节点选择\"" $KSROOT/koolclash/config/config.yaml
            done
            dbus set koolclash_firewall_blackdomain_enable=0
            dbus set koolclash_firewall_blackdomain_base64_old=$koolclash_firewall_blackdomain_base64
        else
            if [ ! -z "$koolclash_firewall_blackdomain_base64_old" ]; then
                ip_black_domain=$(echo $koolclash_firewall_blackdomain_base64_old | base64_decode | sed '/\#/d')
                for domain in $ip_black_domain; do
                    sed -i "s/- \"DOMAIN-SUFFIX,$domain,\\\U0001F530 节点选择\"//g" $KSROOT/koolclash/config/config.yaml;sed -i '/^$/d' $KSROOT/koolclash/config/config.yaml
                done
                dbus remove koolclash_firewall_blackdomain_base64_old
            fi
        fi
    fi
}

creat_update_sub_cron() {
	clash_enable=$(dbus get koolclash_enable)
	if [ "$clash_enable" == "1" ]; then
		if [ "$koolclash_update_sub_enable" == "1" ]; then
			[ ! -f  "/etc/crontabs/root" ] && touch /etc/crontabs/root
			CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
			if [ -n "$koolclash_subconverter_url" ]; then
				[ -z "$CRONTAB_SUB" ] && echo_date "每天 $koolclash_update_sub_time 点定时更新 Clash 配置文件命令写入CRON中..." && echo  "0 $koolclash_update_sub_time * * * $KSROOT/scripts/koolclash_update_sub_cron.sh update" >> /etc/crontabs/root
			else
				echo_date "更新 Clash 配置文件命令写入CRON失败！"
			fi
		else
			CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
			[ ! -z "$CRONTAB_SUB" ] && echo_date "删除定时更新 Clash 配置文件CRON..." && sed -i '/koolclash_update_sub_cron/d' /etc/crontabs/root >/dev/null 2>&1
		fi
	else
		if [ "$koolclash_update_sub_enable" == "1" ]; then
			CRONTAB_SUB=$(cat /etc/crontabs/root | grep koolclash_update_sub_cron.sh)
			[ ! -z "$CRONTAB_SUB" ] && echo_date "删除定时更新 Clash 配置文件CRON..." && sed -i '/koolclash_update_sub_cron/d' /etc/crontabs/root >/dev/null 2>&1
		fi
	fi
}

start_koolclash() {
    # get_status >> /tmp/ss_start.txt
    # used by web for start/restart; or by system for startup by S99koolclash.sh in rc.d
    echo_date --------------------- KoolClash: Clash on Koolshare OpenWrt ---------------------
    [ -n "$ONSTART" ] && echo_date 路由器开机触发 KoolClash 启动！ || echo_date web 提交操作触发 KoolClash 启动！
    echo_date ---------------------------------------------------------------------------------
    # stop first
    # restore_dnsmasq_conf
    del_dns_forward
    flush_nat
    restore_start_file
    kill_process
    # node_memory
    node_memory
    echo_date ---------------------------------------------------------------------------------
    # create_dnsmasq_conf
    auto_start
    load_clash_white_black
    start_clash_process

    sleep 5
    echo_date "检查 Clash 进程是否启动成功..."
    if [ ! -n "$(pidof clash)" ]; then
        # 停止 KoolClash
        echo_date '【Clash 进程启动失败！Clash 配置文件可能存在错误，也有可能是其它原因！】'
        echo_date '【Clash 中断启动并回滚操作！】'
        echo_date ------------------------------- KoolClash 启动中断 -------------------------------
        sleep 2
        # restore_dnsmasq_conf
        del_dns_forward
        flush_nat
        restore_start_file
        kill_process
        dbus set koolclash_enable=0
        echo_date ------------------------------- KoolClash 停止完毕 -------------------------------
        exit 1
    else
        echo_date "Clash 进程成功启动！"
    fi

    load_nat
    del_dns_forward
    dns_forward
    start_clash_watchdog
    dbus set koolclash_enable=1
    creat_update_sub_cron
    load_rule_mode
    $KSROOT/scripts/koolclash_config.sh acl
    echo_date "请在【设备控制】页面添加需要代理的设备，默认所有设备不走代理！"
    echo_date ------------------------------- KoolClash 启动完毕 -------------------------------
    echo_date KoolClash 启动后可能无法立即上网，请先等待 1-2 分钟！
}

stop_koolclash() {
    echo_date --------------------- KoolClash: Clash on Koolshare OpenWrt ---------------------
    # restore_dnsmasq_conf
    del_dns_forward
    flush_nat
    restore_start_file
    kill_process
    dbus set koolclash_enable=0
    creat_update_sub_cron
    dbus remove koolclash_switch_run_mode
    dbus remove koolclash_switch_config_mode
    rm -rf /tmp/dnsmasq.d/koolclash_ipset.conf >/dev/null 2>&1
    rm -rf /tmp/dnsmasq.d/koolclash_white_server.conf >/dev/null 2>&1
    echo_date ------------------------------- KoolClash 停止完毕 -------------------------------
}

# used by rc.d and firewall include
case $1 in
start)
    if [ "$koolclash_enable" == "1" ]; then
        if [ ! -f $KSROOT/koolclash/config/config.yaml ]; then
            echo_date "【没有找到 Clash 的配置文件！】"
            echo_date "【KoolClash 将会中断启动并回滚操作！】"
            stop_koolclash
            echo_date "【请重新上传 Clash 配置文件！】"
            echo "XU6J03M6"
        elif [ ! -f $KSROOT/koolclash/config/Country.mmdb ]; then
            echo_date "【没有找到 GeoLite IP 数据库！】"
            echo_date "【KoolClash 将会中断启动并回滚操作！】"
            stop_koolclash
            echo_date "【请尝试更新 IP 数据库！】"
            echo "XU6J03M6"
        else
            if [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enable) == 'true' ] && [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'fake-ip' ]; then
                start_koolclash
                echo "XU6J03M6"
            else
                echo_date "【没有找到正确的 DNS 配置或 DNS 配置不合法！】"
                echo_date "【Clash 配置文件中 dns.enable 不为 true 或 dns.enhanced-mode 不为 fake-ip】"
                echo_date "【KoolClash 将会中断启动并回滚操作！】"
                stop_koolclash
                echo "XU6J03M6"
            fi
        fi
    else
        echo_date "【KoolClash 开机自动关闭】"
        stop_koolclash
        echo "XU6J03M6"
    fi
    ;;
stop)
    echo_date "关闭 KoolClash"
    stop_koolclash
    echo "XU6J03M6"
    ;;
stop_for_install)
    echo_date "关闭 KoolClash 以进行安装 / 更新"
    stop_koolclash
    ;;
start_after_install)
    if [ ! -f $KSROOT/koolclash/config/config.yaml ]; then
        echo_date "【没有找到 Clash 的配置文件！】"
        echo_date "【KoolClash 将会中断启动并回滚操作！】"
        stop_koolclash
    elif [ ! -f $KSROOT/koolclash/config/Country.mmdb ]; then
        echo_date "【没有找到 GeoLite IP 数据库！】"
        echo_date "【KoolClash 将会中断启动并回滚操作！】"
        stop_koolclash
    else
        if [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enable) == 'true' ] && [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'fake-ip' ]; then
            start_koolclash
        else
            echo_date "【没有找到正确的 DNS 配置或 DNS 配置不合法！】"
            echo_date "【Clash 配置文件中 dns.enable 不为 true 或 dns.enhanced-mode 不为 fake-ip】"
            echo_date "【KoolClash 将会中断启动并回滚操作！】"
            stop_koolclash
        fi
    fi
    ;;
*)
    if [ -z "$2" ]; then
        if [ "$koolclash_enable" == "1" ]; then
            if [ ! -f $KSROOT/koolclash/config/config.yaml ]; then
                echo_date "【没有找到 Clash 的配置文件！】"
                echo_date "【KoolClash 将会中断启动并回滚操作！】"
                stop_koolclash
                echo_date "【请重新上传 Clash 配置文件！】"
                echo "XU6J03M6"
            elif [ ! -f $KSROOT/koolclash/config/Country.mmdb ]; then
                echo_date "【没有找到 GeoLite IP 数据库！】"
                echo_date "【KoolClash 将会中断启动并回滚操作！】"
                stop_koolclash
                echo_date "【请尝试更新 IP 数据库！】"
                echo "XU6J03M6"
            else
                if [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enable) == 'true' ] && [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'fake-ip' ]; then
                    start_koolclash
                    echo "XU6J03M6"
                else
                    echo_date "【没有找到正确的 DNS 配置或 DNS 配置不合法！】"
                    echo_date "【Clash 配置文件中 dns.enable 不为 true 或 dns.enhanced-mode 不为 fake-ip】"
                    echo_date "【KoolClash 将会中断启动并回滚操作！】"
                    stop_koolclash
                    echo "XU6J03M6"
                fi
            fi
        else
            echo_date "【KoolClash 开机自动关闭】"
            stop_koolclash
            echo "XU6J03M6"
        fi
    fi
    ;;
esac

# used by httpdb
case $2 in
start)
    rm -rf /tmp/upload/koolclash_log.txt && touch /tmp/upload/koolclash_log.txt
    sleep 1
    if [ ! -f $KSROOT/koolclash/config/config.yaml ]; then
        echo_date "【没有找到 Clash 的配置文件！】" >/tmp/upload/koolclash_log.txt
        echo_date "【KoolClash 将会中断启动并回滚操作！】" >>/tmp/upload/koolclash_log.txt
        stop_koolclash >>/tmp/upload/koolclash_log.txt
        echo_date "【请在页面刷新以后重新上传 Clash 配置文件！】" >>/tmp/upload/koolclash_log.txt
        echo_date ------------------ 请不要关闭或者刷新页面！倒计时结束时会自动刷新！ ------------------ >>/tmp/upload/koolclash_log.txt
        echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt
        http_response 'nofile'
    elif [ ! -f $KSROOT/koolclash/config/Country.mmdb ]; then
        echo_date "【没有找到 GeoLite IP 数据库！】" >/tmp/upload/koolclash_log.txt
        echo_date "【KoolClash 将会中断启动并回滚操作！】" >>/tmp/upload/koolclash_log.txt
        stop_koolclash >>/tmp/upload/koolclash_log.txt
        echo_date "【请在页面刷新以后尝试更新 IP 数据库！】" >>/tmp/upload/koolclash_log.txt
        echo_date ------------------ 请不要关闭或者刷新页面！倒计时结束时会自动刷新！ ------------------ >>/tmp/upload/koolclash_log.txt
        echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt
        http_response 'nofile'
    else
        if [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enable) == 'true' ] && [ $(yq r $KSROOT/koolclash/config/config.yaml dns.enhanced-mode) == 'fake-ip' ]; then
            start_koolclash >/tmp/upload/koolclash_log.txt
			
            echo_date ------------------ 请不要关闭或者刷新页面！倒计时结束时会自动刷新！ ------------------ >>/tmp/upload/koolclash_log.txt
            echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt
            http_response 'success'
        else
            echo_date "【没有找到正确的 DNS 配置或 DNS 配置不合法！】" >/tmp/upload/koolclash_log.txt
            echo_date "【Clash 配置文件中 dns.enable 不为 true 或 dns.enhanced-mode 不为 fake-ip】" >>/tmp/upload/koolclash_log.txt
            echo_date "【KoolClash 将会中断启动并回滚操作！】" >>/tmp/upload/koolclash_log.txt
            stop_koolclash >>/tmp/upload/koolclash_log.txt
            echo_date "【请在页面刷新以后重新上传 Clash 配置文件！】" >>/tmp/upload/koolclash_log.txt
            echo_date ------------------ 请不要关闭或者刷新页面！倒计时结束时会自动刷新！ ------------------ >>/tmp/upload/koolclash_log.txt
            echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt
            http_response 'nodns'
        fi
    fi
    ;;
stop)
    rm -rf /tmp/upload/koolclash_log.txt && touch /tmp/upload/koolclash_log.txt
    sleep 1
    stop_koolclash >/tmp/upload/koolclash_log.txt
    echo_date ------------------ 请不要关闭或者刷新页面！倒计时结束时会自动刷新！ ------------------ >>/tmp/upload/koolclash_log.txt
    echo "XU6J03M6" >>/tmp/upload/koolclash_log.txt
    http_response 'success'
    ;;
esac
