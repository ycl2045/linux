#!/usr/bin/env bash
#-----------------------------------
# health_uninstall.sh
# remove health script
#-----------------------------------

scriptpath="/home/ap/idcos"
cj="ocsinventory-agent"

# Check command if or not exist in linux
function isExist()
{
  if [ $(LANG=C type example 2>/dev/null|wc -l) -eq 1 ]
then
        :
else
        echo "The $1 is not exist in system!!"
        exit 1
fi
}

# Check whether the file or dir is used,
function isUsed()
{
  cc=$(lsof |grep $1|wc -l)
  if [ $? -eq 0 ] && [ ${cc} -eq 0 ]
  then
    echo "USED"
  else
    echo "UNUSED"
  fi

}

function getOs()
{
  echo $(uname|awk '{print $0}')
}

#only remove files in `/home/ap/idcos`
function rMfile()
{
  local myfile=$1
  if [ $(isUsed $myfile) -eq "USED" ]
  then
    rm -rf $myfile
  else
    echo "The $myfile is used"
    exit 1
  fi
}

function main()
{
  cd ${scriptpath}
  #uninstall cj
  rMfile ${cj}
  #uninstall jc
  rMfile getOs
}
