Categories: solaris
Tags: jumpstart
      nfs

# Solaris Jumpstart

## Installing SPARC OS on x86 Jumpstart Server

* Because you cant mount a SPARC formatted CD on an x86 box, you need to

### On SPARC

* Mount SPARC Sol CD1

* Create some dfstab entries:

          cat /etc/dfs/dfstab
          share -F nfs -o ro,anon=0 /cdrom/sol_9_1203_sparc/s0/
          share -F nfs -o ro,anon=0 /cdrom/sol_9_1203_sparc/s1/

* Start the nfs server:

          /etc/init.d/nfs.server start


### On x86

* Mount nfs partitions:

          mkdir /s0
          mkdir /s1
          mount 172.16.1.11:/cdrom/sol_9_1203_sparc/s0 /s0
          mount 172.16.1.11:/cdrom/sol_9_1203_sparc/s1 /s1

* Run the Jumpstart install scripts:

          cd /s0/Solaris_9/Tools
          ./setup_install_server -t /s1 /jumpstart/install/s9s_1203/

where:

    -t location of the boot image
    /jumpstart/install/s9s_1203/ (i.e. Where the image is installed locally).

* Remove nfs stuff
* Mount 2nd cd on x86 and run the `add_to_..` script

          mount -F hsfs /dev/dsk/c0t0d0s0 /mnt
          cd /mnt/Solaris_9/Tools/
          ./add_to_install_server


## Configuring Jumpstart Client

- boot server 
  - Provides boot image, OS to jumpstart client
- configuration server 
  - Helps client determine profile
  - Provides partition sizes, software to install, begin/finish scripts etc
- install server 
  - Source of software packages to install on client

### Process

* Modify /etc/ethers with the hardware address / hostname of the server you wish to jumpstart

          bash-2.05$ cat /etc/ethers | grep web01
          8:0:20:fc:c1:59 web01

* Modify /etc/hosts with the ip address / hostname of the server you wish to jumpstart

          bash-2.05$ cat /etc/hosts |grep web01
          203.221.114.110 web01


* Configure the sysidcfg file (this file specifies the system locale, time zone, netmask, IPv6 on / off terminal type, security policy, name service time server). 
  - This file is OS dependant and enables a fully automated software installation. e.g.

              bash-2.05$ ls /jumpstart/Sysidcfg/Solaris_8
              sysidcfg

* Configure the boot server using the `add_install_client`, which will: 
  - start any services not already started that the boot server needs to function 
  - e.g. tftp, rard, nfs etc
  - cd to the `software_version/Tools` that you wish to install :

            bash-2.05$ pwd
            /jumpstart/OS/Solaris_8.0_07-03/Solaris_8/Tools

  - run the `add_install_client` for the jumpstart client:

            ./add_install_client -p <jumpstart_server>:<path_to_sysidcfg> <jumpstart_client> <arch>

  - where:

            <jumpstart_server>  Hostname of jumpstart boot server
            <path_to_sysidcfg>  The directory where the sysidcfg file is located
            <jumpstart_client>  Hostname of the jumpstart client
            <arch>          Architecture e.g. sun4u

* Configure the profile 
  - Specifies how OE system installed and configured.
  - e.g. `/jumpstart/Profiles`
  - Profiles are OS dependant.

* Modify the rules file 
  - Specifies how jumpstart client built without interactive responses.
  - Syntax:

              hostname  <hostname>  <begin> <profile> <finish>

  - where:

              hostname    Keyword, indicates the type of rule
              <hostname>  Name of the jumpstart client
              <begin>     Name of the script executed before OE installed
              <profile>   The JumpStart profile
              <finish>    Name of script executed after the OE install

  - e.g.

              bash-2.05$ cat /jumpstart/rules | grep web01
              hostname        web01   -       Profiles/secure_9.profile Drivers/secure.driver

  - Note, directories specified in the rules file are relative to the `/jumpstart` directory


* Validate modifications 
  - There is a check script located in the /jumpstart directory that is used to validate/check rules file, profile configuration files, scripts etc 
  - It generates a rules.ok file, which is used by the jumpstart server to install the OS

              bash-2.05$ pwd
              /jumpstart
              bash-2.05$ ./check

* Boot the client into the ok prompt and run
  - From the `ok` prompt:

              ok> boot net - install

  - From the system prompt:


              # reboot -- "net - install"


