#!/bin/bash
#Create By yousj
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf
START_JAR_NAME=/xm-test-0.0.1-SNAPSHOT.jar
MAIN_CLASS=com.xm.demo.DemoApplication
SERVER_NAME=XM-TEST
JAVA=""
#JVM_OPTS="-Xms512m -Xmx1024m"
#JAVA_OPTS="-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dspring.devtools.restart.enabled=false "$JVM_OPTS
JAVA_OPTS=""
start(){
 if [ -z "$JAVA" ] ; then
  JAVA=$(which java)
 fi
 echo '>>>>>>>>>>Hello ...'
 #判断服务是否已经存在
 ps -ef| grep $SERVER_NAME| grep -v "grep" |awk '{print $2}'|while read pid
 do
    echo '>>>>>>>>>>'$SERVER_NAME' SERVER has bean started ,run processing PID:'$pid
    kill 0      
 done
 echo '>>>>>>>>>>'$SERVER_NAME' SERVER began to start.'
 LIB_DIR=$DEPLOY_DIR/lib
 LIB_JARS=$LIB_DIR$START_JAR_NAME
 process
 exec $JAVA $JAVA_OPTS  -classpath $CONF_DIR:$LIB_JARS $MAIN_CLASS $SERVER_NAME &
 echo '>>>>>>>>>>'$SERVER_NAME' SERVER has bean started.'
 ps -ef| grep $SERVER_NAME| grep -v "grep" |awk '{print $2}'|while read pid
 do
    echo '>>>>>>>>>>Run Processing PID:'$pid
 done

}  
 
stop(){  
 ps -ef| grep $SERVER_NAME| grep -v "grep" |awk '{print $2}'|while read pid
 do  
    echo '>>>>>>>>>>Run Processing PID:'$pid
    kill -9 $pid  
 done
 echo '>>>>>>>>>>'$SERVER_NAME' SERVER began to close.'
 echo '>>>>>>>>>>'$SERVER_NAME' SERVER has been closed.'
 echo '>>>>>>>>>>Bye-bye......'  
}

status(){
  pid=`ps -ef| grep $SERVER_NAME| grep -v "grep" |awk '{print $2}'`
  if [ "$pid" != "" ] ; then
    echo '>>>>>>>>>>'$SERVER_NAME' SERVER is running,Run Processing PID:'$pid
  else
    echo '>>>>>>>>>>'$SERVER_NAME' SERVER is not run.'
  fi
} 

process(){
	b=''
	i=0
	while [ $i -le  100 ]
	do
	    printf "progress:[%-50s]%d%%\r" $b $i
	    sleep 0.1
	    i=`expr 2 + $i`
	    b=#$b
	done
	echo	
}
 
case "$1" in  
start)  
start $3
;;  
stop)  
stop  
;;    
restart)  
stop  
start $3  
;;
status)
status
;;  
*)  
printf 'Usage: %s {start|stop|restart|status}\n' "$prog"  
exit 1  
;;  
esac

