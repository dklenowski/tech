Categories: server management
Tags: puppet
      style

# Puppet Stuff

## Language

### Debugging 

#### Send debug messages to the puppetmaster log file

        debug('msg')
        info('msg')
        warning('msg')
        crit('msg')
        ...

#### Display debug message on puppet  client

        notify { 'Message': }


### Variables

#### Fully Qualified Variables

- Explicitly qualify variables including top level variables

        $puppet_environment = $::environment

### Types

#### resources

- e.g. to delete any resources that is not specifed in the configuration and is not autorequired by any managed resources.

        resources { [
            'libvirt_domain',
            'libvirt_pool',
        ]:
            purge => true,
        }

- The example above will delete any the `libvirt_domain` and `libvirt_pool` class if they are not required.


### Classes

        class base (
          $puppet_environment = $::environment,
          $puppet_daemon      = true,
          ..
        ) {


#### Including Classes

##### Using resource like declarations

        class {
          'apache':;
        }

- Notes:
  - Multiple declaractions prohibited.
  - Paramters can be overwridden at compile time.


##### Using `include`

        include base_linux, apache

- Notes:
  - Multiple declarations OK
  - Relies on external data for parameters


### Conditional Statements

#### conditionals

     case $type {
       'interactive': { 
         # do something
       }

       default: {
       }
     }

#### if/else

      if $::companyenv != 'qa' {
        ...
      } else {
        ...
      }

      if $collectdenabled {

      }


      $arch = $::architecture ? { 'amd64' => 'x86_64', default => $::architecture }


## Pragma's

### File

#### Referencing a static file

        file {
          '/opt/test/template.txt':
            ensure  => present,
            source  => "puppet:///modules/${module_name}/opt/test/template.txt",
            mode    => '0664',
            owner   => 'root',
            group   => 'root',
            mode    => '0644';
         }

#### Referencing a template

        file {
          '/etc/motd':
            ensure  => present,
            content => template("${module_name}/etc/motd.erb"),
            backup  => false,
            owner   => 'root',
            group   => 'root',
            mode    => '0644';
        }

#### Creating a directory

        file { '/media/home':
          ensure  => directory,
          owner   => 'root',
          group   => 'root',
          replace => false,
          mode    => '0755';
        }

#### Creating a symlink

        file { '/etc/link':
          ensure => link,
          target => '/etc/dir/link'
        }


### Pragma Shortcuts

#### With Classes

        class {
          'base_system':
            hostgroup => $module_name;
          'elasticsearch':
            ensure      => present,
            autoupgrade => false;
          'redis':;
          'logstash':
            ensure => present,
            status => enabled
        }

        Class['redis'] -> Class['elasticsearch'] -> Class['logstash']

#### With files

        File {
          owner  => 'elasticsearch',
          group  => 'elasticsearch',
          mode   => '0755';  
        }

        file {
            '/opt/elasticsearch':
              ensure => directory,
            '/opt/elasticsearch/data':
              ensure => directory,
          }

- The above can also be written:

        file { ['/opt/elasticsearch','/opt/elasticsearch/data']:
            ensure => directory
        }


#### With packages

      package {
        [ 'krb5-user', 'krb5-config' ]:
          ensure => installed;
      }        

# ERB Files

- Prefix facter variables with a `@` (i.e puppet variables), while other variables (e.g. variable definitions in class files) without a `@` (i.e. ruby variables).

## Conditional Statements

### `if-else`

        <% if squid_mode == 'transparent' -%>
        http_port <%= squid_ip %>:<%= squid_port %> transparent
        <% else -%>
        http_port <%= squid_ip %>:<%= squid_port %>
        <% end -%>
        tcp_outgoing_address <%= squid_ip %>        
   
        <% if defined? @apache_ldap_group -%>
        Require ldap-group <%= @apache_ldap_group %>
        AuthLDAPGroupAttributeIsDN on
        AuthLDAPGroupAttribute member
        <% end -%>


        <% if max_heap_size -%>
        MAX_HEAP_SIZE="<%= max_heap_size %>"
        HEAP_NEWSIZE="<%= max_newsize %>"
        <% end -%>

### `for`

        <% dbmasters.each do |val| -%>
        [ <%= val.split(':')[0] %>.com.au ]
        port = 3306
        ip = <%= val.split(':')[1] %>
        candidate_master = 1
        <% end -%>

## Ruby Methods

- You can use ruby methods inside an erb:

        VARNISH_PARAMETERS="-p thread_pool_add_delay=2 -p \ 
        thread_pools=<%= processorcount %> \
        -p thread_pool_min=<%= 800 / processorcount.to_i %> \
        -p thread_pool_max=4000"


## Referencing puppet functions


        <% if scope.function_versioncmp([@mysql_major_version,'5.1'])

        <% if scope.function_versioncmp([scope.lookupvar('serverversion'),'2.0']) <= 0 -%>
        templatedir=$confdir/templates
        <% end -%>

## Referencing facts

      <% if companyenv == 'qa' -%>
       

## Referencing global variables

      <% c = scope.lookupvar('search::solr_cores') -%>
      export VALID_CORES="<%= c.join ' ' -%>"


## Puppet Providers

### Debugging

         Puppet.warning "a warning message with a var " + var


