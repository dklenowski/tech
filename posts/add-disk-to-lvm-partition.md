Categories: linux
Tags: linux
      lvm
      disk

- Add a LVM Partition

        # fdisk /dev/sdc

- Create physical volume

        # pvcreate /dev/sdc1

- Add the disk to the VG

        #  vgextend vg /dev/sdc1

- Increase size of LV

        #  lvextend -L+284GB /dev/pv/mysql

- Resize partition

        # xfs_growfs /dev/mapper/pv-mysql
