#!/bin/bash
COMPONENT=mysql
LOGFILE=/tmp/$COMPONENT.log
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
echo -e "$COMPONENT is starting :"
systemctl enable mysqld
systemctl start  mysqld           

echo -e "$COMPONENT setting root password :"
mysql_secure_installation --set-root-pass $MYSQLPASSWORD
