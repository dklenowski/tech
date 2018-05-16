Categories: server management
Tags: foreman
      puppet

# Puppet and Foreman

- Note this is based on an old version of puppet/foreman (around 2012).

## Overview ##

This document provides an overview of the features of Foreman/Puppet that have been tested/validated. 
As the features of foreman/puppet is considerable, only those features relevant to the HMSP environment were tested.

### Foreman ###

Foreman provides a web front-end for managing the deployment of servers from kickstart/jumpstart/preseed to the installation and configuration of puppet.

### Puppet ###

Puppet provides easy automated configuration and administration of servers.

## Foreman ##

### What can Foreman Do?

Foreman can:

- Automatically configure the `pxelinux.cfg` host entries.
- Automatically configure the `dhcp` leases for a host.
- Automatically download `initrd` and `vmlinuz` images for unattended installations.
- Generate kickstart configuration using templates/snippets.
- Optionally, configure hosts to use Puppet classes.

### Overview ###

Foreman utilises 2 main paths for configuration information:

#### `/etc/foreman`

- Contains the main foreman configuration information.

#### `/usr/share/foreman`

- Contains the foreman ruby infrastructure.
- There is a directory called `config` within this path that symlinks to files with `/etc/foreman`.
- i.e.

        # ls -la /usr/share/foreman/config|grep etc
        lrwxrwxrwx  1 root root   25 Mar 13 12:08 database.yml -> /etc/foreman/database.yml
        lrwxrwxrwx  1 root root   23 Mar 13 12:08 email.yaml -> /etc/foreman/email.yaml
        lrwxrwxrwx  1 root root   26 Mar 13 12:08 settings.yaml -> /etc/foreman/settings.yaml

### Important URL's

- The default URL for foreman is:

        http://<foreman.server>:3000/

- To view a Kickstart Configuration File for host `1.2.3.4` use:

        http://<foreman.server>:3000/unattended/provision?spoof=1.2.3.4

### Initial Setup

1.  Install the `foreman.repo` repository:

        # cat > /etc/yum.repos.d/foreman.repo << EOF
        [foreman]
        name=Foreman Repo
        baseurl=http://yum.theforeman.org/stable
        gpgcheck=0
        enabled=1
        EOF

2.  Install the required rpm's:

        # yum install foreman mysql-server make gcc ruby-devel mysql-devel

3.  Grant a user on the MySQL database:

        # mysql -uroot
        mysql> create user 'foreman'@'localhost' identified by 'f0rem1n';
        mysql> GRANT ALL PRIVILEGES ON *.* TO 'foreman'@'localhost';

4.  Associate the database created in Step `3` in the `/etc/foreman/database.yml`

        production:
           adapter: mysql
           database: foreman_production
           username: foreman
           password: f0rem1n
           socket: "/var/lib/mysql/mysql.sock"

5.  Create a database

        # mysql -uroot
        mysql> create database foreman_production

6.  Run the `rake` db task to create the database:

        # cd /usr/share/foreman
        # rake db:migrate RAILS_ENV="production"

7.  To start foreman via the command line

        # cd /usr/share/foreman/script
        # script/server -b <hostname> -e production


### Foreman Proxy

While the Foreman application provides a web frontend, foreman proxy provides the backend services (e.g. configuration of `tftp`/`dhcp`).

### Initial Setup

1.  Foreman proxy can be installed via rpm

        # yum install foreman-proxy

2.  Since HMSP will be using foreman-proxy to configure dhcp/tftp/kickstart the 
following permission changes are required on the forman server.

        # usermod -G root foreman-proxy
        # chmod -R g+w /etc/dhcp/         ?? DK, this may not be required 
        # chmod g+w /tftpboot/
        # chmod g+w tftpboot/pxelinux.cfg/


### Automated Configuration

If there is an existing puppet installation it is possible to import the 
necessary host/facts/classes. Move to the foreman home directory and run the following commands;

        # rake puppet:import:puppet_classes RAILS_ENV=production
        # rake puppet:import:hosts_and_facts RAILS_ENV=production 


### Manual Configuration

All foreman configuration is controlled via the web interface.
The following section provides information on the initial setup required to 
allow foreman to build development hosts on `CentOS 6.2 x86_64`.

#### Define a Smart Proxy

