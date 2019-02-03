#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

#
# need to check node role?
#
#ROLE=`uci get gluon-node-info.@system[0].role`
#
#
# get uci values to block wifi meshing with them
#
IP_LIST=`uci get rsk.@pingcheck[0].iplist`
DISABLED=`uci get rsk.@pingcheck[0].disabled`
FAILCOUNTFILE=/var/run/ping_failcount
# wie viele Fehlversuche vor dem Reboot (min)
MAXFAILCOUNT=`uci get rsk.@pingcheck[0].maxfail`
#
#
#
if [ $DISABLED -eq 0 ]; then


   if [ -f $FAILCOUNTFILE ]; then
      read failcount < $FAILCOUNTFILE
    

      LIST=$(echo $IP_LIST | tr "\s" "\n")
            # loop for every entry in iplist
              # echo $LIST
                for IP in $LIST
                 do
                   PING_DROP = `ping -c 1 -6 -q $IP | grep received | cut -d ',' -f 3 | cut -d '%' -f 1`
                   if [ $PING_DROP -eq 0 ]; then
                        # everything is ok
                        else
                        # we have drops - lets increase error count
                        
                   fi


                 done

    else
        echo 0 > $FAILCOUNTFILE
        # debug
        # echo "Bisher keine Fehler\n"

   fi

else
        echo "pingcheck uci setting shows DISABLED=true"

fi
