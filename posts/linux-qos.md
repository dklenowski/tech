Categories: linux
Tags: qos
      performance

## Sample init script

      # !/bin/sh
      # 
      # chkconfig: 2345 56 10
      # description: QoS startup script for eth0
      
      # Source function library.
      . /etc/init.d/functions
      
      TC=/sbin/tc
      DEV=eth0
      
      # queueing parameters
      UPLINK=6000kbit     # max up/down
      
      CLASS1_RTE=2500kbit # ssh/ping
      CLASS1_BST=500kbit
      
      CLASS2_RTE=3000kbit # everything else
      CLASS2_BST=1000kbit
      
      RETVAL=0
      
      create() {
      
        echo -n $"Creating QoS rules: "
      
        # Create the root and the parent qdisc's
        $TC qdisc add dev $DEV root handle 1: htb default 20
        $TC class add dev $DEV parent 1: classid 1:1 htb rate $UPLINK ceil $UPLINK
      
        # Class 1
        $TC class add dev $DEV parent 1:1 classid 1:10 htb rate $CLASS1_RTE burst $CLASS1_BST cburst $CLASS1_BST prio 1
        $TC qdisc add dev $DEV parent 1:10 handle 10: sfq perturb 10
      
        # Class 2 (default)
        $TC class add dev $DEV parent 1:1 classid 1:20 htb rate $CLASS2_RTE burst $CLASS2_BST cburst $CLASS2_BST prio 2
        $TC qdisc add dev $DEV parent 1:20 handle 20: sfq perturb 10
      
        # Filters
        U32="$TC filter add dev $DEV parent 1:0 protocol ip prio 1 u32"

        # Class 1
        $U32 match ip tos 0x10 0xff flowid 1:20   # interactive (tos min delay i.e. ssh but not scp)
        $U32 match ip protocol 1 0xff flowid 1:20 # icmp
      
        [ $RETVAL -eq 0 ] && success || failure
        echo
        return $RETVAL
      }
      
      destroy() {
        echo -n $"Destroying QoS rules: "
        
        # Delete any existing classes
        $TC qdisc del dev $DEV root
      
        [ $RETVAL -eq 0 ] && success || failure
        echo
        return $RETVAL
      }
      
      restart() {
        destroy
        create
      }
      
      case "$1" in
          start)
        create
              RETVAL=$?
              ;;
          stop)
        destroy
              RETVAL=$?
              ;;
          restart)
              restart
              RETVAL=$?
        ;;
          *)
              echo $"Usage: $0 {start|stop|restart}"
              RETVAL=1
              ;;
      
      esac
      exit $RETVAL

## Viewing statistics ##

### Show queueing class statistics 

      # tc -s -d class show dev eth4

### Show queueing discipline statistics

      # tc -s -d qdisc show dev eth0
