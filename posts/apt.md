Categories: linux
Tags: linux
      debian
      apt


# Operations

## Importing Keys ##

      wget -q 'http://repo/keys/percona.gpg' -O- | apt-key add -

## Add package ##

      # apt-get install <package>

## Remove Package ##

      # apt-get remove <package>

- To remove all modified files (e.g. config info)

      # apt-get remove --purge <package>


## Upgrading Packages

- To upgrade packages:

            apt-get -u upgrade

- To upgrade all packages, even system packages (e.g. if you get a message saying `The following packages have been kept back` using the last step):

            apt-get -u dist-upgrade

## Refresh cache

    # apt-get update

# Information


## List installed packages ##

      # dpkg --get-selections
      # dpkg --list

## List information about installed package

      # dpkg -s <installed-package>

## List the files contained within an installed package ##

      # dpkg --listfiles <installed-package>

## Update local cache ##

      # apt-get update

## Search for a package ##

      # apt-cache search <package>

## View all versions available for a package

      # apt-cache madison <package>

## View information about all packages available

      # apt-cache show <package>

## Contents of package

      # dpkg -L <package_name>
      # dpkg -c <package_name.deb>

## Which package owns file

      # dpkg -S /bin/ls

# Downloading

## Download (allready installed) package

      # apt-get -d -o=dir::cache=/tmp install <package> --reinstall

## Download (not installed) package

      # apt-get -d -o=dir::cache=/tmp install <package>



# Locations 

## The location of preinstall,postinstall etc scripts

      /var/lib/dpkg/info/

# The location of packages installed/updated

      /var/cache/apt/archives

# Troubleshooting 


## `Problem with MergeList`

- Remove the files in `/var/lib/apt/lists` (making sure not to remove the directory `/var/lib/apt/lists/partial`).

## `Dynamic MMap ran out of room`

- Edit/create a file called `/etc/apt/apt.conf` with the following line:

        APT::Cache-Limit "50000000";
