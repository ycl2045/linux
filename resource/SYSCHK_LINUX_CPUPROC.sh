#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_CPUPROC_RES.sh            #
# 作  者：ycl                            #
# 日  期：2015年 09月24日                        #
# 功  能：检查占cpu最多的进程所用率用利          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
_DEFAULT=10
: ${PROCESS_TOP:=$_DEFAULT}
IFS=$'\n'
for p in $(export LC_ALL=C;ps auxwww|sed 1d|sort -k 3 -r|head -"${PROCESS_TOP}")
do
  echo $p |awk '{print "user:"$1,"pid:"$2,"cpupercent:"$3,"command:"$11}'
done

exit 0;
