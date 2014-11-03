Categories: solaris
Tags: solaris

### Boot Process

#### OpenBoot Monitor Prompt (OBP)

- Boot PROM (accessed through the firmware OBP) is used to store the firmware that is executed after the system finishes the POST.
- Used to boot OS, run diagnostics, modify boot related parameters in the NVRAM.
- 2 supported versions of OpenBoot:
  - 2.x - SPARCstation 2.
  - 3.x - Current, enhanced version and based IEEE std for boot firmware.
- Contains a command interpreter (like shell), with 2 modes:
  - Restricted Mode - ">" prompt, can boot OS but cant modify system parameters.
  - Forth Monitor - "ok" prompt, can boot OS and monitor system parameters.
- Performs the following functions:
   1.  Power On SelfTest (POST).
   2.  Test and initialize system.
   3.  Determine hardware configuration.
   4.  Boot the OS.
   5.  Provide interactive debugging.

#### Boot Process

##### 1. Boot PROM

1.  Runs the POST (Power On SelfTest).

  - If the PROM `diag-switch=true`, output from the POST will be displayed.
  - The PROM `diag-level` determines the extent of the POST tests.
  - The Memory Management Unit (MMU) is enabled.

2.  Checks the NVRAM

  - if `use-nvramc=true`, the NVRAM is read.
  - The directly connected monitor (console) and keyboard becomes active.
  - The PROM banner is displayed.
  - The device tree is created (to view the device tree use `prtconf`).

3. Extended Diagnostics

  - If the `auto-boot?` PROM parameter set, the boot process begins, otherwise the system drops to the `ok` PROM monitor prompt.
  - Or if the security OpenBoot mode is set, the security prompt is displayed `>`.
  - The boot process uses the boot-device and the boot-prompt unless the `diag-switch` is set.
  - If the `diag-switch?` is set it will use the `diag-device` and `diag-file`.

##### 2. Boot programs

1. The OBP loads the `bootblk` primary boot program from the boot-device or `diag-device`.

  - If the `bootblk` program is not present, use the `installboot` command after booting from a cdrom or network.
     - For a UFS filesystem, `bootblock` located on the physical disk sectors 1 through 15.

                $ installboot <bootblock> <raw_disk_device>

2.  The secondary boot program (`/platform/'arch -k'/ufsboot`) is loaded into memory and run.

  - This program loads the core kernel image files.
  - If the file is corrupted/ missing the following message (or similar) will be displayed:

              bootblk: can't find the boot program

  - A different secondary boot loader is needed for each different filesystem installed on the boot device

##### 3. Kernel Initialisation

1.  The kernel is then loaded and run: 
  - For 32 bit SPARC systems, the kernel is `/platform/'arch -k'/kernel/genunix` 
  - For 64 bit SPARC systems, the kernel is `/platform/'arch -k'/kernel/sparcv9/unix`
2.  The kernel banner is then displayed on the screen.
3.  The kernel initialises and begins loading modules, reading files with the `ufsboot` program until it has loaded enough files to mount the root filesystem itself.
4.  The `ufsboot` program is then unmapped and the kernel uses its own device drivers.
5.  Control is then passed to `krtld` (which notes dependencies). 
  - Runtime linker also loaded. 
  - Loaded based on information in the ELF headers of the kernel.
6. /etc/system is then read by the kernel and system parameters are set.
  - Used for tuning/ customising the kernel:

          moddir          Changes path of the kernel modules.
          forceload       Forces loading of a kernel module.
          exclude         Excludes a particular kernel module.
          rootfs          Specify the system type for the root filesystem ( default ufs).
          rootdev         Specify the physical device for root.
          set             Set the value of a tuneable system parameter.

  - -If modifying the `/etc/system` renders the system unbootable, might be possible to bring the system up using `boot -a` and specify the old `/etc/system` file. 
    - Else will have to boot from the cdrom/network and edit the `/etc/system` file manually.
7. The kernel creates PID 0 (the scheduler) aka the `swapper`.

##### 4. Process initialisation

1. Kernel starts at PID 1 (init). 

`init` is used to control system processes and services.

              /etc/default/init   Used to set the default environment variables e.g. timezone.
              /etc/inittab        Specifies the default run level.
                                  Every run level has an entry in this file that 
                                  identifies an rc program to execute.

2. Then executes the appropriate `rc` scripts for the associated run level (note can use debugging by adding "echo" lines to a script to see the status of processing).

### Run Levels

- Default level 3 (set in `/etc/inittab`)
- `init` process used to perform transitions between run levels.

        0       Power Down          Shut down OS.
                                    Users forced off, services stopped.
                                    When process complete, ok prompt.
        s or S  Single User         Run as a single user.
                                    Users logged off, services stopped (except most basic).
                                    Mounted filesystems remain mounted.
                                    Command line interface.
                                    e.g. system backups.
        1       Administrative      Logged on users not affected.
                                    Users not affected, services stopped (except most basic).
                                    Mounted filesystems remain mounted.
                                    e.g. system backups (while still allowing user access).
        2       Multiuser           Normal operation, multiple user access.
                                    All daemons running except NFS (NFS client started).
                                    Default filesystems mounted.
        3       Multiuser with NFS  Default system state (normal operation).
                                    Multiple users, all services, default filesystem mounted.
        4       Alternative         Not Used
                Multiuser
        5       Power Down          System shut down.
                                    Users logged off, OS services stop.
                                    If supported hardware, power system automatically turned off.
        6       Reboot              System shut down (run level 0) and restarted and brought
                                    back to default run level (as defined in /etc/inittab).


