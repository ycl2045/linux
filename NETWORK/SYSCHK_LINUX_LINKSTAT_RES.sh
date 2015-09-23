#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LINKSTAT_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查网络连接状态                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8

netstat -an|grep "^tcp" |awk '{print "Proc:"$1,"Localaddr:"$4,"Foreignaddr:"$5,"State:"$6}'

exit $?;
