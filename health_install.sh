#!/usr/bin/env bash
#des
#-----------------------------#
#  pre_start.sh
#  pre install package
#  create device id,script respository list
#------------------------------#

# env
export LANG=en_US.utf8

# var
timestamp=`date +"%Y-%m-%d-%H-%M-%S"`
hostname=`hostname -f`
host_id="$hostname-$timestamp"
# fun
function createHostid()
{
  local pridir=".idcos"
  [ -d ${pridir} ] || mkdir ${pridir}
cat <<EOF >${IDCOS}/${pridir}/config.conf
{
    "CONF" : {
      "DEVICEID" : "${host_id}"
    }
}
EOF
}

function a2A()
{
  echo $1|tr "[:lower:]" "[:upper:]"
}

function A2a()
{
  echo $1|tr "[:upper:]" "[:lower:]"
}

function getOs()
{
  echo $(uname|awk '{print $0}')
}


#create dir
function mkDir()
{
  path=$0
  [ -d ${path} ] || mkdir -p ${path}
}

#Md5sum

function getMd5()
{
  local md5v
  md5v=$(openssl md5 $1|awk -F"=" '{print $2}')
  echo ${md5v}
}

function getFulldir()
{
  local filename=$(basename "$1")
  local fullpath=$(cd "$(dirname "$1")"; pwd)
  echo "${fullpath}/${filename}"
}

function file2json()
{
local file
local md5
file=$(getFulldir $1)
md5=$(getMd5 ${file})
cat <<EOF
{
  "path":"${file}",
  "md5":"${md5}",
  "threshold":""
},
EOF
}

function scanFiles()
{
  local dirname
  dirname=$1
  if [ -d ${dirname} ]
  then
    echo $(find ${dirname} -maxdepth 1 -not -path '*/\.*' -type f \( ! -iname ".*" \))
  else
    echo "The parameter ${dirname}  is not directory"
    return 2
  fi
}

function dir2json()
{
  local bsdir=$(basename ${1})
  local files=$(scanFiles $1)
  local counts=$(echo ${files}|wc -w)
  cat <<EOF
  {
  "${bsdir}":[
EOF
  for f in ${files}
  do
        ((counts--))
    if [ ${counts} == 0 ]
    then
      echo $(file2json ${f})|sed 's/,$//'
    else
      echo $(file2json ${f})
    fi

  done
  cat <<EOF
  ]
},
EOF
}

function scanDirs()
{
  local dirname=$1
  if [ -d ${dirname} ]
  then
    echo $(find ${dirname} -maxdepth 1 -not -path '*/\.*' -type d \( ! -iname ".*" \)|sed 1d)
  else
    echo "The parameter ${dirname}  is not directory"
    return 2
  fi
}


function dirs2json()
{
  local bsdir=$(basename ${1})
cat <<EOF
{
"${bsdir}":[
EOF
  local dirs=$(scanDirs ${1})
  local counts=$(echo ${dirs}|wc -w)

  for d in ${dirs}
  do
    ((counts--))
    if [ ${counts} == 0 ]
    then
      echo $(dir2json ${d})|sed 's/,$//'
    else
      echo $(dir2json ${d})
    fi
  done
cat <<EOF
  ]
  }
EOF
}

#install cmdb
function installCmdb()
{
#init idcos environment
mkdir /home/ap/idcos/{bin,ocsinventory-agent}
cd $(dirname $0)
cp -rf lib ${IDCOS_HOME}/ocsinventory-agent
cp -rf cmd/ocsinventory-agent  ${IDCOS_HOME}/bin
tar xjf tool.tar.gz -C ${IDCOS_HOME}
cp tool/per5/bin/perl ${IDCOS_HOME}/bin

echo "export PATH=$PATH:$IDCOS_HOME/bin" >> ~/.bash_profile
cd ~
. .bash_profile

}

# main
function main()
{
  cd $(dirname $0)

  # install cmdb scripts

  installCmdb

  # create unique hostid
  declare IDCOS='/home/ap/idcos'
  [ -d ${IDCOS} ] || mkdir ${IDCOS}
  creatHostid

#install health_linux
  ostype=$(A2a getOs)
  if [ -d ${ostype} ]
  then
    cp -rf ${ostype} ${IDCOS}
    cd ${IDCOS}
    chmod -R 755 ${ostype}
    dirs2json ${ostype} >> .idcos/"${0%_install.sh}-${ostype}.json"
  fi
}

main
