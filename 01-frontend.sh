#!/bin/bash

COMPONENT=nginx
# LOGFILE=/tmp/$COMPONENT.log

# if [ $(id -u) -ne 0 ];
# then
# echo -e "\e[31m Your NOT a root user, Please use sudo \e[0m"
# exit 2
# else
# echo -e "\e[32m Your running as admin, Proceeding for next steps\e[0m"
# fi

# stat() {
# if [ $1 -eq 0 ];
# then
# echo -e "\e[32m success \e[0m"
# else
# echo -e "\e[31m You have some issues please verify \e[0m"
# fi
# }
source common.sh
echo  "Installing $COMPONENT"
dnf install  $COMPONENT -y &>> $LOGFILE
stat $?
echo -e "enable $COMPONENT "
systemctl enable $COMPONENT &>> $LOGFILE
stat $?
echo -e "starting $COMPONENT"
systemctl start $COMPONENT  &>> $LOGFILE
stat $?
echo -e "remove all existing file from html"
rm -rf /usr/share/$COMPONENT/html/*     &>> $LOGFILE  
stat $?
echo "download .zip file from git"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> $LOGFILE
stat $?
echo -e "cd to html"
cd /usr/share/$COMPONENT/html &>> $LOGFILE
stat $?
echo -e "unzip"
unzip -o /tmp/frontend.zip &>> $LOGFILE
stat $?
echo "copying expense.conf to folder"
cp /home/ec2-user/ExpenseByBash/expense.conf /etc/nginx/default.d/  &>> $LOGFILE
stat $?
echo  "Restarting $COMPONENT"
systemctl restart $COMPONENT &>> $LOGFILE
stat $?
systemctl status $COMPONENT &>> $LOGFILE
echo -e "\e[32m ********$COMPONENT looks good********* \e[0m"
