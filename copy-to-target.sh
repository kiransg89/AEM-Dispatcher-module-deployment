#!/bin/bash

USER=$1
HOST=$2


######################
# Input Param Validation
######################
if [[ $# -ne 2 ]]
  then
  	
  	echo "------------------------------------------------------------"
    echo " ERROR:	Please pass below input params,"
    echo " 				Input-1, SSH Username to Target environment."
    echo " 				Input-2, IP address of Target environment."
    echo " 		Usage is as 'sh copy-to-target.sh <SSH-USER> <IP-ADDRESS>'"
    echo " 		e.g sh copy-to-target.sh sachin 54.173.155.74"
    echo "------------------------------------------------------------"
    exit 1
fi

rsync -avv --delete src/ ${USER}@${HOST}:~/src

#rsync disable-default.sh ${USER}@${HOST}:~
#rsync deploy-conf.sh ${USER}@${HOST}:~

ssh ${USER}@${HOST}
unset USER
unset HOST
