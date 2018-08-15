Categories: bash
Tags: for
      loop
      split
      string


    #!/bin/bash
    
    hosts="
    a.com
    b.com"
    
    for host in $hosts; do
      echo -n "Restarting puppet on $host.."
      ssh -o StrictHostKeyChecking=no root@$host "sudo bash -c \"/etc/init.d/puppet restart\""
      echo "done"
    done