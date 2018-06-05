Categories: linux
Tags: linux
      lftp
      ftp

## Using LFTP

    set ftp:proxy http://<proxy.com:3128>
    debug 9

    connect <username>:<password>@gumtree-au.upload.botify.com

    set ftp:ssl-allow true
    set ftp:ssl-force true
    set ftp:ssl-protect-data true
    set ftp:ssl-protect-list true

    set ftps:initial-prot P