#### View current run level

      # who -r

#### Changing run levels

##### `halt`

- Logs shutdown to system log and system accounting file.
- Performs a call to sync and halts the processor.
- Changes to run level 0 but does not execute scripts associated with run level 0 (as the `shutdown` and `init` commands do).

##### `init` (aka `telinit`)

- Used to change to any system run level.
- Reads `/etc/inittab` and executes appropriate `rc` scripts.
- Any processes not in `rc` directories are sent a `SIGTERM` or a `SIGKILL`.
- `telinit` exists for backward compatibility.

##### `poweroff`

- Changes to run level 5.
- Logs shutdown to system log and system accounting file.
- Performs a call to sync, halts the processor and if possible shuts the power off.
- Equivalent to `/usr/sbin/init 5`.

##### `reboot`

- Changes to run level 5.
- Logs shutdown to system log and system accounting file.
- Performs a call to sync and initiates a multiuser reboot.
- To pass arguments to OpenBoot `boot` command, use the `--` argument.
- e.g. to reboot from cdrom

      # reboot -- cdrom

###### `shutdown`

- Provides a grace period and warning message capability and executes the appropriate `rc` scripts.
- Can use shutdown to change to run levels `0, 1, 5, 6, s`


### Solaris Internals

#### Kernel

- Divided into groups of related functions called modules.
- Note that device drivers are dynamic modules that are loaded when the device is accessed.
- Kernel modules are divided into 1 of 4 categories (which determine there placement in the directory hierarchy):

  1.  `/kernel`
      - Contains the OS system modules that are platform independent.
      - i.e. the common kernel modules responsible for booting e.g. `genunix`

  2.  `/platform/<platform-name>/kernel/` (SPARC) and `/platform/i86pc/kernel` (Intel x86)
      - Modules that are specific to the platform/machine type.
      - i.e. Kernel modules that deal specifically with the box dependencies.
      - e.g. environmental controls and interconnect-specific support.
      - For sun based platforms, `<platform-name>` is:

                SUNW,<system>
        - e.g.

                e.g. SUNW,Ultra-2

  3.  `/usr/kernel`
      - Common kernel modules that are used by platforms with a particular instruction set.

  4.  `/usr/platform`
      - Contains kernel modules that are loaded as needed.
      - Modules can be loaded either on demand or as a result of an application process.

#### File System

- Solaris uses the Unix File System (UFS)
- Holds all the files in the root directory.
- Kernel has default support for UFS to hold its initial boot information (SPARC systems only).
- When you create a UFS file system, disk slices are divided into cylinder groups which are made up of 1 or more consecutive disk cylinders.
- Cylinder groups are further divided into addressable blocks to control and organise the structure of the files within the cylinder group.
- Each type of block has a specific function in the file system.
- UFS file system has 4 types of blocks:

  1.  Boot Block
      - Stores procedures used in booting the system.
      - If the file system is not used for booting this block is left blank.
      - The boot block appears only in the first cylinder group (cylinder group 0) and is the first 8 Kb in a slice.
      - e.g. Creation of the boot block

                                       #installboot /usr/platform/`uname -i`/lib/fs/bootblk

                                       /dev/rdsk/<device>

  2.  Superblock
      - Located at the beginning of the slice and replicated in each cylinder group.
      - Since contains critical data, multiple superblocks made when the filesystem is created.
      - Each superblock replica is offset by a different amount from the beginning of its cylinder.
      - Provides detailed information about the filesystem including:
        - size and status of the filesystem
        - label (filesystem name and volume name)
        - size of the filesystems logical block
        - cylinder group size
        - number of data blocks in a cylinder group
        - summary data block data
        - file system state: clean, stable, active

  3.  Inode                                  
      - Contains all information about a file except its name, which is kept in a directory.
      - An inode is 128 bytes and contains:
        - type of file (e.g. regular, directory, symbolic link etc)
        - Mode of the file (e.g. permissions)
        - Number of hard links to the file.
        - userID of the file.
        - groupID of the file.
        - Number of bytes in the file.
        - Array of 15 disk block addresses: point to the data blocks that store the contents of the file.
        - Date and time the file was last accessed.
        - Date and time the file was last modified.
        - Date and time the file was created.

  4.  Data Blocks                       
      - aka storage blocks
      - Size is determined as the file is created.
      - Allocated by default in 2 sizes: 8 Kb logical block size and 1 Kb fragmentation size.
      - Regular files
        - Data blocks contain the contents of the file.
      - Directory               
        - Data blocks contains entries that give the inode number and the file name of the file in the directory.