The smart proxy is used by foreman to configure all the boot ancillary 
protocols (e.g. `dhcp`, `tftp` etc). Select `More>Smart Proxies` on the Foreman UI 
and define a Smart Proxy with the following parameters:

        Name: puppetcom.dev
        URL: http://172.17.12.221:8443

#### Define an Operating System

The `Operating System` item associated both the partition tables and installation 
media (for `tftpboot`) for a host. Select `More>Operating Systems` on the Foreman 
UI and define an Operating System called `centos 6.2` with the following parameters:

        Name: centos
        Major: 6
        Minor: 2
        OS Family: Redhat
        Architectures: x86_84
        Partition Tables: RedHat default
        Installation Media:  CentOS mirror

#### Define an Architecture

The `Architectures` item appears to be a purely cosmetic item but nevertheless 
is still required when defining a host. Select `More>Architectures` on the 
Foreman UI and define an architecture called `x86_64` and associate it with 
the `centos 6.2` Operating System defined above.

#### Define a Domain

A `Domain` is used to identify subnets that are defined in the `Subnet` 
item (see next section). Select `More>Domains` and create a domain with the 
following parameters:

        Name: dev
        Fullname: dev

#### Define a Subnet

A `Subnet` item is used to by Foreman Proxy to configure DHCP.
Select `More>Subnets` and create a subnet with the following parameters:

        Name: dev
        Network: 172.17.12.0
        Netmask: 255.255.255.0
        Domain: dev
        Dhcp: puppetcom.dev
        Tftp: puppetcom.dev

#### Define a Environment

The `Environment` item appears to be purely cosmetic item but nevertheless is 
still required when defining a `hostgroup` (and subsequently a host). Select 
`More>Environments` on the Foreman UI and define an environment called `production`.

#### Define a Host Group

The `Hostgroup` is used to associate hosts with a `puppetmaster`.
Select `More>Host Groups` on the Foreman UI and define a `hostgroup` called 
`hostgroup1` with the following parameters:

        Required:
          Name: hostgroup1
          Environment: production
          Puppet Master Proxy: puppetcom.dev
          Puppet Master FQDN: puppetcom.dev
        Optional:
          Domain: dev
          Subnet: dev
          Architecture: x86_64
          Operation Systems: CentOS 6.2
          Media: CentOS mirror
          Partition Table: Redhat default

#### Define a Partition Table

A `Partition Table` is defined so as to be called within the Kickstart 
configuration using the macro `@host.diskLayout`. Select `More>Partition Tables` 
and define the following `Default Centos` partition table and associated it with 
the `CentOS 6.2` operating system:

        zerombr yes
        clearpart --all --initlabel
        part /boot --fstype ext3 --size=100 --asprimary
        part /     --fstype ext3 --size=1024 --grow
        part swap  --recommended


#### Define a Host

The host item ties everything together. Select the `Hosts` tab and click the 
`New Host` button and create a host with the following parameters:

        Primary:
          Name: puppetclient1
          Hostgroup: hostgroup1
          Environment: production
          Puppet Master FQDN: puppetcom.dev
        Network:
          MAC: 00:50:56:93:00:19
          Domain: dev
          Subnet: dev
          IP: 172.17.12.16
        Operating System:
          Architecture: x86_64
          Operating Systems: centos 6.2
          Media: CentOS mirror
          Partition Table: RedHat default
          Root Password: <rootpassword>

### Template Configuration

One of the exciting features of foreman, is the ability to define various 
templates that can be used during the build process. In relation to Kickstart, 
both the `pxelinux` and kickstart configuration files can be defined as a 
"Provisioning Template". Snippets can also be defined and used within the 
Kickstart/`pxelinux` configuration.  The templates required for a CentOS install are shown in 
Appendix 4 and consist of the following:

- `Kickstart default PXElinux`
  - A `PXElinux` file defining the `tftp` boot parameters for the host.
- `epel.repo` 
  - A snippet containing information for the local `epel` repository.
- `puppet.conf`
  - A snippet containing generic puppet configuration information.
- Kickstart provisioning template
  - A template that defines the minimum configuration necessary to install a base operating system with puppet.

## Puppet

### Installation

#### Client

The client installation/configuration of puppet is integrated into Kickstart (Appendix 3).


#### Server

- The community edition of puppet is quite simple to install using the `epel` repository, i.e.:

        # wget http://mirror.optus.net/epel/6/x86_64/epel-release-6-5.noarch.rpm
        # rpm -ivh epel-release-6-5.noarch.rpm
        # yum install puppet-server


