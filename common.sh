LOGFILE=/tmp/$COMPONENT.log

#condition to check user logged in as root or not


if [ $(id -u) -ne 0 ];
then
echo -e "\e[31m Your NOT a root user, Please use sudo \e[0m"
exit 2
else
echo -e "\e[32m Your running as admin, Proceeding for next steps\e[0m"
fi

#Stat function to state command executed with success or not

stat() {
if [ $1 -eq 0 ];
then
echo -e "\e[32m success \e[0m"
else
echo -e "\e[31m You have some issues please verify \e[0m"
fi
}