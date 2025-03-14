#!/bin/bash
COMPONENT=mysql
#LOGFILE=/tmp/$COMPONENT.log
# if [ $(id -u) -ne 0 ];
# then
# echo -e "\e[31m You do not have root privileges, Please use sudo \e[0m"
# exit 2
# else
# echo -e "\e[32m Your running as admin, Proceeding for next steps \e[0m"
# fi


# stat() {
# if [ $1 -eq 0 ];
# then
# echo -e "\e[32m success \e[0m"   
# else
# echo -e "You have some issues please verify"
# fi
# }
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
