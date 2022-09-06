#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
#arp=`arp | grep br-lan | grep -v ? |sed 's/<incomplete>/ /g'| sed 's/ (/</g'|sed 's/) at /</'|cut -d " " -f1|sed ':a;N;$!ba;s#\n#>#g'`
#arp=`arp -i br-lan | grep 192. | sed 's/?/unknown-device.lan/g' | grep -v '<incomplete>' | sed 's/ (/</g'|sed 's/) at /</' | cut -d " " -f1 | awk '{print FNR " " $0}' | sed 's/ /-/g' | sed ':a;N;$!ba;s#\n#>#g'`
arp_scan=$(which arp-scan)
$arp_scan --interface=br-lan -l | grep "(Unknown" > /tmp/list.txt

arp=$(cat /tmp/list.txt | awk '{$3 = $2; print $0}' | awk '{$2 = $1; print $0}' | sed 's/ /</g' | sed ':a;N;$!ba;s#\n#>#g')

if [ -n "$arp" ]; then
    dbus set koolclash_arp="$arp"
else
    dbus set koolclash_arp="undefined"
fi

http_response "$arp"
