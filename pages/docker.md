Categories: containers
Tags: unix
      docker
      container
      linux
      devops

# Commands

## List

     docker list

## List Containers

     docker ps -a

## Cleanup

    docker rm -v $(docker ps -a -q -f status=exited)
    docker rmi $(docker images -f "dangling=true" -q)

## Running

## Simple instance with bash prompt

  docker run -n=false -i -t <instanceid> /bin/bash
  docker run -n=false -i -t d658d6196048 /bin/bash

## Docker Networking

### Create a dynamic Bridge (for docker)

    ifconfig bridge0
    ifconfig bridge0 192.168.1.1 netmask 255.255.255.0

### Create a Static Bridge

    brctl addbr bridge1
    ifconfig bridge1 172.16.0.1 netmask 255.255.255.0

### Running docker with a specific bridge

    echo "DOCKER_OPTS=\"-b=bridge0\"" >> /etc/default/docker

### Create a static ip with a physical interface

- This will need to be public.

        pipework eth1 f43b2a90d144 10.252.98.10/25@10.252.98.1

- If using a privileged docker instance:
  - Find the pid of the docker instance (through `docker inspect`)

        docker run -h=pm001.ops --name="pm001.ops" -privileged=true -lxc-conf="aa_profile=unconfined" -d -i -t d658d6196048 /bin/   bash
    
        mkdir -p /var/run/netns
        rm -f /var/run/netns/3478
        ln -s /proc/3478/ns/net /var/run/netns/3478
    
        ip link add link eth1 dev puppetmeth1 type macvlan mode bridge
        ip link set eth1 up
        ip link set puppetmeth1 netns 3478
        ip netns exec 3478 ip link set puppetmeth1 name eth1
    
        ip netns exec 3478 ip addr add 10.252.98.10/25 dev eth1
        ip netns exec 3478 ip route delete default
        ip netns exec 3478 ip link set eth1 up
        ip netns exec 3478 ip route replace default via 10.252.98.1

### Configure Static Address

      pipework bridge1 <instance> <ip>/24@172.16.0.1
      pipework bridge1 89553574e0c3 172.16.0.3/24@172.16.0.1

## Miscellaneous docker commands


    docker run \
    -n=false \
    -lxc-conf="lxc.network.type = veth" \
    -lxc-conf="lxc.network.ipv4 = 10.252.98.10/25" \
    -lxc-conf="lxc.network.ipv4.gateway = 10.252.98.1" \
    -lxc-conf="lxc.network.link = bridge0" \
    -lxc-conf="lxc.network.name = eth0" \
    -lxc-conf="lxc.network.flags = up" \
    -i -t d658d6196048 /bin/bash


