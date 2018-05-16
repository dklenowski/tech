Categories: linux
Tags: debian
      upgrade
      squeeze
      wheezy


## Upgrading from Debian Squeeze to Wheezy


        puppetd --disable
        
        cp /etc/puppet/puppet.conf ~/
        
        apt-get purge mcollective mcollective-common facter puppet puppet-common
        rm -rf /etc/mcollective /usr/share/mcollective
        
        apt-get autoremove -y </dev/null
        
        sed -i 's/squeeze/wheezy/g' /etc/apt/sources.list.d/*

        apt-get update </dev/null
        
        export DEBIAN_FRONTEND=noninteractive
        yes N | apt-get dist-upgrade -y
        
        reboot
        
        apt-get install puppet=2.7.20-2puppetlabs1 puppet-common=2.7.20-2puppetlabs1 facter=1.7.2-1puppetlabs1
        cp ~/puppet.conf /etc/puppet/
        puppetd -t



