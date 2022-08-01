#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
source $KSROOT/bin/helper.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)


return_ip_off() {
    if [ "$koolclash_return_chnip" == "1" ]; then
        dbus set koolclash_return_chnip=0
        iptables -t nat -D koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1
        iptables -t nat -D koolclash_output -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1
        iptables -t mangle -D koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1        
        http_response "chnip_off"
    fi
}

return_ip_on() {
    if [ "$koolclash_return_chnip" == "0" ]; then
        dbus set koolclash_return_chnip=1
        #koolclash_return iptables_nat
        koolclash_nu=$(iptables -nvL koolclash -t nat | sed 1,2d | sed -n '/koolclash_white dst/=');let koolclash_nu+=1
        [ "$(iptables -t nat -C koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -I koolclash $koolclash_nu -m set --match-set koolclash_chn_white dst -j RETURN
        #koolclash_output_return iptables_nat
        koolclash_output_nu=$(iptables -nvL koolclash_output -t nat | sed 1,2d | sed -n '/koolclash_white dst/=');let koolclash_output_nu+=1
        [ "$(iptables -t nat -C koolclash_output -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t nat -I koolclash_output $koolclash_output_nu -m set --match-set koolclash_chn_white dst -j RETURN
        #koolclash_return iptables_mangle
        koolclash_mangle_nu=$(iptables -nvL koolclash -t mangle | sed 1,2d | sed -n '/koolclash_white dst/=');let koolclash_mangle_nu+=1
        [ "$(iptables -t mangle -C koolclash -m set --match-set koolclash_chn_white dst -j RETURN >/dev/null 2>&1;echo $?)" == "1" ] && \
        iptables -t mangle -I koolclash $koolclash_mangle_nu -m set --match-set koolclash_chn_white dst -j RETURN
        http_response "chnip_on"
    fi
}

return_ip_off
return_ip_on