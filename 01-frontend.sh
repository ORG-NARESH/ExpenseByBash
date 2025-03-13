#!/bin/bash

COMPONENT=nginx
LOGFILE=/tmp/$COMPONENT.log
stat() {
if [ $1 -eq 0 ];
then
echo -n "\e[32m success \e[0"
else
echo -n "You have some issues please verify"
fi
}

echo -e "\e[32m Installing $COMPONENT \e[0m"
dnf install  $COMPONENT -y &>> $LOGFILE
stat $?
echo -e "\e[33m Enable $COMPONENT \e[0m"
systemctl enable $COMPONENT &>> $LOGFILE
echo -e "\e[34m starting $COMPONENT \e[0m"
systemctl start $COMPONENT  &>> $LOGFILE
rm -rf /usr/share/$COMPONENT/html/*      &>> $LOGFILE  
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> $LOGFILE
cd /usr/share/$COMPONENT/html &>> $LOGFILE
unzip /tmp/frontend.zip &>> $LOGFILE
echo -e "\e[32m copying expense.conf to folder \e[0m"
cp /home/ec2-user/ExpenseByBash/expense.conf /etc/nginx/default.d/  &>> $LOGFILE
stat
echo -e "\e[32m Restarting $COMPONENT to folder \e[0m"
systemctl restart $COMPONENT &>> $LOGFILE
systemctl status $COMPONENT &>> $LOGFILE
stat $?
set-hostname $COMPONENT