Categories: linux
Tags: ssh
      tunnel
      linux


# Examples

## Tunnel elasticsearch port 9200 through localhost to a remote Elasticsearch server

  ssh -Nf -L 9200:localhost:9200 root@es-master001.cloud

## Tunnel JMX through bastion to a remote server running java JMX

  ssh -N -f -D 10078 <bastion>
  jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=10078 <java-server>:<java-port>


