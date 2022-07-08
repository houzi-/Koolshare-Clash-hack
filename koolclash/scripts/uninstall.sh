#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

if [ -d "$KSROOT/koolclash" ]; then
    sh $KSROOT/scripts/koolclash_control.sh stop >/dev/null 2>&1
    sleep 2
fi

rm -rf $KSROOT/koolclash
rm -rf $KSROOT/scripts/koolclash_*
rm -rf $KSROOT/init.d/S99koolclash.sh
rm -rf $KSROOT/bin/clash
rm -rf $KSROOT/bin/clash-linux-amd64
rm -rf $KSROOT/bin/yq
rm -rf $KSROOT/bin/subconverter
rm -rf $KSROOT/webs/Module_koolclash.asp
rm -rf $KSROOT/webs/koolclash
rm -rf $KSROOT/webs/res/icon-koolclash*
rm -rf $KSROOT/webs/res/koolclash_*

rm -rf /tmp/luci-*

confs=$(dbus list koolclash | cut -d "=" -f1)
for conf in $confs; do
    dbus remove $conf
done

dbus remove softcenter_module_koolclash_description
dbus remove softcenter_module_koolclash_install
dbus remove softcenter_module_koolclash_name
dbus remove softcenter_module_koolclash_title
dbus remove softcenter_module_koolclash_version
