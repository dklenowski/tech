Categories: solaris
Tags: zfs
      zpool

## Intro ##

Good cheatsheet found at [http://lildude.co.uk/zfs-cheatsheet](http://lildude.co.uk/zfs-cheatsheet)

### Recovery ###

      # boot cdrom -s
      # zpool import -R /mnt rpool


### Commands ###

#### Mounting/Unmounting ####

      
      # zfs list
      NAME   USED  AVAIL  REFER  MOUNTPOINT
      data  46.8G  87.0G  46.8G  /data
      # zfs mount data
      # zfs unmount data

#### Creating a mirror ####

      # zpool create data mirror c0t2d0 c0t3d0 
      #
      # zpool list
      NAME   SIZE   USED  AVAIL    CAP  HEALTH  ALTROOT
      data    68G    94K  68.0G     0%  ONLINE  -
      bash-3.00# zpool status
        pool: data
       state: ONLINE
       scrub: none requested
      config:
      
              NAME        STATE     READ WRITE CKSUM
              data        ONLINE       0     0     0
                mirror    ONLINE       0     0     0
                  c0t2d0  ONLINE       0     0     0
                  c0t3d0  ONLINE       0     0     0
      
      errors: No known data errors
      
      # df -h |grep data
      data                    67G     1K    67G     1%    /data



#### Creating a concatenation ####

      # zpool create -f data c0t2d0 c0t3d0
      #
      # zpool status
        pool: data
       state: ONLINE
       scrub: none requested
      config:
      
              NAME        STATE     READ WRITE CKSUM
              data        ONLINE       0     0     0
                c0t2d0    ONLINE       0     0     0
                c0t3d0    ONLINE       0     0     0

      # df -h |grep data
      data                   134G     1K   134G     1%    /data
          

### Mirror Root ###

- Mirror existing root `c1t0d0s0` with `c1t1d0s0`

        # prtvtoc /dev/rdsk/c1t0d0s0 | fmthard -s - /dev/rdsk/c1t1d0s0
        # zpool attach -f rpool c1t0d0s0 c1t1d0s0

- To check status (where `resilver` is the process of resyncing/rebuilding the mirror).

        # zpool status
          pool: rpool
         state: ONLINE
         scrub: resilver completed after 0h7m with 0 errors on Tue Mar  1 11:40:43 2011
        config:
        
                NAME          STATE     READ WRITE CKSUM
                rpool         ONLINE       0     0     0
                  mirror      ONLINE       0     0     0
                    c1t0d0s0  ONLINE       0     0     0
                    c1t1d0s0  ONLINE       0     0     0  6.12G resilvered



- Install the boot block:

        sparc# installboot -F zfs /usr/platform/`uname -i`/lib/fs/zfs/bootblk /dev/rdsk/c1t1d0s0
        x86# installgrub /boot/grub/stage1 /boot/grub/stage2 /dev/rdsk/c1t1d0s2 

- If the root disk does die, you will still need to modify the `boot-device` in the firmware to successfully boot:
  - e.g. from http://www.solarisinternals.com/wiki/index.php/ZFS_Troubleshooting_Guide
  
            ok setenv boot-device /pci@7c0/pci@0/pci@1/pci@0,2/LSILogic,sas@2/disk@1
            ok boot


