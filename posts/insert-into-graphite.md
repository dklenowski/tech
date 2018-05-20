Categories: linux
Tags: linux
      graphite

## Bash

    PORT=2003
    SERVER=graph.com
    echo "local.random.diceroll 4 `date +%s`" | nc -q0 $SERVER $PORT

## Python

    graphite_host = 'graph.com'
    graphite_port = 2003
    graphite_metric = '%s.test.counter-seconds' % socket.gethostname()

    timestamp = int(time.time())
    message = "%s %.2f %d\n" % (graphite_metric, lag, timestamp)
    sock = socket.socket()
    sock.connect((graphite_host, graphite_port))
    sock.sendall(message)
    sock.close()
