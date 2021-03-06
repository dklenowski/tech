Categories: solaris
Tags: mirroring
      mirror
      metstat

# Solaris Mirroring

## Troubleshooting

### Gathering Information

    metastat -p         List all mirrors/submirrors.
    metastat <mirror>   List statistics on mirror (including filesystem where mirror resides).
    df -k               Lists mirrors being used.
    metadb [-i]         Info on metadevice state database (lowercase flags GOOD, uppercase flags BAD)

### Detaching Mirros

    $ metadetach <mirror> <submirror>

### Attaching Mirrors

- Note all data in submirror is overwritten.

        $ metaattach <mirror> <submirror>

### Recovering data from a submirror

- e.g. detached mirror, run an operation and want to restore from detached submirror.

        d4      d41     d42

1.  Break mirrors

        $ metadetach d4 d42

2.  Run operation ..
3.  If operation goes ok, reattach submirror

        $ metattach d4 d42

- To restore:

1.  umount disk

        $ umount /dev/md/dsk/d4

2.  clear state database replicas

        $ metaclear -r d4
        -r  recursively clear's submirrors

3.  create metadevices

        $ metainit d41 1 1 /dev/dsk/c0t0d0s4

4.  Create first submirror (using previously detached submirror)

        $ metainit d4 -m d42

5.  Attach second submirror (overwrites data on this mirror)

        $ metaattach d4 d41


## Packages

    SUNWmd      Solaris DiskSuite base
    SUNWmdg     DiskSuite GUI (optional)
    SUNWmdn     DiskSuite SNMP daemon (optional)

## Commands

    metadb      Create/deletes replicas of metadevice state database
    metainit    Configure metadevices.
                Config file: /etc/opt/SUNWmd/md.tab
    metahs      Manages metadevice hot spares and hot spare pools
    metaclear   Clears active metadevices.
    metaset     Configures metadevice disksets
    growfs      Non-destructively expands UFS filesystem
    metaonline  Places submirrors online (when submirrors returned to online state)
                an automatic synchronization is performed.
    metaoffline Places submirrors offline
                While submirror offline, all writes to mirror tracked and will be
                written when the submirror is placed back online.
                Submirror remains offline until a metaonline is executed or the
                system is rebooted.
    metattach   Attaches a metadevice to a metamirror or metatrans.
                Once attached, metattach will automatically state a synchronization
                operation from the existing submirror to the new submirror.
    metadetach  DEtaches a metadevice from a metamirror or metatrans.
                Once a submirror is detached, no longer part of the mirror.
    metaparam   Display and or modify current parameters of metadevices.
    metastat    Current status for each metadevice or hot spare pool.
    metareplace Replaces components of submirrors.
    metasync    Handles mirror synchronization during reboot.
    metaroot    Edits /etc/vfstab and /etc/system to redirect the source location of the
                root filesystem.

## Definitions

### metadevices

- Virtual disk, can represent single/multiple disks.
- Logical Metadevices /dev/md/dsk (block devices)
- Raw Metadevices /dev/mdsk/rdsk

### mirroring

- aka RAID 1
- Performance may increase on read, decrease on write, reliability increases.
- RAID 0+1 combines mirroring and striping for high performance and reliability.

### mirror

- Consists of metadevice composed of >= 1 submirrors.
- Any filesystem (root, swap, /usr) or appilcation can use a mirror.

### submirror

- Made up of >= 1 striped/concatenated metadevices.
- Slices of submirrors must be equals (or space remains unused).
- Common setup, associate physical disk slice to submirror and then create mirror of 2 submirrors.
- Place each submirror on different physical disk.

## Metadevice State Database

- Tracks configuration/status information.
- Must be initialzied before any metadevices can be configured.
- Each copy of database called a replica.
    - By default replica occupies 517 KB (1034 disk blocks) on partition.
    - DISKSUITE REQUIRES a minimum of 3 replica's to run.
    - Normally replicated across drives to avoid single points of failure.

### replica

- Stored at beginning of disk partition (similar to disk label).
- Partition must not be in use at time replicated created.
- System will:
    - Stay running with 1/2 or more replica's.
    - Panic with less than 1/2 replica's.
    - Wont start without 1/2 total replica's + 1 (n >= total/2+1)
        - Must reboot single user mode and delete bad replica's (metadb).

- Recommended:

        1               3 replica's, 1 on each slice.
        2 >= x >= 4     2 replica's on on each drive.
        >= 5            1 replica on each drive.
    

- statedb replica requirements:
    
        No. Valid replica's     Will OS run normally?       Will OS boot normally?
        (n/2)+1                 Yes                         Yes
        n/2                     Yes                         No (boot single user)
        < (n/2)                 No (system panic)           No (boot single user)
    
## Creation

- Before creating mirror, create striped/concatenated metadevices that will make up mirror.

1.  Create replica's

- Note: creation of replica's will destroy any data on target partitions.
- e.g. to create 2 replica's per slice on 3 disks

        $ metadb -a -f -c 2 -l <size> cXtXdXsX cXtXdXsX cXtXdXsX
        -a      Attach new database.
        -f      Create initial state database (replica)
        -c #    Number of replica's per slice
        -d      Delete replicas on specified slice
        -l <size>   Length, in blocks, for each replica (default 1034)
    
