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

dnf module disable nodejs -y &>> $LOG_FILES
VALIDATION $? "Disabling nodjs"

dnf module enable nodejs:20 -y &>> $LOG_FILES
VALIDATION $? "Enable nodejs"

dnf install nodejs -y &>> $LOG_FILES
VALIDATION $? "Installing nodejs"

id expense &>> $LOG_FILES
if [ $? -ne 0 ]
then 
    echo -e "expense user not exits ....$G Creating user $N"
    useradd expense &>> $LOG_FILES
    VALIDATION $? "Creating expense user "
else
    echo -e "Expense user already extis....$Y skipping $N"
fi

mkdir -p /app
VALIDATION $? "Creating /app folder"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILES
VALIDATION $? "Downloading the backend application code"

cd /app || 
#rm -rf /app/* #remving all files adding new vesrion  
unzip /tmp/backend.zip &>> $LOG_FILES
VALIDATION $? "Extracting backend code"

