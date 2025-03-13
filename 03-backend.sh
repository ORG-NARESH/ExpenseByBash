#!/bin/bash
COMPONENT=backend
LOGFILE=/tmp/$COMPONENT.log
HOSTNAME=mysql.eternallearnings.shop
MYSQL_IPADDRESS=172.31.41.206
#MYSQLPASSWORD=$1
if [ $(id -u) -ne 0 ];
then
echo -e "\e[31m Your NOT a root user, Please use sudo \e[0m"
exit 2
else
echo -e "\e[32m Your running as admin, Proceeding for next steps\e[0m"
fi


read -p "Enter mysql password :" MYSQLPASSWORD



stat() {
if [ $1 -eq 0 ];
then
echo -e "\e[32m success \e[0m"
else
echo -e "\e[31m You have some issues please verify \e[0m"
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
mkdir -p /app &>> $LOGFILE
stat $?
echo -e "dowloading backend folder from git:"
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip &>> $LOGFILE
stat $?
echo -e "cd to /app :"
cd /app &>> $LOGFILE
stat $?
echo -e "unzip backend folder :"
unzip -0 /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?
echo -e "npm installing :"
npm install &>> $LOGFILE
stat $?

echo -e "copy /home/ec2-user/ExpenseByBash/backend.service file to des location"

cp /home/ec2-user/ExpenseByBash/backend.service /etc/systemd/system/ &>> $LOGFILE
      
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
systemctl status $COMPONENT &>> $LOGFILE
echo -e "\e[33m ********$COMPONENT service is running fine********** \e[0m ]"