### Configuration Management

Two repositories currently exist to manage changes to the configuration of puppet, namely:

        http://hg/puppet-dev-environment/
        http://hg/puppet-prod-environment/

Within these directories is a script called `setupenv.sh` that takes a single
argument specifying the type of environment (`dev`/`prod`) and builds the 
corresponding environment. 

For example to setup a development environment on a machine:

        # cd /etc
        # hg clone http://hg/puppet-dev-environment/
        # cd puppet-dev-environment
        # ./setupenv.sh dev

And to setup a production environment on a machine:

        # cd /etc
        # hg clone http://hg/puppet-prod-environment/
        # cd puppet-prod-environment
        # ./setupenv.sh prod 

### Configuration Change Management

As puppet is a powerful tool, it is necessary to develop a configuration change 
management policy to ensure changes are checked before being pushed to the 
production environment. In terms of the repositories described above, the 
development repository is effectively a scratchpad and not used at all in 
the production environment. The production repository `mainline` is the main 
development line for production. When a user requires to push a change into 
production, a process similar to the following could be utilised:

1. Add the change to the mainline

        # hg commit --message "REQ101 - Added change."
        # hg push

2. Create a release branch

        # hg branch stable1.2
        # hg commit --message "Created stable1.2 branch."

3. Sanity check the branch with the previous (working) release branch.

        # hg log -r stable1.0

4. Fix if insane, otherwise switch the puppet repository to the new branch and push the configuration changes.

        # hg update -C stable1.2
        # puppetrun ....

### Module Layout

Three directories exist in the default puppet module directory (`/etc/puppet/modules`), namely:

        custom
        site
        virtual

#### custom

This directory contains 1 main subdirectory called `/lib/facter` that contains 
custom HMSP facts. For example,

        # cat /etc/puppet/modules/custom/lib/facter/operatingsystemmajorrelease.rb 
        Facter.add('operatingsystemmajorrelease') do
          setcode do
            begin
              Facter.operatingsystemrelease
            rescue
              Factor.loadfacts()
            end
         
            operatingsystemmajorrelease = Facter.value('operatingsystemrelease').gsub(/\.[0-9]+$/, '')
          end
        end

#### site

This directory contains HMSP specific classes. For example, a class 
`site::base::defaultusers` is defined as follows:

        # cat /etc/puppet/modules/site/manifests/base/defaultusers.pp 
        class site::base::defaultusers {
          include virtual::users, virtual::groups
        
          realize(
            User['davek'],
            Ssh_authorized_key['davek']
          )
        }

#### virtual

This directory defines virtual users and groups. The following important 
files are contained within this directory:

        virtual/manifests/users.pp
        virtual/manifests/groups.pp

##### groups

Group entries that are to be `realized` within puppet modules require a 
definition similar to the following: 

        class virtual::groups {
          @group { 'davek':
            ensure => present ,
            gid    => 5000,
          }
        }

The entry can then be `realized` in a module using the following syntax:

        class aclass {
          include virtual::groups

          realize(
            Group['davek'] )
        }


##### users

User entries are created and used in a similar way to groups. An example user definition is:

        class virtual::users {
          @user { 'davek':
            ensure     => present,
            uid        => 5000,
            home       => '/home/davek',
            managehome => true
          }
          @ssh_authorized_key { "davek":
            ensure => present,
            name => 'davek@harbourmsp.com',
            user => 'davek',
            type => 'ssh-rsa',
            key => "foo"
          }
        }

The user is then `realized` in a module using the following syntax:

        class aclass {
          include virtual::users
          realize(
            User['davek'],
            Ssh_authorized_key['davek']
          )
        

### Implementation Notes

#### Autosigning

In order to automate the puppet installation process it is necessary to enable 
the `autosign` feature within puppet. This feature allows the unattended 
installation of the puppet keys that are used to establish secure communication 
between the `puppetmaster` and client.

In order to use this feature, the host/domain that is being built needs to 
added to the `/etc/puppet/autosign.conf` configuration file. e.g.

        root@puppetcom /]# cat /etc/puppet/autosign.conf 
        *.dev
        puppetclient1.test

#### Puppet Runner/Kicker

