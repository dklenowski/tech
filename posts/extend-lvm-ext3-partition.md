Categories: linux
Tags: linux
      lvm
      disk
      extend
      ext3

## Extending an ext3 Logical Volume

1. Ensure the PV has enough space: 

        # pvdisplay

2. Unmount filesystem 

        # umount /dev/vg00/lv00

3. Remove the filesystem journal 

        # tune2fs -O^has_journal /dev/vg00/lv00

4. Increase the size of the Logical Volume 

        # lvextend -L +20G /dev/vg00/lv00

5. Check the filesystem 

        # e2fsck -f /dev/vg00/lv00

6. Increase the size of the filesystem 

        # resize2fs /dev/vg00/lv00 30G

7. Create the filesystem journal 

        # tune2fs -O has_journal /dev/vg00/lv00

8. Run a final check on the filesystem 

        # e2fsck -f /dev/vg00/lv00