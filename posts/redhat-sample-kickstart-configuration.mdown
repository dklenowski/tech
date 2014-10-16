Categories: linux
Tags: kickstart
      pxe

## PXE Configuration

    label linux
    kernel rhel51_x86_64/vmlinuz
    append ksdevice=eth0 console=tty0 load_ramdisk=1 initrd=rhel51_x86_64/initrd.img ks=nfs:<NFS_SERVER>:/kickstart/cfg/<KICKSTART_CONFIG_FILE>

## DHCPD Configuration

    #
    # DHCP Server Configuration file.
    #   see /usr/share/doc/dhcp*/dhcpd.conf.sample
    #
    ddns-update-style interim;
    ignore client-updates;

    subnet 192.168.108.0 netmask 255.255.255.0 {
        option routers 192.168.108.1;
        option domain-name "<DOMAIN_NAME>";
        option domain-name-servers <DNS_SERVER>;
        default-lease-time 21600;
        max-lease-time 43200;

        host <HOSTNAME> {
            next-server <KICKSTART_SERVER>;
            filename "pxelinux.0";
            hardware ethernet <MAC_ADDRESS>;
            fixed-address <IP_ADDRESS>;
        }
    }

## Kickstart Configuration

    #
    # basic settings
    #
    install
    lang en_US
    langsupport --default en_US
    keyboard us
    mouse generic3ps/2
    skipx
    key --skip
    text

    #
    # location of the nfs/kickstart server
    #
    nfs --server <NFS_SERVER> --dir /kickstart/install/rhel51_x86_64

    #
    # interface info, NOTE all servers should have statically configured IP's
    #
    network --device eth0 --bootproto static --ip <IP_ADDRESS> --netmask <NETMASK> --gateway <GATEWAY>

    #
    # the default root password, refer to the password database for un-encrypted contents
    #
    rootpw --iscrypted <ENCRYPTED_PASSWORD>

    #
    # basic services
    #
    authconfig --enableshadow --enablemd5
    firewall --disabled
    timezone --utc Australia/Brisbane

    #
    # disk layout
    # The following disk layout is the default for all servers built with kickstart
    # and should be modified at your peril !
    #
    bootloader --location=mbr
    clearpart --all --initlabel
    part /boot --fstype ext3 --size=100
    part pv.00 --size=10000 --grow
    volgroup vol00 pv.00
    logvol swap --fstype=swap --vgname=vol00 --name=lvol0 --size=1000
    logvol / --fstype=ext3 --vgname=vol00 --name=lvol1 --size=3000
    logvol /usr --fstype=ext3 --vgname=vol00 --name=lvol2 --size=2000
    logvol /var --fstype=ext3 --vgname=vol00 --name=lvol3 --size=1000
    logvol /tmp --fstype=ext3 --vgname=vol00 --name=lvol4 --size=1000

    #
    # package lists
    #
    # for subversion
    #   subversion-1.4.2-2.el5.x86_64.rpm
    #       apr-util-1.2.7-6.x86_64.rpm
    #           apr-util-1.2.7-6.x86_64.rpm
    #           postgresql-libs-8.1.4-1.1.x86_64.rpm
    #       perl-URI-1.35-3.noarch.rpm
    #       neon-0.25.5-5.1.x86_64.rpm
    #
    %packages --resolvedeps
    @ core
    apr
    postgresql-libs
    apr-util
    perl-URI
    subversion
    httpd
    ruby-libs
    ruby-devel
    ruby
    ruby-rdoc
    ruby-irb
    perl-DBI
    libgomp
    glibc-headers
    glibc-devel
    cpp
    gcc
    libstdc++-devel
    gcc-c++


    #
    # pre-install
    #
    %pre

    #
    # post-install nochroot
    #
    %post --nochroot

    configfile=/mnt/source/extra-pkgs/cfg/<HOST_CONFIG_FILE>

    if [ !-d /mnt/source ]; then
            mkdir /mnt/source
    fi

    mount -o ro /tmp/cdrom /mnt/source

    if [ -e "$configfile" ]; then
            while read line
            do
                    rpm -ivh --nodeps --root /mnt/sysimage /mnt/source/extra-pkgs/$line
            done < "$configfile"
    fi

    umount /mnt/source


    #
    # post install chroot
    #
    %post

    HOST="<HOSTNAME>"
    DOMAIN="<DOMAIN>"
    HOSTNAME=${HOST}.${DOMAIN}
    HOSTIP="<IP_ADDRESS"

    # groups

    groupadd www
    groupadd deploy

    # users

    useradd -d /home/www -g www -m -p '<ENCRYPTED_PASSWORD>' -s /bin/bash www
    useradd -d /home/deploy -g deploy -m -p '<ENCRYPTED_PASSWORD>' -s /bin/bash deploy


    # sudoers

    cat >> /etc/sudoers << EOF
    EOF

    # hosts[.allow|.deny]

    cat >> /etc/hosts.allow << EOF
    ALL: 127.0.0.1
    sshd: ALL
    EOF

    cat >> /etc/hosts.deny << EOF
    ALL: ALL
    EOF

    # banners
    #
    cat << EOF > /etc/motd

    |-----------------------------------------------------------------|
    | This system is for the use of authorized users only.            |
    | Individuals using this computer system without authority, or in |
    | excess of their authority, are subject to having all of their   |
    | activities on this system monitored and recorded by system      |
    | personnel.                                                      |
    |                                                                 |
    | In the course of monitoring individuals improperly using this   |
    | system, or in the course of system maintenance, the activities  |
    | of authorized users may also be monitored.                      |
    |                                                                 |
    | Anyone using this system expressly consents to such monitoring  |
    | and is advised that if such monitoring reveals possible         |
    | evidence of criminal activity, system personnel may provide the |
    | evidence of such monitoring to law enforcement officials.       |
    |-----------------------------------------------------------------|

    EOF

    cat << EOF > /etc/ssh/banner

    |-----------------------------------------------------------------|
    | This system is for the use of authorized users only.            |
    | Individuals using this computer system without authority, or in |
    | excess of their authority, are subject to having all of their   |
    | activities on this system monitored and recorded by system      |
    | personnel.                                                      |
    |                                                                 |
    | In the course of monitoring individuals improperly using this   |
    | system, or in the course of system maintenance, the activities  |
    | of authorized users may also be monitored.                      |
    |                                                                 |
    | Anyone using this system expressly consents to such monitoring  |
    | and is advised that if such monitoring reveals possible         |
    | evidence of criminal activity, system personnel may provide the |
    | evidence of such monitoring to law enforcement officials.       |
    |-----------------------------------------------------------------|

    EOF

    cat >> /etc/hosts << EOF
    $HOSTIP $HOSTNAME       $HOST
    EOF

    # network

    cp /etc/sysconfig/network /etc/sysconfig/network.orig
    sed -e "s/^HOSTNAME=.*$/HOSTNAME=$HOSTNAME/" /etc/sysconfig/network.orig > /etc/sysconfig/network


    # lighttpd stuff, required for openid
    #
    mkdir /home/www/pages
    chown www:www /home/www/pages

    mkdir /home/www/logs
    chown www:www /home/www/logs

    # openid/ruby stuff
    #
    /usr/bin/gem install fcgi -v=0.8.7
    /usr/bin/gem install rails -v=2.0.2
    /usr/bin/gem install net-ssh -v=1.1.2
    /usr/bin/gem install rake -v=0.8.1
    /usr/bin/gem install RedGreen -v=1.0
    /usr/bin/gem install ruby-openid -v=2.0.3
    /usr/bin/gem install capistrano -v=2.1.0
    /usr/bin/gem install capistrano-ext -v=1.2.0
    /usr/bin/gem install palmtree -v=0.0.6
    /usr/bin/gem install ruby-yadis -v=0.3.4
    /usr/bin/gem install hpricot -v=0.6