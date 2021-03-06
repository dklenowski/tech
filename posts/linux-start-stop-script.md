Categories: linux
Tags: init
      init.d

- Just modify `name`, `binary`, `options` and `pidcmd`

        #!/bin/bash
        #
        # start/stop script
        #
        
        name="tracd"
        binary="/usr/bin/tracd"
        options="-r -d --hostname=192.168.2.12 --port=80 --protocol=http \
                --auth=*,/trac/conf/digest,trac /trac"
        pidcmd="ps -ef |grep python |grep tracd | grep -v grep |awk '{print $2}'""
        
        . /etc/init.d/functions
        
        start() {
          echo -n "Starting $name "
          daemon --user=root $binary $options
          RETVAL=$?
          
          echo
          return $RETVAL
        }
        
        stop() {
          echo -n "Stopping $name "
          pid=`$pidcmd`
          if [ -n "$pid" ]; then
            kill $pid
            RETVAL=0
          else
            RETVAL=1
          fi
        
          if [ $RETVAL -eq 0 ]; then
            echo_success
          else
            echo_failure
            fi
        
          echo
          return $RETVAL
        }
        
        case "$1" in
          start)
            start
            ;;
          stop)
            stop
            ;;
          *)
            echo "Usage: $0 {start|stop}"
        esac
