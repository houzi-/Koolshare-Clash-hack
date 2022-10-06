#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export koolclash_)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

get_acl_para() {
    echo `dbus get koolclash_acl_list | sed 's/>/\n/g' | sed '/^$/d' | awk NR==$1{print} | cut -d "<" -f "$2"`
}

factor() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
    else
        echo "$2 $1"
    fi
}

clear_ipset() {
    if [ -n "$(ipset -L | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        ipset -F koolclash_white_ac_ips >/dev/null 2>&1
        ipset -F koolclash_white_ac_macs >/dev/null 2>&1
    fi
    if [ -n "$(ipset -L | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        ipset -F koolclash_black_ac_ips >/dev/null 2>&1
        ipset -F koolclash_black_ac_macs >/dev/null 2>&1
    fi
}

creat_ipset() {
	if [ ! -n "$(ipset -L | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        ipset create koolclash_white_ac_ips hash:net >/dev/null 2>&1
        ipset create koolclash_white_ac_macs hash:mac >/dev/null 2>&1
    fi
    if [ ! -n "$(ipset -L | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        ipset create koolclash_black_ac_ips hash:net >/dev/null 2>&1
        ipset create koolclash_black_ac_macs hash:mac >/dev/null 2>&1
    fi
}

creat_iptables() {
    if [ ! -n "$(iptables -t nat -S koolclash | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t nat -A koolclash -m set --match-set koolclash_white_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t nat -A koolclash -m set --match-set koolclash_white_ac_macs dst -j RETURN >/dev/null 2>&1
    fi
    if [ ! -n "$(iptables -t nat -S koolclash | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t nat -A koolclash -m set ! --match-set koolclash_black_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t nat -A koolclash -m set ! --match-set koolclash_black_ac_macs dst -j RETURN >/dev/null 2>&1
    fi
    if [ ! -n "$(iptables -t nat -S koolclash_output | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t nat -A koolclash_output -m set --match-set koolclash_white_ac_macs dst -j RETURN >/dev/null 2>&1
	fi
    if [ ! -n "$(iptables -t nat -S koolclash_output | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t nat -A koolclash_output -m set ! --match-set koolclash_black_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t nat -A koolclash_output -m set ! --match-set koolclash_black_ac_macs dst -j RETURN >/dev/null 2>&1
	fi
    if [ ! -n "$(iptables -t mangle -S koolclash | grep -E "koolclash_white_ac_ips|koolclash_white_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t mangle -A koolclash -m set --match-set koolclash_white_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t mangle -A koolclash -m set --match-set koolclash_white_ac_macs dst -j RETURN >/dev/null 2>&1
	fi
    if [ ! -n "$(iptables -t mangle -S koolclash | grep -E "koolclash_black_ac_ips|koolclash_black_ac_macs")" ]; then
        [ "$koolclash_acl_mode" == 1 ] && iptables -t mangle -A koolclash -m set ! --match-set koolclash_black_ac_ips dst -j RETURN >/dev/null 2>&1
        [ "$koolclash_acl_mode" == 2 ] && iptables -t mangle -A koolclash -m set ! --match-set koolclash_black_ac_macs dst -j RETURN >/dev/null 2>&1
	fi
}

lan_acess_control(){
	# lan access control
    acl_nu=`dbus get koolclash_acl_list | sed 's/>/\n/g' | sed '/^$/d' | sed '/^ /d' | wc -l`
    if [ -n "$acl_nu" ]; then
        min="1"
        max="$acl_nu"
        while [ $min -le $max ]
        do
			proxy_name=`get_acl_para $min 1`
			ipaddr=`get_acl_para $min 2`
			mac=`get_acl_para $min 3`
			proxy_mode=`get_acl_para $min 4`

            if [ -n "$ipaddr" ]; then
                [ "$proxy_mode" == 0 ] && ipset add koolclash_white_ac_ips $ipaddr
                [ "$proxy_mode" == 1 ] && ipset add koolclash_black_ac_ips $ipaddr
            fi
            if [ -n "$mac" ]; then
                [ "$proxy_mode" == 0 ] && ipset add koolclash_white_ac_macs $mac
                [ "$proxy_mode" == 1 ] && ipset add koolclash_black_ac_macs $mac
            fi
            min=`expr $min + 1`
        done
    fi
}

case $1 in
acl)
    if [ "$koolclash_enable" == "1" ]; then
        if [ -n "$koolclash_acl_list" ]; then
            clear_ipset
            creat_ipset
            #creat_iptables
            lan_acess_control
        else
            :
        fi
    else
        clear_ipset
    fi
    ;;
esac

case $2 in
acl)
    if [ "$koolclash_enable" == "1" ]; then
        if [ -n "$koolclash_acl_list" ]; then
            clear_ipset
            creat_ipset
            #creat_iptables
            lan_acess_control
            http_response 'success'
        else
            :
        fi
    else
        clear_ipset
        http_response 'success'
    fi
    ;;
esac
