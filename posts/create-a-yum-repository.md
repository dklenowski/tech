Categories: linux
            redhat
Tags: linux
      redhat
      yum

### Install the `createrepo` rpm.

        # yum install createrepo

### Create the repository metadata

        # createrepo /export/repo/centos5.2-x86_64/
        ...
        Saving Primary metadata
        Saving file lists metadata
        Saving other metadata

### Install httpd (if not allready installed)

        # yum install httpd

### Create symlinks

        # ln -s /export/httpRoot/ /var/www/mrepo

### Create a `httpd` entry pointing to the yum repository

- e.g. `/etc/httpd/conf.d/mrepo.conf`

        Alias /mrepo /var/www/mrepo
        
        <Directory /var/www/mrepo>
                Options Indexes FollowSymlinks SymLinksifOwnerMatch IncludesNOEXEC
                IndexOptions NameWidth=* DescriptionWidth=*
        </Directory>
        
        <VirtualHost *:80>
                ServerName einstein.orbious.com
                ServerAlias mrepo.orbious.com
                DocumentRoot /var/www/mrepo
                ErrorLog logs/mrepo-error_log
                CustomLog logs/mrepo-access_log combined
        </VirtualHost>

