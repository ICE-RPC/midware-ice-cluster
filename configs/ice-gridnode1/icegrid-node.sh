#!/bin/bash
#created by wangfengliang

#Source function library.
. /etc/rc.d/init.d/functions

#Check that networking is up.
if [ "$NETWORKING" = "no" ]
then
    exit 0
fi

if [ "$HOSTNAME" == "" ];then
    HOSTNAME=`hostname`
fi

WORKDIR=$(cd `dirname $0`; pwd)

ICENODE="icegridnode"
ICECONFIGTPL="${WORKDIR}/icegrid-node.tpl.conf"
ICECONFIG="${WORKDIR}/icegrid-node.conf"
PIDFILE="icegrid-node.pid"

NODEID='node.id'

if [ ! -f $NODEID ]; then
    echo "file: $NODEID not exist"
    exit 1
fi
#ICENODENAME="$HOSTNAME"
ICENODENAME=`cat $NODEID`


. ${WORKDIR}/setenv.sh

ulimit -c unlimited

curDate=`date`

# 生成配置文件
sed "s/<NODENAME>/${ICENODENAME}/g" ${ICECONFIGTPL} > ${ICECONFIG}
TMPWORKDIR=${WORKDIR//\//\\\/} #转义
sed -i "s/<NODEDIR>/${TMPWORKDIR}/g" ${ICECONFIG}
sed -i "s/<HOSTNAME>/${HOSTNAME}/g" ${ICECONFIG}

RETVAL=0
SELF_SCRIPT="$0"
SERVER_WC=`ps -ef | fgrep ${ICENODE} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCRIPT" | wc -l`
SERVER_PIDS=`ps -ef | fgrep ${ICENODE} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCRIPT" | awk '{print $2}'`

start(){
    if [ ${SERVER_WC} -ge 1 ];then
        echo "$curDate ${ICENODE} already is running......"
    else
        mkdir -p $WORKDIR/db/ $WORKDIR/logs/
        cd ${WORKDIR}; ${ICENODE} --nochdir --daemon --Ice.Config=${ICECONFIG}
        RETVAL=$?
        if [ $RETVAL -ne 0 ] ; then
            action "$curDate start $ICENODE fail......"  /bin/false
            exit 1
        else
            action "$curDate start $ICENODE success......"  /bin/true
        fi
    fi
}

stop(){
    if [ ${SERVER_WC} -ge 1 ];then
        #kill -9 ${SERVER_PIDS}
        kill ${SERVER_PIDS}
        RETVAL=$?
        if [ $RETVAL -eq 0 ] ; then
            action "$curDate stop $ICENODE ok......" /bin/true
        else
            action "$curDate stop $ICENODE fail......" /bin/false
            exit 1 
        fi
    else
        echo "$curDate ${ICENODE} is not running......"
    fi
}

status(){
    ps -ef | fgrep ${ICENODE} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCRIPT"
}

list(){
    echo "icegridnode list:"
    icegridadmin --Ice.Config=${ICECONFIG} -e "node list"
}

#See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  info)
    status 
    ;;
  status)
    status 
    ;;
  list)
    list
    ;;
  *)
    echo "Usage: $0 {start|stop|info|list}"
    exit 1
esac

exit 0
