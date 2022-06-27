#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
eval $(dbus export koolclash_)
sub_url=$(dbus get koolclash_suburl | sed -e 's;?;\\?;g' -e 's;&;\\&;g')

rm -rf $KSROOT/koolclash/config/sub.sh > /dev/null 2>&1

echo -e "
#!/bin/sh
curl=\$(which curl)
\$curl -L ${sub_url} -o ${KSROOT}/koolclash/config/origin.yml
sub_time=\$(date +%Y-%m-%d\ %X)
dbus set koolclash_config_version=\"<font color="#1bbf35">\$sub_time</font>\"" >> $KSROOT/koolclash/config/sub.sh

sed -i '/^$/d' $KSROOT/koolclash/config/sub.sh
chmod -R 755 $KSROOT/koolclash/config/sub.sh