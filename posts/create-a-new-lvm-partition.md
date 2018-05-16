Categories: linux
Tags: linux
      lvm
      disk


## Create a partition

- Convention usually is to create an LVM partition (rather than use the whole disk).

        # fdisk /dev/sdb

## Create physical volume

        # pvcreate /dev/sdb1

## Create Volume Group

- The following command creates a volume group called `vg01`

        # vgcreate vg01 /dev/sdb1

## Create Logical Volume

- The following command creates a logical volume called `images` using `100%` of available space on the Volume Group {{vg01}}

        # lvcreate -n images -l 100%FREE vg01

## Format partition

- e.g.

        # mkfs.xfs /dev/vg01/images

## And mount

- Sample `/etc/fstab` show below:

        root@qa1:/etc# cat /etc/fstab |grep vg01 
        /dev/vg01/images /var/lib/libvirt/images xfs     rw     0       2