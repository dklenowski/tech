#!/bin/bash

type=$1
if [ "$type" = "master" ]; then
  cp my-master.cnf.5.6 percona-5.6/my.cnf
elif [ "$type" = "slave" ]; then
  cp my-slave.cnf.5.6 percona-5.6/my.cnf
else
  echo "$0 [master|slave]"
  exit 1
fi



docker build -rm -t registry.com/au/percona_5.6:${type} percona-5.6/
docker push registry.com/au/percona_5.6:${type}

