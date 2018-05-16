Categories: aix
Tags: oslevel
      vio
      lpar

## URls ##

For patch levels, google:

  - Fix Level Recommendation Tool

## Troubleshooting ##

### Support Documentation

- Use `snap` (writes to `/tmp/ibmsup`)

        # snap -a

### Oslevel ###

- Determine the oslevel version.

        {lpar1} / # oslevel -s
        6100-02-02-0849


## Miscellaneous ##

- Enable `ksh` to use `vi`

        # set -o vi


### Shutdown ###

#### Fast shutdown ####

    # shutdown -F 


## Booting ##

### VIO Server ###

- Using IVM, the VIO server must be the first LPAR that is installed.
- Using HMC/NIM, the VIO server does not have to be the first server (although usually is).
- Typically, VIO installation is accomplished through a `mksysb` image on the HMC or NIM server.

## LPAR's ##

### AIX Partition

- When creating the virtual SCSI adapter, need to point the Server partition to the VIO server and ensure the `Virtual SCSI adapter Adapter` matches the `Server adapter ID`.


## SMIT

        # smitty

- Files:

        $HOME/smit.log
        $HOME/smit.script
        $HOME/smit.transaction

- Before running `smit`, ensure the `TERM` is set,

        export TERM=xterm-color OR
        export TERM=vt320

- Useful keys:

        F10     ESC,0
        PgDn    Ctrl-v
        PgUp    ESC-v
        Ctrl-l          List possible values.


## Networking ##

### Creating a Shared Ethernet Adapter (SEA) on a VIO server ###

        $ mk


## Disks ##

### List partitions on a disk ###

      # lspv -l hdisk0

- Can be used in combination with `lsfs`

### Get the full PVID (Physical Volume ID) ###

- The following command lists a 64 bit PVID:

        # lspv

- Note, the ODM stores as a 128 bit value:

        # odmget -q "name=hdisk0 nd attribute=pvid" CuAt


## Processors ##

### Display basic information ###

        {host} / # lparstat
        
        System configuration: type=Dedicated mode=Donating smt=On lcpu=2 mem=640MB
        
        %user  %sys  %wait  %idle physc  vcsw   %nsp
        ----- ----- ------ ------ ----- ----- -----

## Virtual Devices ##

### List virtual devices ###

        {lpar1} / # lsdev -Cc adapter
        ent0   Available  Virtual I/O Ethernet Adapter (l-lan)
        vsa0   Available  LPAR Virtual Serial Adapter
        vscsi0 Available  Virtual SCSI Client Adapter
        vscsi1 Available  Virtual SCSI Client Adapter


### Reconfiguring device tree ###

- e.g. after adding virtual device on the HMC.

          $ cfgmgr

### Dynamically Adding Devices ###

- When dynamically adding devices (via `HMC > "server" > "device" > Dynamic Logical Partitioning` must call `Configuration > Save Current Configuration` to preserve changes across reboot.



### Determine virtual interface of SEA ###

        $ lsdev -virtual |grep "Shared Ethernet"
        ent13            Available   Shared Ethernet Adapter
        ent17            Available   Shared Ethernet Adapter


### Dynamically Adding Devices ###

- When dynamically adding devices (via `HMC > "server" > "device" > Dynamic Logical Partitioning` must call `Configuration > Save Current Configuration` to preserve changes across reboot.



