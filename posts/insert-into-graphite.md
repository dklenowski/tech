Categories: linux
Tags: linux
      graphite


    PORT=2003
    SERVER=graph.com
    echo "local.random.diceroll 4 `date +%s`" | nc -q0 $SERVER $PORT
