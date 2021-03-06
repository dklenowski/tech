Categories: solaris
Tags: zfs

## Increasing ZFS Swapspace ##

Ref: [http://www.gaeltd.com/growing-swap-on-a-zfs-filesystem/](http://www.gaeltd.com/growing-swap-on-a-zfs-filesystem/)

- Record the block size for later use:

        bash-3.00# swap -l
        swapfile             dev  swaplo blocks   free
        /dev/zvol/dsk/rpool/swap 256,1      16 4194288 4194288

- Increase the size of the ZFS swap partition:

        bash-3.00# zfs list
        NAME                        USED  AVAIL  REFER  MOUNTPOINT
        rpool                      12.6G  54.4G    97K  /rpool
        rpool/ROOT                 4.39G  54.4G    21K  legacy
        rpool/ROOT/s10s_u8wos_08a  4.39G  54.4G  4.39G  /
        rpool/dump                 1.50G  54.4G  1.50G  -
        rpool/export               4.66G  54.4G  4.66G  /export
        rpool/export/home          1.69M  54.4G  1.69M  /export/home
        rpool/swap                    2G  56.4G    16K  -
        u01                          76K  66.9G    25K  /u01

        bash-3.00# zfs set volsize=8G rpool/swap

        bash-3.00# zfs list
        NAME                        USED  AVAIL  REFER  MOUNTPOINT
        rpool                      18.6G  48.4G    97K  /rpool
        rpool/ROOT                 4.39G  48.4G    21K  legacy
        rpool/ROOT/s10s_u8wos_08a  4.39G  48.4G  4.39G  /
        rpool/dump                 1.50G  48.4G  1.50G  -
        rpool/export               4.66G  48.4G  4.66G  /export
        rpool/export/home          1.69M  48.4G  1.69M  /export/home
        rpool/swap                    8G  56.4G    16K  -
        u01                          76K  66.9G    25K  /u01


- Increase the swap space (use the block's count in the first step)

        bash-3.00# export NOINUSE_CHECK=1d
        bash-3.00# swap -a /dev/zvol/dsk/rpool/swap $((8+4194288))

- Check the swap space was enabled

        bash-3.00# swap -l
        swapfile             dev  swaplo blocks   free
        /dev/zvol/dsk/rpool/swap 256,1      16 4194288 4194288
        /dev/zvol/dsk/rpool/swap 256,1  4194304 12582912 12582912