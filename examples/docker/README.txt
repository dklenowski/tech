## Master/Slave Setup

### To build a percona MySQL 5.5 master

    docker run -d --name test.master -e MYSQL_ROOT_PASSWORD=123qwe  -e MYSQL_SERVER_ID=30003  \
    -p 10.40.19.217:30003:3306 \
    registry.ecg.so/gtau/percona_5.5:master;
    
- where:
  - `10.40.19.217` is the interface IP
  - `30003` is the external port docker will create
  - `3006` is the internal port docker will map the external port to.

### To build a percona MySQL 5.5 slave

    docker run -d --name test.slave -e MYSQL_ROOT_PASSWORD=123qwe  -e MYSQL_SERVER_ID=30021 \
    -e MYSQL_SETUP_SLAVE=1 \
    -p 10.40.19.217:30021:3306 --link test.master:master registry.ecg.so/gtau/percona_5.5:slave;

- where:
  - `10.40.19.217` is the interface IP
  - `30021` is the external port docker will create
  - `3006` is the internal port docker will map the external port to.
  - A link (host entry) is setup between to the docker instance `test.master` (called `master` in the `/etc/hosts` file on this docker instance).


## master.json

    {
      "id": "/test/master",
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "registry.ecg.so/gtau/percona_5.5:master",
          "network": "BRIDGE",
            "portMappings": [{
              "containerPort": 3306,
              "hostPort": 31020,
              "servicePort": 10020,
              "protocol": "tcp"
          }],
          "privileged": true,
          "forcePullImage": true
        }
      },
      "env": {
        "MYSQL_ROOT_PASSWORD": "abc123",
        "MYSQL_SERVER_ID": "31020",
        "CONTAINER_NAME": "qa2.master"
      },
      "instances": 1,
      "cpus": 1,
      "mem": 2048,
      "constraints": [["hostname", "LIKE", "^ops002.*"]]
    }