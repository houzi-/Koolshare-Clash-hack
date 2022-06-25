#!/bin/sh

MODULE="koolclash"
VERSION=`cat ./koolclash/webs/res/koolclash_.version`
TITLE=koolclash
DESCRIPTION="基于规则的代理程序 Clash"
HOME_URL="Module_koolclash.asp"
CHANGELOG="更新修复"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/local-build.sh

# change to module directory
cd $DIR

# do something here

#do_build_result

#sh backup.sh $MODULE
