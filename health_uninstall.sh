#!/usr/bin/env bash
#-----------------------------------
# health_uninstall.sh
# remove health script
#-----------------------------------

scriptpath="/home/ap/idcos"
cj="ocsinventory-agent"


function a2A()
{
  echo $1|tr "[:lower:]" "[:upper:]"
}

function A2a()
{
  echo $1|tr "[:upper:]" "[:lower:]"
}
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
    echo "UNUSED"
  else
    echo "USED"
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
  if [ $(isUsed $myfile) == "USED" ]
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
  [ -d ${cj} ] && rMfile ${cj}
  #uninstall jc
  jc=$(A2a getOs)
  [ -d $jc ] && rMfile ${jc}
}
