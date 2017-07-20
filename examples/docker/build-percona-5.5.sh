#!/bin/bash

type=$1

rm -fr percona-5.5/sql/
mkdir percona-5.5/sql/

if [ "$type" = "master" ]; then
  cp my-master.cnf percona-5.5/my.cnf
  cp -r master-sql/* percona-5.5/sql/ 
elif [ "$type" = "slave" ]; then
  cp my-slave.cnf percona-5.5/my.cnf
  cp -r slave-sql/* percona-5.5/sql/ 
else
  echo "$0 [master|slave]"
  exit 1
fi


docker build -rm -t registry.com/au/percona_5.5:${type} percona-5.5/
docker push registry.com/au/percona_5.5:${type}
