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
        echo -e "$2 is....$R failed $N" &>> $LOG_FILES
        exit 1
    else
        echo -e "$2 is... $G SUCCUSS $N" | tee -a $LOG_FILES
    fi
}

echo "Shell scrtiping started working:: $(date)" | tee -a $LOG_FILES

dnf install mysql-server -y 
VALIDATION $? "Installing mysql server"

systemctl enable mysqld &>>$LOG_FILES
VALIDATION $? "Enabling mysql server"

systemctl start mysqld &>>$LOG_FILES
VALIDATION $? "Starting mysql server"

# systemctl status mysqld
# VALIDATION $? "Status of mysqlsd"&>>$LOG_FILES 

mysql -h mysql.vvsmgold.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILES 
if [ $? -ne 0 ]
then
    echo "Mysql root password settingnow" &>>$LOG_FILES
    mysql_secure_installation --set-root-pass ExpenseApp@1 
    VALIDATION $? "setting up root password" 
else
    echo -e "$Y mysql root password already setup.. $Y skipping $N" | tee -a $LOG_FILES
fi
