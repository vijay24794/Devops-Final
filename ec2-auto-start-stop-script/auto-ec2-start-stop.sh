#!/bin/bash
#
#
#this script is written for demo purpose only,script covers the below
#1) Checks if instance have "key - Nightsleep" and its value.(possible values are  "True|false")
#2) When script called with option "start" - script starts all instances with "key/value" = "Nightsleep/true"
#3)When script called with option "stop" - script stops all instances with "key/value" = "Nightsleep/true"
#
#if Instance, does not have "Key/value"="Nightsleep/True", this script will do NOTHING
#
#As mentioned, this script is for demo.Use at your own risk. Manikandan - 10/12/2017

#varible definitions
AWS_CLI='/usr/bin/aws ec2'
DATE=`date +%Y-m%m-%d`
LOGDIR='/var/log/nightsleep'
LOG_START_INST=$LOGDIR/startlog.$DATE
LOG_STOP_INST=$LOGDIR/$stoplog.$DATE

# checks if log directory exists or not.Creates if missing

if [ ! -d $LOGDIR ] ;then
   mkdir -p $LOGDIR
   chmod 700 $LOGDIR
fi

# this function is to collect the instance-id for instance with key/value = Nightsleep/True

function COLLECT_NIGHT_SLEEP_INSTANCES () {

   $AWS_CLI describe-instances --filter "Name=tag-key,Values=Nightsleep" "Name=tag-value,Values=True" --query "Reservations[].Instances[].[InstanceId ,Tags]" --output text  | awk '{print $1}'

}

# this function is to start the instance with Key/value = Nightsleep/True

function INSTANCE_START() {

   INST_NIGHT_SLEEP=(`COLLECT_NIGHT_SLEEP_INSTANCES`)

   for INSTANCE_ID in "${INST_NIGHT_SLEEP[@]}";do
       echo "##working on the instance startup : $INSTANCE_ID ##" | tee -a $LOG_START_INST
       $AWS_CLI start-instances --instance-id $INSTANCE_ID | tee -a $LOG_START_INST
   done
}

# this function is to stop the instance with Key/value = Nightsleep/True

function INSTANCE_STOP() {

   INST_NIGHT_SLEEP=(`COLLECT_NIGHT_SLEEP_INSTANCES`)

   for INSTANCE_ID in "${INST_NIGHT_SLEEP[@]}";do
       echo "##working on the instance stop : $INSTANCE_ID ##" | tee -a $LOG_STOP_INST
       $AWS_CLI stop-instances --instance-id $INSTANCE_ID | tee -a $LOG_STOP_INST
   done
}

# thsi function is to check the status of instance with key/value = Nightsleep/True

function INSTANCE_STATUS() {

   INST_NIGHT_SLEEP=(`COLLECT_NIGHT_SLEEP_INSTANCES`)

   for INSTANCE_ID in "${INST_NIGHT_SLEEP[@]}";do
       INSTANCE_STATE=$($AWS_CLI describe-instances --instance-id $INSTANCE_ID --output text | grep -w STATE | awk '{print $NF}')
       echo "Instance $INSTANCE_ID is under Night sleep and Its current state is $INSTANCE_STATE"
   done
}

##Main code

OPTION=$1
case $OPTION in
     start)  INSTANCE_START;;
     stop)   INSTANCE_STOP;;
     status) INSTANCE_STATUS;;
     *)      echo "Error occured : valid options are stop/start/status";;
esac
exit 0

