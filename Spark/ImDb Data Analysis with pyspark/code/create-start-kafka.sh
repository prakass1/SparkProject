#!/bin/bash
KAFKA_LOCATION=/usr/local/kafka
KAFKA_LOG_LOCATION=$KAFKA_LOCATION/logs/server.log
TOPIC=$1
DATE=`date +%Y-%m-%d`
if [[ -z $TOPIC ]]; 
then 
    echo "Please give a topic as an argument" 
    exit 1
fi

if [ -e kafka.log ]
then
    echo "--------------------------------"$DATE"--------------------------" >> kafka.log
else
    touch kafka.log
fi

nohup $KAFKA_LOCATION/bin/zookeeper-server-start.sh $KAFKA_LOCATION/config/zookeeper.properties &>> kafka.log&
sleep 10

val=`tail -10 $KAFKA_LOG_LOCATION | grep -i "binding to port"`
echo $val >> kafka.log
if [[ ! -z $val ]];
then
	nohup $KAFKA_LOCATION/bin/kafka-server-start.sh $KAFKA_LOCATION/config/server.properties &>> kafka.log&
	sleep 10
	val1=`tail -10 $KAFKA_LOG_LOCATION | grep -i "started"`
	echo $val1 >> kafka.log
	if [[ ! -z $val1 ]];
	then
		#Create a topic
		nohup $KAFKA_LOCATION/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic $TOPIC &>> kafka.log&
		sleep 5
		if [ $? != 0 ];
		then
			echo "Looks like topic could not be created please check logs and restart the whole process"
			echo "Looks like topic could not be created please check logs" >> kafka.log
			exit 1
		else
			echo "Successfully Executed all Required Commands check command: ps -eaf|grep java for more details"
			echo "All are successful" >> kafka.log
			exit 0
		fi
	fi
else
    echo "Looks like something is wrong"
    echo "Looks like something is wrong" >> kafka.log
	exit 1
fi
