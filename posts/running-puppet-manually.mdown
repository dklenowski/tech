Categories: puppet
Tags: linux
      puppet

    puppet apply --modulepath="/etc/puppet/modules/shared:/etc/puppet/modules/ecg:/etc/puppet/modules/users:/etc/puppet/modules/au/platform:/etc/puppet/modules/private:/etc/puppet/modules/au/configs:/etc/puppet/hiera"  --verbose --debug --noop /etc/puppet/manifests/site.pp
