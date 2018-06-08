#!/bin/bash
#created by wangfengliang

#Source function library.
. /etc/rc.d/init.d/functions

#Check that networking is up.
if [ "$NETWORKING" = "no" ]
then
    exit 0
fi

WORKDIR=$(cd `dirname $0`; pwd)

ICEPREFIX=/home/apps/cpplibs/Ice-3.6.4
export LD_LIBRARY_PATH=${ICEPREFIX}/libs:$LD_LIBRARY_PATH
export PATH=${ICEPREFIX}/bin:$PATH

ICEREGISTRY="icegridregistry"
ICECONFIG="${WORKDIR}/icegrid-registry.conf"
PIDFILE="icegrid-registry.pid"

ulimit -c unlimited

RETVAL=0
SELF_SCRIPT="$0"
SERVER_WC=`ps -ef | fgrep ${ICEREGISTRY} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCRIP    T" | wc -l`
SERVER_PIDS=`ps -ef | fgrep ${ICEREGISTRY} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCR    IPT" | awk '{print $2}'`

start(){
    if [ ${SERVER_WC} -eq 1 ];then
        echo "[`date`] ${ICEREGISTRY} already is running......"
    else
        mkdir -p $WORKDIR/db/ $WORKDIR/logs/
        cd ${WORKDIR}; ${ICEREGISTRY} --nochdir --daemon --Ice.Config=${ICECONFIG}
        RETVAL=$?
        if [ $RETVAL -ne 0 ] ; then
            action "[`date`] start $ICEREGISTRY fail......"  /bin/false
            exit 1
        else
            action "[`date`] start $ICEREGISTRY success......"  /bin/true
        fi
    fi
}

stop(){
    if [ ${SERVER_WC} -eq 1 ];then
        #kill -9 ${SERVER_PIDS}
        kill ${SERVER_PIDS}
        RETVAL=$?
        if [ $RETVAL -eq 0 ] ; then
            action "[`date`] stop $ICEREGISTRY ok......" /bin/true
        else
            action "[`date`] stop $ICEREGISTRY fail......" /bin/false
        fi
    else
        echo "[`date`] ${ICEREGISTRY} is not running......"
    fi
}

status(){
    ps -ef | fgrep ${ICEREGISTRY} | fgrep "${ICECONFIG}" | fgrep -v ' grep ' | fgrep -v "$SELF_SCRIPT"
}

list(){
    echo "icegridregistry list:"
    icegridadmin --Ice.Config=${ICECONFIG} -e "registry list"
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
    echo $"Usage: $0 {start|stop|info|list}"
    exit 1
esac

exit 0