The `puppetrun`/`puppet kick` command allows the `puppetmaster` server to 
trigger a reread of a host's configuration, updating any changes that 
may have occurred. Some additional configuration is required to setup 
the `puppet kick` command and is outlined below. 

On the client add the following configuration to the start of the 
`/etc/puppet/auth.conf` configuration file (assuming we are allowing 
`puppetcom.dev` the ability to `kick` the server):

        path /
        allow puppetcom.dev
        auth yes

Note, older versions required editing the `/etc/puppet/namespaceauth.conf` file, 
but this does not seem to be required in newer versions of puppet.

Also, the `listen` attributed must be turned on in the `/etc/puppet/puppet.conf` 
configuration file. e.g.

        [puppetd]
        listen = true

#### Disabling Automatic Updates

By default, the puppet client daemon (`puppetd`) will periodically check for 
configuration changes. This is not recommended with the Harbour MSP production 
environment and will be required to be turned off. To disable this feature the 
following configuration option needs to be added to puppet client `init.d` 
configuration file `/etc/sysconfig/puppet`

        # davek, disable automatic updates
        PUPPET_EXTRA_OPTS=--no-client


## Setting up Kickstart ##

### DHCP ###

- DHCP is used to assign an IP address to a host during the kickstart process.
- To configure DHCP:

1.  Edit the `/etc/dhcp/dhcpd.conf` file and add the appropriate entries 
(see the Appendix for an example configuration).

2.  Restart `dhcpd`

        /etc/init.d/dhcpd restart

3.  Ensure `dhcpd` is started at boot:

        chkconfig dhcpd on

### TFTP ###

- TFTP is used by kickstart to download both the PXE `bootloader` and the necessary 
linux ram-disks and kernel images.
- To configure TFTP:

1.  Create the following directory structures, all with `755` permissions:

        # mkdir –p /tftpboot/pxelinux.cfg
        # chmod –R 755 /tftpboot

