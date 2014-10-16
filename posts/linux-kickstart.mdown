Categories: linux
Tags: kickstart
      dhcpd

## Setting up Kickstart ##

### DHCPD ###

- Used by kickstart to assign an ip address to the host.

1. Edit the `/etc/dhcp/dhcpd.conf` file and add the appropriate entries, e.g.:

        #
        # DHCP Server Configuration file.
        #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
        #   see 'man 5 dhcpd.conf'
        #
        ddns-update-style interim;
        ignore client-updates;
        
        subnet 172.17.12.0 netmask 255.255.255.0 {
          option routers 172.17.12.254;
          option domain-name "dev.harbour";
          option domain-name-servers 172.17.12.205;
          default-lease-time 21600;
          max-lease-time 43200;
        
          host client1 {
            next-server 172.17.12.221;
            filename "pxelinux.0";
            hardware ethernet 00:01:02:03:04:05;
            fixed-address 172.17.12.16;
          }
        }

2. Restart

        /etc/init.d/dhcpd restart

2. Ensure `dhcpd` is started at boot:

        chkconfig dhcpd on


### TFTP ###

- Used by kickstart to download both the PXE `bootloader` and the necessary Linux ram-disks and kernel images.

1. Create the following directory structures, all with `755` permissions:

        # mkdir –p /tftpboot/pxelinux.cfg
        # chmod –R 755 /tftpboot

2. Download version 3.55 of the `syslinux` distribution from http://www.kernel.org/pub/linux/utils/boot/syslinux/ and extract the `pxelinux.0` to the `/tftpboot` directory. i.e.

        # tar -xzvf syslinux-4.04.tar.gz 
        # cd syslinux-4.04
        # cp core/pxelinux.0 /tftpboot/
        # chmod 755 /tftpboot/pxelinux.0

3. Ensure the `tftp` configuration points to the `tftpboot` directory:

        # cat /etc/xinetd.d/tftp |grep server_args
          server_args    = -s /tftpboot

3. Install `tftp` and ensure that the `disable=yes` has been removed from the `/etc/xinetd.d/tftp` configuration file and restart the `xinetd` daemon.

        # /etc/init.d/xinetd restart

4. Ensure `xinetd` is started at boot:

        # chkconfig xinetd on


### Kickstart URL for RPM's

#### HTTP

- If using HTTP to server rpm's:

1. Create the following directory layout:

        # mkdir -p /kickstart/cfg
        # mkdir -p /kickstart/install


2. Create a vhost:

        <VirtualHost *>
                ServerName puppet.dev
                DocumentRoot /kickstart
                <Directory "/kickstart">
                        Options FollowSymlinks Indexes
                        AllowOverride All
                </Directory>
        </VirtualHost>

3. Restart the http daemon.

        # service httpd restart

4. The next step will actually mount something to `/kickstart/install`

#### NFS

- If using NFS to serve rpm's:

1. Create the following directory layout:

        # mkdir -p /kickstart/cfg
        # mkdir -p /kickstart/install

2. Add the following entry to `/etc/exports`:

        /kickstart      *(ro)

3. Restart the nfs daemon:

        /etc/init.d/nfs restart

4. Verify the “/kickstart” directory is being shared:

        # showmount -e localhost
        Export list for localhost:
        /kickstart *

5. Ensure `rpcbind` and `nfs` are started

        # /etc/init.d/rpcbind start
        # /etc/init.d/nfs start

5. Ensure NFS is being started at boot:

        # chkconfig rpcbind on
        # chkconfig nfs on

6. The next step will actually mount something to `/kickstart/install`

### Kickstart Images ###

- The following section lists the required steps to begin serving Kickstart images. 

1. Decide on a naming convention used for the image directory, e.g.

        <os><release>_<arch>
        centos-6.2-x86_64


1. Create the image directory:

        /tftpboot/<image>


2. Copy both the `initrd.img` and `vmlinuz` from the particular distribution to the image directory. e.g.

        # mount -o loop /mnt/iso/CentOS-6.2-x86_64-bin-DVD1.iso /mnt/centos62
        # cd /mnt/centos62
        # cp images/pxeboot/initrd.img /tftpboot/centos-6.2-x86_64/
        # cp images/pxeboot/vmlinuz /tftpboot/centos-6.2-x86_64/

3. Link the distribution to the `install` directory (specified in the previous step). e.g.

      # mount -o loop /mnt/iso/CentOS-6.2-x86_64-bin-DVD1.iso /mnt/centos62
      # ln -s /mnt/centos62 /kickstart/install/centos-6.2-x86_64






