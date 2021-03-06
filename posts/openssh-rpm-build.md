Categories: linux
            redhat
Tags: linux
      redhat
      openssh
      ssh

## If not allready, install the `rpm` build stuff ##

      yum install -y rpm-build

## Install packages necessary for building `openssh`

      yum install -y gcc
      yum install -y openssl-devel
      yum install -y pam-devel

## Download openssh sources ##

      wget http://mirror.aarnet.edu.au/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz
      wget http://mirror.aarnet.edu.au/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz.asc
      
      wget http://mirror.aarnet.edu.au/pub/OpenBSD/OpenSSH/portable/DJM-GPG-KEY.asc
      gpg --import DJM-GPG-KEY.asc
      gpg openssh-5.9p1.tar.gz.asc

## Copy info to redhat build tree

      cp openssh-5.9p1.tar.gz /usr/src/redhat/SOURCES/
      tar -xzvf openssh-5.9p1.tar.gz
      cp openssh-5.9p1/contrib/redhat/openssh.spec /usr/src/redhat/SPECS/

## Remove the X11 and Gnome stuff (since we are building for a server) from the spec file ##

      vi /usr/src/redhat/SPECS/openssh.spec
      %define no_x11_askpass 0
      %define no_gnome_askpass 0

## Build the package ##

      rpmbuild -bb /usr/src/redhat/SPECS/openssh.spec

