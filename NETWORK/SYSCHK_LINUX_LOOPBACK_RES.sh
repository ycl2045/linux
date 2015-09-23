#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LOOPBACK_RES.sh            #
# 作  者：ycl                            #
# 日  期：2015年 9月23日                        #
# 功  能：检查网络loopback               #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8

cat /etc/hosts|egrep -v "#|::"|awk '$2 ~ /localhost/{print "localhost:"$1}'

exit $?;
