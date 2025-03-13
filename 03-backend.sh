#!/bin/bash
COMPONENT=backend
LOGFILE=/tmp/$COMPONENT.log
HOSTNAME=mysql.eternallearnings.shop
MYSQL_IPADDRESS=
#MYSQLPASSWORD=$1
if [ id -ne 0 ];
then
echo "\e[31m Your NOT a root user, Please use sudo \e[0m"
exit 2
else
echo "\e[32mYour running as admin, Proceeding for next steps\e[0m"
fi


read -p "Enter mysql password :" MYSQLPASSWORD



stat() {
if [ $1 -eq 0 ];
then
echo -n "\e[32m success \e[0"
else
echo -n "You have some issues please verify"
fi
}

echo -e "nodejs is disble :"
dnf module disable nodejs -y &>> $LOGFILE
stat $?
echo -e "nodejs is enable :"
dnf module enable nodejs:20 -y &>> $LOGFILE
stat $?
echo -e "nodejs is installing :"
dnf install nodejs -y &>> $LOGFILE
stat $?
echo -e "creating user expense :"
useradd expense &>> $LOGFILE
stat $?
echo -e "creating app folder :"
mkdir /app &>> $LOGFILE
stat $?
echo -e "dowloading backend folder from git:"
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip &>> $LOGFILE
stat $?
echo -e "cd to /app :"
cd /app &>> $LOGFILE
stat $?
echo -e "unzip backend folder :"
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?
echo -e "npm installing :"
npm install &>> $LOGFILE
stat $?
      
chmod -R 775 /app &>> $LOGFILE
stat $?

chown -R expense:expense /app &>> $LOGFILE
stat $?
echo -e "mysql installing :"
dnf install mysql-server -y &>> $LOGFILE
stat $?
echo -e "Injecting schema :"
mysql -h $MYSQL_IPADDRESS -uroot -p$MYSQLPASSWORD < /app/schema/$COMPONENT.sql &>> $LOGFILE
stat $?
echo -e "deamon reload :"
systemctl daemon-reload &>> $LOGFILE
stat $?

systemctl enable $COMPONENT &>> $LOGFILE
stat $?
echo -e "backend service started :"
systemctl start $COMPONENT &>> $LOGFILE
stat $?