#!/bin/bash
#########################
# Author: Naresh S
# Date: March-10-2025
#
# This script outputs creation of Database server - mysql
#
# Version: 1
########################

COMPONENT=mysql
source ./common.sh
read -p "Enter mysql password :" MYSQLPASSWORD
echo -e "$COMPONENT is instaling :"
dnf install mysql-server -y &>> $LOGFILE
stat $?

echo -e "$COMPONENT is starting :"
systemctl enable mysqld &>> $LOGFILE
systemctl start  mysqld &>> $LOGFILE
stat $?         

echo -e "$COMPONENT setting root password :"
mysql_secure_installation --set-root-pass $MYSQLPASSWORD  &>> $LOGFILE
stat $?
