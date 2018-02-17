Categories: aix
Tags: aix
      lpar
      wpar
      vio
      hmc

## Terms

### AIX

- SysV based.
- Package format `bff` (similar to dump and restore).
- Can only run on POWER CPU's (which use RISC).

### LPAR

- Logically separated within same physical server.
- Managed by system firmware (POWER Hypervisor).
- Logically separate systems within same physical server.
- Each partition has its own:
  - OS.
  - Resources (processes, memory, devices) can be changed dynamically using Dynamic LPAR (DLPAR).
- Can move LPAR's between systems using Live Partition Mobility.

### WPAR

- Workload Partitions
- OS within single instance of AIX OS (e.g. LPAR).
- Can move WPAR's between LPARS using Live Application Mobility.

## VIO Server (VIOS) ##

- aka Virtual IO Server.
- Manages physical resources on POWER5/6 system.
- i.e. use the VIO server to assign resources to an LPAR.
- Can manage AIX (5.3/6.1) and linux partitions.

### HMC

- Hardware Management Console
- Intel, runs cut down version of SuSE.
- Each HMC can manage up to 48 systems.
- Management of Systems and LPARS.
- Provides centralised:
  - Firmware updates.
  - Resource Allocation.
  - Live Application Mobility.

### NIM ###

- Network Installation Manager.
- Similar to Jumpstart servers.
- Provided ability to manage remote installation, backup, restore and upgrade of OS.

### SMIT ###

- System Management Interface Tool
- Menu driven system for the majority of system administration functions.












### ODM ###

- Consists of 2 major databases:
  1. Predefined - Universal Set
  2. Configuration - What is currently 'available'

  When using `lsdev`

    - Prefdefined - `lsdev -p`
    - Configuration - `lsdev -c`

- Repository stored `/etc/objrepos`.

## Administration ##


### SMIT ###

- Systems Management Interface Tool

### WebSM ###

- Being deprecated.

### pconsole ###

- Next generation.



### ASCII Files ###

- Exist for backward compatibility.
- Some exclusions, password file, print file, exports etc


## SMIT ##

- To start ASCII version:

        # smitty

- If your in a window manager and what `smit` to start in graphical mode:

        # smit

### Moving between windows ###

- When your in a window, type `F8` to get the `fast path` of the menu.
- Can then directly open that window.
- e.g. the following command moves to the date screen:

        # smit date

### Output Screen ###

- 3 states: `OK`, `RUNNING`, `FAILED`


### Terminal type ###

- Works with `xterm`.
- If function keys don't work, try:

      ESC-1 for F1


## Packaging ##

- `smit` is the front end to the AIX command `lslpp` (LiSts Licensed Program Product).


  fileset  >  package   > licensed program product (LPP)

## Devices ##

      # cfgmgr


## TCP/IP ##

- Each adapter (entX) has 2 logical interfaces: enX and etX
  - etX never used, part of original "experimental" ethernet.

- `mktcpip` used to create first interface (can configure hostname).
- For subsequent interface configuration use `chinet`

- To turn off ODM control for network interface:

      # chdev -l inet0 -a boot_option=yes

- To check:

      # lsattr -El inet0




## Administration ##

### Startup ###

- Can also use HMC.
    - Via "Activate"
    - Must also set a profile (which determines resources).
    - To boot into SMS need to use the "Advanced" tab.
    - 


### SMS ###

- Select boot device, password recovery.



#### Boot Logical Volume (BLV)

- Similar grub.
- Contains RAMFS, ODM, 


  # bootlist -m -o normal


- Must specify `-o`, otherwise can't boot (since you set the bootlist to null).






### SRC Master ###

- System Resource Control (SRC)
- Master daemon responsible for starting/stoping servers.
- i.e via `startsrc` `stopsrc`
- Daemon called `srcmstr`, parent is `init`



#### `/etc/inittab`

- Use `mkitab` to make an entry in `/etc/inititab`
- Use `chitab` to change an entry in `/etc/initab`

#### Listing Subsystems ####

List subsystems (processes)

        # lssrc -a

#### Stopping Service ####

      # stopsrc -s inetd

#### Starting Service ####

      # startsrc -s inetd


#### Sending a HUP ####

      # refresh -s inetd



## Partitions ##

- To apply a profile, must reboot a partition.
  - But can change resources dynamically.





