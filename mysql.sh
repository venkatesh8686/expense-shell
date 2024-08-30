#!/bib/bash

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
        echo "$R $2 is.. .failed.. check the cmd " &>> $LOG_FILES
    else
        echo "$G $2.. is installing" | tee -a $LOG_FILES
    fi
}

echo "Shell scrtiping started working:: $(date)" | tee -a $LOG_FILES

dnf install mysql-server -y
VALIDATION $? "mysql is started installing"

systemctl enable mysqld
VALIDATION $? "mysqsld is enable"

systemctl start mysqld
VALIDATION $? "mysql is started"

systemctl status mysqld
VALIDATION $? "Status of mysqlsd"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATION $? "Setting up of root passwords"