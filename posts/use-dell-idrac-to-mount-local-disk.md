Categories: dell
Tags: idrac
      mount
      disk

- Lets you mount a disk from a management server to a remote server (via the iDrac).

        # pwd
        /opt/dell/srvadmin/bin
        # rpm -q --whatprovides /opt/dell/srvadmin/bin/vmcli
        srvadmin-idrac-vmcli-6.5.0-1.252.1.el5


- Mounting a CD via the iDrac interface on `10.1.1.8`:

        # /opt/dell/srvadmin/bin/vmcli -r 10.1.1.8 -u root -p calvin -c /root/centos-5.5.iso
        Security Alert: Certificate is invalid - self signed certificate
        Continuing execution. Use -S option for vmcli to stop execution on certificate-related errors.
        Connecting to server....
          Connecting to 10.1.1.8
        . Login success.
        Mapping /root/centos-5.5.iso to Remote Device[0] as Read Only. Success.
        ..................................................................................................................................