- NOTE: It is also possible to edit the md.tab
    
        Solaris <= 9        /etc/opt/SUNW/md/md.tab
        Solaris 100         /etc/lvm/md.tab

    -  Edit md.tab
    
            mddb01 cXtXdXsX cXtXdXsX cXtXdXsX

    - Reload metadb

            $ metadb -a -f mddb01

### Mirroring Filesystem that cannot be unmounted

1.  Put file system's slice in single slice (1-way) mirror
    
        $ metainit -f d31 1 1 c0t3d0s6
        -f forces creation of first concatenation, d36, which contains filesystem c0t3d0s6
    
2.  Create second submirror
    
        $ metainit d32 1 1 c0t2d0s6
    
3.  Create 1 way mirror from the first submirror

        $ metainit d30 -m d31

4.  Edit /etc/vsftab

        /dev/md/dsk/d30 /dev/md/rdsk/d30    /usr    ufs 2   no  -

5.  Reboot
6.  Attach second submirror to the mirror:
-  Note THIS CAUSES RESYNC FROM d30 (d31) to d32.
- Therefore ALL data in d32 OVERWRITTEN.
    
        $ metaattach d30 d32

### Mirroring Root slice

1.  Put root slice in single 1 way mirror

        $ metainit -f d31 1 1 c0t3d0s0
    
2.  Create second submirror
    
        $ metainit -f d32 1 1 c0t3d0s0
    
3.  Create 1 way mirror with first submirror

        $ metainit d30 -m d31
    
4.  Use metaroot to edit vfstab and system files so system can be booted with root filesystem on metadevice

        $ metaroot d30
    
5.  Run the lockfs command

        $ locfs -fa
    
6.  Reboot

7.  Attach second submirror to mirror

        $ metattach d30 d32
    
## Concatenated Metadevices

- Concatenated metadevice d10 our of a single partition

        $ metainit d10 1 1 /dev/dsk/c0t0d0s4
    
- Concatenated metadevice d11 out of 2 slices, c0t1d0s1 and c0t2d0s3

        $ metainit d11 2 1 /dev/dsk/c0t1d0s1 1 /dev/dsk/c0t2d0s3

- Concatenated metadevice d12 out of 3 slices.

    - First slice is a stripe of 2 physical slices (c0t1d0s1 and c1t1d0s1)
    - Second slice of d12 made up of a single physical slice (c0t2d0s3)
    - Third slice of d12 made of up 3 physical slices (c0t3d0s4, c1t3d0s4, c2t2d0s4)
    
            $ metainit d12 3 2 c0t1d0s1 c1t1d0s1 1 c0t2d0s3 \
            3 c0t3d0s4 c1t3s0s4 c2t3d0s4


## Striped Metadevice

- Creates striped metadevice d12 out of 2 slices, c0t1d0s3, c1t1d0s3

        $ metainit d12 1 2 /dev/dsk/c0t1d0s3 /dev/dsk/c1t1d0s3 -i 32k
    
## Replacing Faulty Disk

1.  Identify mirror that is in error

        $ metastat
    
2.  Determine the disks attached to the mirror:
    
        $ metastat -p d71
        d71 -m d72 d73 1
        d72 1 1 c1t2d0s0
        d73 1 1 c1t3d0s0 --> Faulty ..
    
3.  Replace faulty disk, nb due to a bug on the V880, you may need to run the following command (to reconfigure the device tree):
    
        $ devfsadm -C
    
4.  Format the filesystem with the same format as the mirrored disk:
    
        $ prtvtoc /dev/rdsk/c1t2d0s0 |fmthard -s - /dev/rdsk/c1t3d0s0
    
5.  Recreate replica's
    
        $ metadb -a -f -c 3 -l 8192 c1t3d0s7
    
6.  Detach old (faulty) submirrors:
    
        $ metadetach -f d71 d73
        d71: submirror d73 is detached
        $ metastat -p d71
        d71 -m d72 1
        d72 1 1 c1t2d0s0

7.  Clear faulty mirror and recreate

        $ metaclear d73
        $ metainit d73 1 1 /dev/dsk/c1t3d0s0
    
8.  recreate mirror
    
        $ metattach d71 d73

## Recovering from Disk Errors

- DiskSuite Striped metadevice can recover from a soft error (not hard errors)
- NB if you wait too long to replace a disk with soft errors, soft errors will become hard errors and you will lose your data.

### Soft Errors

- Disk starting to go bad.
- Error can be corrected using Error Correction Code (ECC) algorithm

### Hard Errors

- aka uncorrectable data errors
- ECC algorithm cannot recover data

### Process

1.  umount slice

        $ umount /data

2.  backup data to tape

        $ ufsdump 0f /dev/rmt/0 /dev/md/dsk/d8

3.  clear state database replica on faulty disk

        $ metaclear d8

4.  replace faulty disk and initialize configuration on new disk

        $ metainit d8

5.  use newfs on metadevice and restore data

        $ newfs /dev/md/rdsk/d8
        $ ufsrestore rf /dev/rmt/0