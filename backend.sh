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

dnf module disable nodejs -y
VALIDATION $? "Disabling nodjs"

dnf module enable nodejs:20 -y
VALIDATION $? "Enable nodejs"

dnf install nodejs -y
VALIDATION $? "Installing nodejs"

useradd expense
VALIDATION $? "adding user "