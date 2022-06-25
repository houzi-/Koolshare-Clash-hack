#!/bin/sh

MODULE="koolclash"
VERSION=`cat ./koolclash/webs/res/koolclash_.version`
TITLE=koolclash
DESCRIPTION="基于规则的代理程序 Clash"
HOME_URL="Module_koolclash.asp"
CHANGELOG="更新修复"

# Check and include base
rm -f ${MODULE}.tar.gz
#清理mac os 下文件
#rm -f $MODULE/.DS_Store
#rm -f $MODULE/*/.DS_Store

rm -f ${MODULE}.tar.gz
tar -zcvf ${MODULE}.tar.gz $MODULE
md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF

cat > ./koolclash_version <<EOF
$VERSION
EOF
cat version

DATE=`date +%Y-%m-%d_%H:%M:%S`
cat > ./config.json.js <<EOF
{
"module":"$MODULE",
"version":"$VERSION",
"md5":"$md5value",
"home_url":"$HOME_URL",
"title":"$TITLE",
"description":"$DESCRIPTION",
"changelog":"$CHANGELOG",
"build_date":"$DATE"
}
EOF
