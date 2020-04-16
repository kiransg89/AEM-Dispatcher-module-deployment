#!/bin/bash
ENV=$1
TYPE=$2

APACHE_DIR=/etc/httpd
CACHE_DIR=/mnt/var/www 

#Use for testing your script
#APACHE_DIR=~/test_disp/
#CACHE_DIR=~/mnt/var/www



######################
# Input Param Validation
######################
if [[ $# -ne 2 ]]
  then
  	echo "------------------------------------------------------------"
  	echo " ERROR:	Please pass below input params,"
	echo " 			Input-1, Name of the environment. e.g. dev, qa, stg, prod"
	echo " 			Input-2, Deployment Type. e.g. all, common-only, env-only"
    echo "------------------------------------------------------------"
    exit 1
fi

if [[ (-z "$1") || (( $1 != "local" ) && ( $1 != "dev" ) && ( $1 != "qa" ) && ( $1 != "stg" ) && ($1 != "prod")) ]]
  then
    echo "Error: Input-1 value is empty or wrong. It should be 'Name of the environment'. e.g. dev, qa, stg, prod"
   	exit 1
fi

if [[ (-z "$2") || (( $2 != "all" ) && ( $2 != "common-only" ) && ( $2 != "env-only" )) ]]
  then
    echo "Error: Input-2 value is empty or wrong. It should be 'Deployment Type'. e.g. all, common-only, env-only"
   	exit 1
fi

echo "#############################"
echo "Backing up current configs @ /mnt/config_backup_DD-MON-YEAR-HH-MM"
echo "#############################"

#Backup current configs
sudo mkdir /mnt/config_backup_$(date '+%d-%b-%Y-%H-%M') 
sudo cp -fr /etc/httpd/* /mnt/config_backup_$(date '+%d-%b-%Y-%H-%M')/

#Execute another script to disable the default
source disable-default.sh

if [[($2 == "all") || ($2 == "common-only")]]
	then

		echo "#############################"
		echo "Updating COMMON files under /etc/httpd/"
		echo "#############################"
		#Copy common config files
		sudo cp -fvr ../example-config-overrides/common/* ${APACHE_DIR}/
fi

if [[ ($2 == "all") || ($2 == "env-only") ]]
	then

		echo "#############################"
		echo "Updating ENVIRONMENT specific files under /etc/httpd/"
		echo "#############################"
		#Override or replace them with environment specific files
		sudo cp -fvr ../example-config-overrides/${ENV}/* ${APACHE_DIR}/

fi		

echo "#############################"
echo "Removing Cache"
echo "#############################"
sudo rm -rfv ${CACHE_DIR}/author/*
sudo rm -rfv ${CACHE_DIR}/html/*

echo "#############################"
echo "Restarting Apache"
echo "#############################"
sudo systemctl restart httpd
#sudo apachectl restart

systemctl status httpd.service

unset ENV
unset TYPE
unset APACHE_DIR
unset CACHE_DIR