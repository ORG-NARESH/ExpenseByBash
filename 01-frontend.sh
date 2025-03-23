#!/bin/bash

# Author: Naresh S
# Date: March-10-2025
#
# This script outputs creation of frontend web server - Nginix
#
# Version: 1
########################

COMPONENT=nginx

source ./common.sh
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
