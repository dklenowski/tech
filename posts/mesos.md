Categories: containers
Tags: unix
      docker
      container
      linux
      devops
      mesos
      marathon


# Setup

## Server Setup

- You need to ensure your `mesos-slave` supports containerization.
- Add the following options and restart the `mesos-slave` (using `upstart` on Ubuntu)

        root@ops001:/etc/mesos-slave# cat containerizers
        docker,mesos
        root@meops001:/etc/mesos-slave# cat executor_registration_timeout
        5mins

### Ops Services

- For ops services (which run on special ports), the following additional {{mesos-slave}} configuration is required.

        root@ops002:/var/log/mesos# cat /etc/mesos-slave/resources
        ports(*):[53-53,4000-4000,8300-8500,31000-32000]

## Applying Json

### Applications

- To add a service using `json` run

        curl -X POST -H "Content-Type: application/json" http://localhost:8080/v2/apps -d@docker-qa.master.json

- You can add `?force=true` to the URL to force the app to run.

### Application Groups

- For application groups the REST URL is slightly different from an application deployment.

        curl -X POST -H "Content-Type: application/json" http://localhost:8080/v2/groups -d@mysql-qa2.json

- You can add `?force=true` to the URL to force the group to run.

# Example Config

## Web Server

    {
      "id": "/ops/httpd",
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "registry.com/gtau/httpd_2.4:prod",
          "network": "BRIDGE",
            "portMappings": [{
              "containerPort": 80,
              "hostPort": 80,
              "protocol": "tcp"
          }],
          "privileged": true,
          "forcePullImage": true
        }
      },
      "instances": 1,
      "cpus": 1,
      "mem": 2048,
      "constraints": [["hostname", "LIKE", "^ops002.*"]]
    }

## Consul Server

    {
      "id": "/ops/consul",
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "progrium/consul",
          "network": "BRIDGE",
          "portMappings": [
            { "containerPort": 8300, "hostPort": 8300, "protocol": "tcp" },
            { "containerPort": 8301, "hostPort": 8301, "protocol": "tcp" },
            { "containerPort": 8302, "hostPort": 8302, "protocol": "tcp" },
            { "containerPort": 8400, "hostPort": 8400, "protocol": "tcp" },
            { "containerPort": 8500, "hostPort": 8500, "protocol": "tcp" },
            { "containerPort": 53, "hostPort": 53, "protocol": "udp" }],
          "parameters": [
            { "key":"publish", "value": "8301:8301/udp" },
            { "key":"publish", "value": "8302:8302/udp" }],
          "privileged": true,
          "forcePullImage": true
        }
      },
      "args": ["-server", "-bootstrap", "-advertise", "10.40.19.216", "-ui-dir", "/ui"],
      "instances": 1,
      "cpus": 1,
      "mem": 2048,
      "constraints": [["hostname", "LIKE", "^ops001
      .*"]]
    }

## Marathon Server

    {
      "id": "/ops/marathon-consul",
      "args":[
        "--registry=http://ops002.cloud:8500",
        "--marathon-location=ops002.cloud:8080"
      ],
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "ciscocloud/marathon-consul",
          "network": "BRIDGE",
          "portMappings": [{"containerPort": 4000, "hostPort": 4000, "protocol": "tcp"}]
        }
      },
      "constraints": [["hostname", "LIKE", "^ops002.*"]],
      "ports": [4000],
      "instances": 1,
      "cpus": 1,
      "mem": 256 
    }


# Troubleshooting

## Connecting

### Marathon

    http://<host>:8080

## Mesos

    http://<host>:5050

- Using a tunnel like `ssh -f -N -L 5050:localhost:5050 david@ops002`

## Consul

    http://<host>:8500

- Using a tunnel like `ssh -f -N  -L 5051:localhost:5051 david@ops002`

### Check the state of the system

- mesos settings, id (which can be used to determine the master) etc

        curl localhost:5050/state.json | json_pp

### Monitoring the event stream

- Execute (on the leading master)

        curl -H  'Accept:text/event-stream' http://localhost:8080/v2/events
