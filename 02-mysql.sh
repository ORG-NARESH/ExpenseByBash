#!/bin/bash
COMPONENT=mysql
LOGFILE=/tmp/$COMPONENT.log
if [ $(id -u) -ne 0 ];
then
echo -e "\e[31m You do not have root privileges, Please use sudo \e[0m"
exit 2
else
echo -e "\e[32mYour running as admin, Proceeding for next steps\e[0m"
fi


stat() {
if [ $1 -eq 0 ];
then
echo -n "\e[32m success \e[0"
else
echo -n "You have some issues please verify"
fi
}

read -p "Enter mysql password :" MYSQLPASSWORD

echo -n "$COMPONENT is instaling :"
dnf install mysql-server -y &>> $LOGFILE
stat $?

echo -n "$COMPONENT is starting :"
systemctl enable mysqld
systemctl start  mysqld
stat $?         

echo -n "$COMPONENT setting root password :"
mysql_secure_installation --set-root-pass $MYSQLPASSWORD
stat $?
