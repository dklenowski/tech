Categories: python
Tags: python
      hostname
      ip

## Get the Fully Qualified Domain Name of a host

    import socket
    ..
    fqdn = socket.getfqdn()

## Perform a reverse lookup of a host (ip to hostname)

    import socket
    ..
    def get_hostname(ip):
      log.debug("looking up %s" % ip)
      try:
        return socket.gethostbyaddr(ip)[0]
      except:
        log.warn("failed to resolve %s" % ip)
        return ip
