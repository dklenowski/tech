Categories: unix
            linux
Tags: sudo

## References ##

[http://linsec.ca/Using_Sudo_to_Limit_Access](http://linsec.ca/Using_Sudo_to_Limit_Access)

## Overview

        <uid>    <allowed_uid>=(<uid_to_execute>) [NOPASSWD:] <commands>

        NOPASSWD is optional, user does not have to keep entering local password.

## Examples ##

### Allow a user webuser access to `httpd` stuff.

        Cmnd_Alias HTTPD_VI = /bin/vi /etc/httpd/*
        Cmnd_Alias HTTPD_RESTART = /etc/init.d/httpd

        ...
        
        webuser ALL=(root) NOPASSWD: HTTPD_VI, HTTPD_RESTART
        
