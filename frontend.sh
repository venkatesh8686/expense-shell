#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1) 
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILES="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER 


USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

#echo "user id is : $USERID"

if [ $USERID -ne 0 ]
then
  echo -e "$R please run this script with root privallages" | tee -a $LOG_FILES
  exit 1

fi

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is....$R failed $N" &>> $LOG_FILES
        exit 1
    else
        echo -e "$2 is... $G SUCCUSS $N" | tee -a $LOG_FILES
    fi
}

echo "Shell scrtiping started working:: $(date)" | tee -a $LOG_FILES

dnf install nginx -y &>> $LOG_FILES
VALIDATION $? "Installing nginx" 

systemctl enable nginx &>> $LOG_FILES
VALIDATION $? "Enableing nginx"

systemctl start nginx &>> $LOG_FILES
VALIDATION $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATION $? "Removing default website"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $LOG_FILES
VALIDATION $? "Validating frontend  code"

# shellcheck disable=SC2164
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $LOG_FILES
VALIDATION $? "Extracing frontend code"

systemctl restart nginx
VALIDATION $? "Restarting nginx"

