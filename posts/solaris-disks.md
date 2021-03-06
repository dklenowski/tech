Categories: solaris
Tags: disks
      mount
      devfsadm
      cdrom
      partition

## `c0t0d0s0`

### `c0`

- Controller 0

### `t0`

- Target 0
- aka SCSI-ID

### `d0`

- Disk 0 aka LUN 0

### `s0`

- Slice 0

## Configuration Files ##

### `sd.conf`

- Lists the controllers on the storage array, not all the LUN's on that controller.
- Supports 1 LUN/target but can be configured to support 256 (by adding entries to `sd.conf`).


## Recreating the device tree ##

        # devfsadm
        # update_drv -f sd
  
Note, `drvconfig`, `devlinks` and `disks` are only required for Solaris 2.6.

## Recreating the `bootblk`

        # installboot /usr/platform/`uname -i`/lib/fs/ufs/bootblk /dev/rdsk/c0t0d0s0

where `/dev/rdsk/c0t0d0s0` is the boot disk.

### Mounting a cdrom

- Too execute the following command volume management (vold) must be turned off.

        # mount -F hsfs -o ro /dev/dsk/c0t2d0s0 /mnt/cdrom
        To find the device use
        
        # cfgadm -la
        Ap_Id                      Type         Receptacle   Occupant     Condition
        c0                         scsi-bus     connected    configured   unknown
        c0::dsk/c0t0d0             disk         connected    configured   unknown
        c0::dsk/c0t1d0             disk         connected    configured   unknown
        c0::dsk/c0t2d0             CD-ROM       connected    configured   unknown

### Partitioning ###

- Create a `root` partition on slice 0 with a size of `500mb` and stick the rest on slice 4.

- Original partition table:

            partition> p
            Current partition table (original):
            Total disk cylinders available: 24620 + 2 (reserved cylinders)
            
            Part      Tag    Flag     Cylinders         Size            Blocks
              0 unassigned    wm       0                0         (0/0/0)            0
              1 unassigned    wm       0                0         (0/0/0)            0
              2     backup    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
              3 unassigned    wm       0                0         (0/0/0)            0
              4 unassigned    wm       0                0         (0/0/0)            0
              5 unassigned    wm       0                0         (0/0/0)            0
              6 unassigned    wm       0                0         (0/0/0)            0
              7          -    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
            


- First delete slice 7:

            partition> 7
            Part      Tag    Flag     Cylinders         Size            Blocks
              7          -    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
            
            Enter partition id tag[unassigned]:      
            Enter partition permission flags[wu]: 
            Enter new starting cyl[0]: 
            Enter partition size[71127180b, 24620c, 24619e, 34730.07mb, 33.92gb]: 0
            partition> p
            Current partition table (unnamed):
            Total disk cylinders available: 24620 + 2 (reserved cylinders)
            
            Part      Tag    Flag     Cylinders         Size            Blocks
              0 unassigned    wm       0                0         (0/0/0)            0
              1 unassigned    wm       0                0         (0/0/0)            0
              2     backup    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
              3 unassigned    wm       0                0         (0/0/0)            0
              4 unassigned    wm       0                0         (0/0/0)            0
              5 unassigned    wm       0                0         (0/0/0)            0
              6 unassigned    wm       0                0         (0/0/0)            0
              7 unassigned    wu       0                0         (0/0/0)            0

- Now create the 0 slice:

            partition> 0
            Part      Tag    Flag     Cylinders         Size            Blocks
              0 unassigned    wm       0                0         (0/0/0)            0
            
            Enter partition id tag[unassigned]: root
            Enter partition permission flags[wm]: 
            Enter new starting cyl[0]: 
            Enter partition size[0b, 0c, 0e, 0.00mb, 0.00gb]: 500mb
            partition> p
            Current partition table (unnamed):
            Total disk cylinders available: 24620 + 2 (reserved cylinders)
            
            Part      Tag    Flag     Cylinders         Size            Blocks
              0       root    wm       0 -   354      500.78MB    (355/0/0)    1025595
              1 unassigned    wm       0                0         (0/0/0)            0
              2     backup    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
              3 unassigned    wm       0                0         (0/0/0)            0
              4 unassigned    wm       0                0         (0/0/0)            0
              5 unassigned    wm       0                0         (0/0/0)            0
              6 unassigned    wm       0                0         (0/0/0)            0
              7 unassigned    wu       0                0         (0/0/0)            0

- Create the 4 slice.
  - For some reason, you cannot change offset the start of the partition, until you first format the partition to cover the whole disk.
  - i.e. the following creates a partition of size 0:

            partition> 4
            Part      Tag    Flag     Cylinders         Size            Blocks
              4 unassigned    wm       0                0         (0/0/0)            0
            
            Enter partition id tag[unassigned]: 
            Enter partition permission flags[wm]: 
            Enter new starting cyl[0]: 355
            Enter partition size[0b, 0c, 355e, 0.00mb, 0.00gb]: 0    

  - Instead, first map the partition to the whole disk:

            partition> 4
            Part      Tag    Flag     Cylinders         Size            Blocks
              4 unassigned    wm       0                0         (0/0/0)            0
            
            Enter partition id tag[unassigned]: 
            Enter partition permission flags[wm]: 
            Enter new starting cyl[0]: 
            Enter partition size[0b, 0c, 0e, 0.00mb, 0.00gb]: 24619c

  - Then offset the partition:

            partition> 4
            Part      Tag    Flag     Cylinders         Size            Blocks
              4 unassigned    wm       0 - 24618       33.91GB    (24619/0/0) 71124291
            
            Enter partition id tag[unassigned]: 
            Enter partition permission flags[wm]: 
            Enter new starting cyl[0]: 355
            Enter partition size[70101585b, 24265c, 24619e, 34229.29mb, 33.43gb]: 24265c
            partition> p
            Current partition table (unnamed):
            Total disk cylinders available: 24620 + 2 (reserved cylinders)
            
            Part      Tag    Flag     Cylinders         Size            Blocks
              0       root    wm       0 -   354      500.78MB    (355/0/0)    1025595
              1 unassigned    wm       0                0         (0/0/0)            0
              2     backup    wu       0 - 24619       33.92GB    (24620/0/0) 71127180
              3 unassigned    wm       0                0         (0/0/0)            0
              4 unassigned    wm     355 - 24619       33.43GB    (24265/0/0) 70101585
              5 unassigned    wm       0                0         (0/0/0)            0
              6 unassigned    wm       0                0         (0/0/0)            0
              7 unassigned    wu       0                0         (0/0/0)            0
            
            partition> label
            Ready to label disk, continue? y