2.  Download version 3.55 of the `syslinux` distribution from 
[http://www.kernel.org/pub/linux/utils/boot/syslinux/](http://www.kernel.org/pub/linux/utils/boot/syslinux/) 
and extract the `pxelinux.0` to the `/tftpboot` directory. i.e.

        # tar -xzvf syslinux-4.04.tar.gz 
        # cd syslinux-4.04
        # cp core/pxelinux.0 /tftpboot/
        # chmod 755 /tftpboot/pxelinux.0

3.  Ensure the `tftp` configuration points to the `tftpboot` directory:

        # cat /etc/xinetd.d/tftp |grep server_args
          server_args    = -s /tftpboot

3.  Install `tftp` and ensure that the `disable=yes` has been removed from the 
`/etc/xinetd.d/tftp` configuration file and restart the `xinetd` daemon.

        # /etc/init.d/xinetd restart

4.  Ensure `xinetd` is started at boot:

        # chkconfig xinetd on

### NFS ###

- NFS can be used by kickstart to obtain OS rpm's during installation.
- To configure:

1.  Create the following directory layout:

        # mkdir -p /kickstart/cfg
        # mkdir -p /kickstart/install

2.  Add the following entry to `/etc/exports`:

        /kickstart      *(ro)

3.  Restart the nfs daemon:

        /etc/init.d/nfs restart

4.  Verify the “/kickstart” directory is being shared:

        # showmount -e localhost
        Export list for localhost:
        /kickstart *

5.  Ensure `rpcbind` and `nfs` are started

        # /etc/init.d/rpcbind start
        # /etc/init.d/nfs start

5.  Ensure NFS is being started at boot:

        # chkconfig rpcbind on
        # chkconfig nfs on


### Kickstart Images ###

- The following section lists the required steps to begin serving Kickstart images. 
- Note, this process can be controlled via the `foreman-proxy`.

1.  Decide on a naming convention, the following naming convention is used by `foreman-proxy`:

        <os><release>_<arch>-[vmlinuz|initrd.img]
        centos-6.2-x86_64-vmlinuz
        centos-6.2-x86_64-initrd.img

1.  Create the image directory:

        /tftpboot/boot

2.  Copy both the `initrd.img` and `vmlinuz` from the particular distribution to the image directory. e.g.

        # mount -o loop /mnt/iso/CentOS-6.2-x86_64-bin-DVD1.iso /mnt/centos62
        # cd /mnt/centos62
        # cp images/pxeboot/initrd.img /tftpboot/boot/centos-6.2-x86_64-initrd.img
        # cp images/pxeboot/vmlinuz /tftpboot/centos-6.2-x86_64-vmlinuz

3.  Link the distribution to the `install` directory. e.g.

      # mount -o loop /mnt/iso/CentOS-6.2-x86_64-bin-DVD1.iso /mnt/centos62
      # ln -s /mnt/centos62 /kickstart/install/centos-6.2-x86_64


## Appendix 1 - Compiling from Source

### Foreman from Source

1.  Rename the existing `foreman` ruby infrastructure directory:

        # cd /usr/share
        # mv foreman foreman.old

2.  Clone the HMSP `foreman` fork:

        # git clone https://davek@github.com/davek/foreman.git

3.  Install foreman from the fork:

        # cd /usr/share/foreman
        # bundle install

4. Symlink the existing configuration to the new fork:

        # ln -s /etc/foreman/database.yml database.yml
        # ln -s /etc/foreman/email.yaml email.yaml
        # ln -s /etc/foreman/settings.yaml settings.yaml

5. Modify the `/etc/init.d/foreman` that was installed with the foreman rpm to 
use the `rails` script instead of the `server` script.

        daemon --user ${FOREMAN_USER} cd ${FOREMAN_HOME}; \ 
        ${FOREMAN_HOME}/script/rails server -p ${FOREMAN_PORT} -e \ 
        ${FOREMAN_ENV} -c ${FOREMAN_CONFIG} -d -P ${FOREMAN_PID} > /dev/null

### Foreman Proxy from Source

1.  Rename the existing `foreman-proxy` directory

        # cd /usr/share
        mv foreman-proxy foreman-proxy.old

2.  Clone the HMSP `foreman-proxy` fork:

        # git clone https://davek@github.com/davek/smart-proxy.git

3. Symlink the existing configuration to the new fork:

        # cd /usr/share/foreman-proxy/config
        # ln -s /etc/foreamn-proxy/settings.yml settings.yml

## Appendix 2 - Foreman Configuration

### `/etc/foreman/settings.yml`

        --- 
        :modulepath: /etc/puppet/modules/
        :tftppath: /tftpboot/
        :unattended: true


### `/etc/foreman-proxy/settings.yml`

        ---
        :daemon: true
        :daemon_pid: /var/run/foreman-proxy/foreman-proxy.pid
        :port: 8443
        :tftp: true
        :tftproot: /tftpboot
        :tftp_servername: 172.17.12.221
        :dns: false
        :dhcp: true
        :dhcp_vendor: isc
        :dhcp_config: /etc/dhcp/dhcpd.conf
        :dhcp_leases: /var/lib/dhcpd/dhcpd.leases
        :puppetca: true
        :puppet: true
        :log_file: /tmp/proxy.log
        :log_level: DEBUG


## Appendix 3 - Kickstart Configuration

### `/etc/dhcp/dhcpd.conf`

- Note, the `omapi-port` must be specified otherwise the `foreman-proxy` wont be 
able to configure dhcp.

        omapi-port 7911; 

        subnet 172.17.12.0 netmask 255.255.255.0 {
          option broadcast-address 172.17.12.255;
          option routers 172.17.12.254;
          option domain-name "dev";
          option domain-name-servers 172.17.12.205;
          next-server 172.17.12.221;
          filename "pxelinux.0";
        }

### Sample (expanded) Kickstart Configuration

        #
        # Default CentOS 6.2 Kickstart Configuration File for HMSP
        # author: davek
        #
        
        #
        # basic settings
        #
        install
        lang en_US
        keyboard us
        skipx
        text
        reboot
        
        #
        # location of the nfs/kickstart server
        #
        url --url http://172.17.12.221/install/centos-6.2-x86_64
        
        #
        # the default root password, refer to the password database for un-encrypted contents
        #
        rootpw --iscrypted $6$ruyiAJ82a/9Bazd7$zspMbTz4e7omVlb12uTa.bjuvc8SuxcGoVHgJv3Y3r1m/4.7tONDUzPVpJpYWA85uXjrzv.dnIixjkc2J.pye.
        
        #
        # basic system settings
        #
        firewall --disabled
        selinux --disabled
        authconfig --enableshadow --enablemd5
        timezone --utc Australia/Sydney
        
        #
        # bootloader stuff
        #
        bootloader --location=mbr
        
        #
        # disk stuff
        #
        zerombr yes
        clearpart --all --initlabel
        part /boot --fstype ext3 --size=100 --asprimary
        part /     --fstype ext3 --size=1024 --grow
        part swap  --recommended
        
        #
        # minimal package lists
        #
        %packages
        @ base
        -iptables
        ntp
        vim-enhanced
        screen
        perl-libwww-perl
        
        # post install chroot
        #
        %post --log=/root/kickstart-post.log
        
        ## TODO REMOVE
        # hack to get yum working on the dev network
        echo "proxy=http://172.17.12.205:8080" >> /etc/yum.conf

	      # update packages
	      yum -t -y -e 0 update

        echo "Adding epel repo..."
        cat > /etc/yum.repos.d/hmsp-centos-epel.repo << EOF
        [hmsp-centos-epel-\$basearch]
        name = HMSP Centos EPEL \$releasever - \$basearch
        baseurl=http://repo/centos/\$releasever/epel/\$basearch
        enabled=1
        gpgcheck=0
        
        [hmsp-centos-epel-noarch]
        name = HMSP Centos EPEL \$releasever - noarch
        baseurl=http://repo/centos/\$releasever/epel/noarch
        enabled=1
        gpgcheck=0
        EOF
        
        echo "Installing puppet..."
        # and add the puppet and ruby-shadow package
        yum -t -y -e 0 install puppet
        
        echo "Configuring puppet..."
        cat > /etc/puppet/puppet.conf << EOF
        [main]
        vardir = /var/lib/puppet
        logdir = /var/log/puppet
        rundir = /var/run/puppet
        ssldir = \$vardir/ssl
        pluginsource = puppet://\$server/plugins
        environments = production
        
        [puppetd]
        factsync = true
        report = true
        ignoreschedules = true
        daemon = true
        certname = puppetclient1.dev
        environment = production
        server = puppetcom.dev
        EOF
        
        # Setup puppet to run on system reboot
        /sbin/chkconfig --level 345 puppet on
        
        # Disable most things. Puppet will activate these if required.
        echo "Disabling various system services..."
        /sbin/chkconfig --level 345 autofs off 2>/dev/null
        /sbin/chkconfig --level 345 gpm off 2>/dev/null
        /sbin/chkconfig --level 345 sendmail off 2>/dev/null
        /sbin/chkconfig --level 345 cups off 2>/dev/null
        /sbin/chkconfig --level 345 iptables off 2>/dev/null
        /sbin/chkconfig --level 345 ip6tables off 2>/dev/null
        /sbin/chkconfig --level 345 auditd off 2>/dev/null
        /sbin/chkconfig --level 345 arptables_jf off 2>/dev/null
        /sbin/chkconfig --level 345 xfs off 2>/dev/null
        /sbin/chkconfig --level 345 pcmcia off 2>/dev/null
        /sbin/chkconfig --level 345 isdn off 2>/dev/null
        /sbin/chkconfig --level 345 rawdevices off 2>/dev/null
        /sbin/chkconfig --level 345 hpoj off 2>/dev/null
        /sbin/chkconfig --level 345 bluetooth off 2>/dev/null
        /sbin/chkconfig --level 345 openibd off 2>/dev/null
        /sbin/chkconfig --level 345 avahi-daemon off 2>/dev/null
        /sbin/chkconfig --level 345 avahi-dnsconfd off 2>/dev/null
        /sbin/chkconfig --level 345 hidd off 2>/dev/null
        /sbin/chkconfig --level 345 hplip off 2>/dev/null
        /sbin/chkconfig --level 345 pcscd off 2>/dev/null
        /sbin/chkconfig --level 345 restorecond off 2>/dev/null
        /sbin/chkconfig --level 345 mcstrans off 2>/dev/null
        /sbin/chkconfig --level 345 rhnsd off 2>/dev/null
        /sbin/chkconfig --level 345 yum-updatesd off 2>/dev/null
        
        echo "Starting puppet..."
        /usr/sbin/puppetd --config /etc/puppet/puppet.conf -o --tags no_such_tag --server puppetcom.dev  --no-daemonize
        sync
        
        echo "Informing Foreman that we are built.."
        wget -q -O /dev/null --no-check-certificate http://puppetcom.dev:3000/unattended/built

## Appendix 4 - Foreman Templates

### `Kickstart default PXElinux`

- The pxelinux information used during the tftpboot process.

        default linux
        label linux
        kernel <%= @kernel %>
        append initrd=<%= @initrd %> ks=<%= foreman_url("provision")%> ksdevice=bootif network kssendmac

### `epel.repo`

- A snippet called `epel.repo` defines a local repository for epel packages.

        [hmsp-centos-epel-\$basearch]
        name = HMSP Centos EPEL \$releasever - \$basearch
        baseurl=http://repo/centos/\$releasever/epel/\$basearch
        enabled=1
        gpgcheck=0

        [hmsp-centos-epel-noarch]
        name = HMSP Centos EPEL \$releasever - noarch
        baseurl=http://repo/centos/\$releasever/epel/noarch
        enabled=1
        gpgcheck=0

### `puppet.conf`

- A snippet called `puppet.conf` defines generic puppet configuration information.

        [main]
        vardir = /var/lib/puppet
        logdir = /var/log/puppet
        rundir = /var/run/puppet
        ssldir = \$vardir/ssl
        pluginsource = puppet://\$server/plugins
        environments = <%= @host.environment %>

        [puppetd]
        factsync = true
        report = true
        ignoreschedules = true
        daemon = false
        certname = <%= @host.name %>
        environment = <%= @host.environment %>
        server = <%= @host.puppetmaster %>

### `CentOS Kickstart Default`

- A provisioning template defining a default CentOS Kickstart configuration file.

        #
        # Default CentOS 6.2 Kickstart Configuration File for HMSP
        # author: davek
        #
        
        #
        # basic settings
        #
        install
        lang en_US
        keyboard us
        skipx
        text
        reboot
        
        #
        # location of the nfs/kickstart server
        #
        url --url http://172.17.12.221/install/centos-6.2-x86_64
        
        #
        # the default root password, refer to the password database for un-encrypted contents
        #
        rootpw --iscrypted $6$ruyiAJ82a/9Bazd7$zspMbTz4e7omVlb12uTa.bjuvc8SuxcGoVHgJv3Y3r1m/4.7tONDUzPVpJpYWA85uXjrzv.dnIixjkc2J.pye.
        
        #
        # basic system settings
        #
        firewall --disabled
        selinux --disabled
        authconfig --enableshadow --enablemd5
        timezone --utc Australia/Sydney
        
        #
        # bootloader stuff
        #
        bootloader --location=mbr
        
        #
        # disk stuff
        #
        <%= @host.diskLayout %>
        
        #
        # minimal package lists
        #
        %packages
        @ base
        -iptables
        ntp
        vim-enhanced
        screen
        perl-libwww-perl
        
        # post install chroot
        #
        %post --log=/root/kickstart-post.log
        
        # TODO REMOVE
        # hack to get yum working on the dev network
        echo "proxy=http://172.17.12.205:8080" >> /etc/yum.conf
        
        # update packages
        yum -t -y -e 0 update
        
        echo "Adding epel repo..."
        cat > /etc/yum.repos.d/hmsp-centos-epel.repo << EOF
        <%= snippets "epel.repo" -%>	
        EOF
        
        echo "Installing puppet..."
        # and add the puppet and ruby-shadow package
        yum -t -y -e 0 install puppet
        
        echo "Configuring puppet..."
        cat > /etc/puppet/puppet.conf << EOF
        <%= snippets "puppet.conf" -%>
        EOF
        
        # Setup puppet to run on system reboot
        /sbin/chkconfig --level 345 puppet on
        
        # Disable most things. Puppet will activate these if required.
        echo "Disabling various system services..."
        <% %w{autofs gpm sendmail cups iptables ip6tables auditd arptables_jf xfs pcmcia isdn rawdevices hpoj bluetooth openibd avahi-daemon avahi-dnsconfd hidd  hplip pcscd restorecond mcstrans rhnsd yum-updatesd}.each do |service| -%>
          /sbin/chkconfig --level 345 <%= service %> off 2>/dev/null
        <% end -%>
                
        echo "Starting puppet..."
        /usr/sbin/puppetd --config /etc/puppet/puppet.conf -o --tags no_such_tag --server <%= @host.puppetmaster %>  --no-daemonize
        sync
        
        echo "Informing Foreman that we are built.."
        wget -q -O /dev/null --no-check-certificate wget -q -O /dev/null --no-check-certificate <%= foreman_url %>
        
        
        exit 0



