#!/bin/bash

COMPONENT=nginx
LOGFILE=/tmp/$COMPONENT.log

if [ $(id -u) -ne 0 ];
then
echo -e "\e[31m Your NOT a root user, Please use sudo \e[0m"
exit 2
else
echo -e "\e[32m Your running as admin, Proceeding for next steps\e[0m"
fi

stat() {
if [ $1 -eq 0 ];
then
echo -e "\e[32m success \e[0m"
else
echo -e "\e[31m You have some issues please verify \e[0m"
fi
}

echo -e "\e[32m Installing $COMPONENT \e[0m"
dnf install  $COMPONENT -y &>> $LOGFILE
stat $?
echo -e "Enable $COMPONENT "
stat $?
systemctl enable $COMPONENT &>> $LOGFILE
stat $?
echo -e "starting $COMPONENT "
systemctl start $COMPONENT  &>> $LOGFILE
stat $?
rm -rf /usr/share/$COMPONENT/html/*     &>> $LOGFILE  
stat $?
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> $LOGFILE
stat $?
cd /usr/share/$COMPONENT/html &>> $LOGFILE
stat $?
unzip -0 /tmp/frontend.zip &>> $LOGFILE
stat $?
echo -e "\e[32m copying expense.conf to folder \e[0m"
cp /home/ec2-user/ExpenseByBash/expense.conf /etc/nginx/default.d/  &>> $LOGFILE
stat $?
echo -e "\e[32m Restarting $COMPONENT to folder \e[0m"
systemctl restart $COMPONENT &>> $LOGFILE
stat $?
set-hostname $COMPONENT
stat $?
systemctl status $COMPONENT &>> $LOGFILE
echo "\e[32m $COMPONENT looks good \e[0m"
