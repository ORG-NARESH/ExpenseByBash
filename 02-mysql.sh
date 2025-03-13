#!/bin/bash
COMPONENT=mysql
LOGFILE=/tmp/$COMPONENT.log
if [ $(id -u root) -ne 0 ];
then
echo -n "\e[31m Your NOT a root user, Please use sudo \e[0m"
exit 2
else
echo -n "\e[32mYour running as admin, Proceeding for next steps\e[0m"
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

echo -e "$COMPONENT is instaling :"
dnf install mysql-server -y &>> $LOGFILE
stat $?

echo -e "$COMPONENT is starting :"
systemctl enable mysqld
systemctl start  mysqld
stat $?         

echo -e "$COMPONENT setting root password :"
mysql_secure_installation --set-root-pass $MYSQLPASSWORD
stat $?
