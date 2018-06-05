Categories: puppet
Tags: hiera
      puppet

### Puppet (`pp`) File

    package {
      [ hiera_array('packages') ]: ensure => installed;
      [ hiera_array('packages_absent') ]: ensure => absent;
    }

### Hiera (`yaml`) File

    packages_absent:
      - libsane-common
      - libtokyocabinet9:amd64
      - libtokyotyrant3



