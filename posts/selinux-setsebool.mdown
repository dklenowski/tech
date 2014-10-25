Categories: rhel
Tags: selinux
      setsebool

## `setsebool`

- By default, RHEL does not allow a server (out of the box) to run as a web/database server.
- To allow a server to function as a web/database server must call `setsebool`.

- e.g. for postgresql

        # setsebool –P postgresql_disable_trans 1

- e.g. for apache

        # setsebool –P httpd_disable_trans 1

- Note: `-P` used to preserve across reboot.


- Information about what domains the processes run in can be found at:
  - http://www.coker.com.au/selinux/talks/rh-2005/rhel4-tut.html
  - http://docs.fedoraproject.org/en-US/Fedora/13/html/Security-EnhancedLinux/sect-Security-EnhancedLinux-TargetedPolicy-UnconfinedProcesses.html