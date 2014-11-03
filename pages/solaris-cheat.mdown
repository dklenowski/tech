Categories: solaris
Tags: solaris

### One-Liners ###

#### List open files for all processes ####

    # pfiles `ps -ef | awk '{print $2}'`

#### Search through the `rc.d` directories

    # grep dtlogin /etc/rc?.d/S*

#### Starting the CDE

    # dtlogin

#### Determine memory size

    # prtconf |grep "Memory"
    Memory size: 2048 Megabytes

#### Fixing a corrupt superblock ####

1. Run `newfs` to find available superblocks:

      # newfs -N /dev/dsk/c0t0d0s1
      Warning: 1 sector(s) in last cylinder unallocated
      /dev/rdsk/c0t0d0s1:     1229444 sectors in 1301 cylinders of 15 tracks, 63 sectors
              600.3MB in 82 cyl groups (16 c/g, 7.38MB/g, 3584 i/g)
      super-block backups (for fsck -F ufs -o b=#) at:
       32, 15216, 30400, 45584, 60768, 75952, 91136, 106320, 121504, 136688, 151872,
      ....

2. Run `fsck` using an alternative superblock (`fsck`) uses block 32 by default as the superblock).

      # fsck -y -o b=<blocknr> /dev/rdsk/c0t1d0s[0-7]
        -y            Answer yes to all questions

### System Statistics ###

      #prtconf | grep Memory        // memory
      # psrinfo [-v]                // processors
      # isainfo -b                  // whether running in 32/64 bit


### Displays ###

#### Funky Console 

- For console connections

    # export TERM=vt100

#### Setting screen resolution for gnome ####

    # /usr/sbin/m64config -dev /dev/fbs/m640 -res 1152x900 -depth 24
    # /usr/sbin/m64config -dev /dev/fbs/m640 -res \?

### Networking ###

- To reload network configuration in Solaris 10

    # svcadm restart svc:/network/physical

#### Disable routing ####

    1 - enable, 0 - disable
    $ ndd -get /dev/ip ip_forwarding
    1
    $ ndd -set /dev/ip ip_forwarding 0

#### `/etc/inet/hosts` ####

- Symlinks to `/etc/hosts` (for BSD compatibility).
- Format:

      ip_address    hostname    alias

##### `/etc/nodename` #####

- Contains the default hostname for the local system.

##### `/etc/hostname.*`

- Name of the interfaces.
- e.g. hostname.hme0 for a physical interface, hostname.hme0:1 for a virtual interface.
- Contains either the hostname or IP address assigned to that interface.
- If a hostname is used the hostname must be listed in `/etc/inet/hosts`.
- Note, only the hostname/IP address that matches the hostname defined in `/etc/nodename` is considered the default hostname for the system.

##### `/etc/inet/netmasks` #####

- Symlinks to `/etc/netmasks` (for BSD compatibility).
- Contains the netmasks for the corresponding network address'es.
- Format:

      network   netmask

- Note, Solaris supports both classless routing and VLSM.

##### `/etc/defaultrouter` #####

- Contains a single IP address that is the default route for the local box.
- The address must be directly connected (on the same network) as an interface (else you will need to add a route).
- e.g.

        echo "192.168.5.9" > /etc/defaultrouter

### Disable/Enable Routing ###

    1 - enable
    0 - disable
    
    # ndd -get /dev/ip ip_forwarding
    1
    # ndd -set /dev/ip ip_forwarding 1

### Mount CDROM ###

- Determine where cdrom located

        # iostat -En

- Check vold not running (if so stop)
  - If `vold` is running cant manually mount.
  - `volcheck` forces a check to see if anything needs to be mounted.

            # ps -ef |grep vold

- Mount cdrom

        # mount -F hsfs -o ro /dev/dsk/c0t0d0s0 /mnt/cdrom


### OpenBoot ###

#### boot key escapes ####

- Key escapes:

        stop      Bypasses post.
        stop+a    Aborts OS or boot process and returns to `ok` prompt.
        stop+d    Enter diagnostics mode.
        stop+f    Enters forth monitor on the ttya instead of the system console.
        stop+n    At the `ok` prompt, reset NVRAM to factory defaults.

#### `reset-all` ####

- The following can occur on older sparc machines if you send a break before the memory has been initialised.

    FATAL: OpenBoot initialization sequence prematurely terminated.
    FATAL: system is not bootable, boot command is disabled

- To rectify, enter the following command at the `ok` prompt

        {2} ok reset-all

### Solaris Password Recovery

- Assuming that the OpenBoot security level has not been set (or set and the password is known) the following method describes the process of changing a "lost" root password.
- If the PROM and root passwords are forgotten (with the security mode set to full), the system's PROM will have to be replaced, because it is impossible to boot from the CD-ROM to recover the root password if you cant access the OpenBoot prompt to change the boot device.

#### OpenBoot Recovery

- Use when the OpenBoot and root passwords are lost and the OpenBoot security level is set to full.

1.  Remove the old PROM from the system (used later).
2.  Insert a new PROM (with security mode set to `none`).
3.  Follow the instructions for the "Root Password Recovery" (below) to recover the root password.
4.  Shutdown the system and power it off.
5.  Switch back to the original PROM (removed in Step 1).
6.  Login as root with the newly created password and change the OpenBoot password using the `eeprom` command.

#### Root Password Recovery

- Use when the root password is lost.

1. Determine the device name for the partition containing the `/etc` directory.

        bash-2.03$ df /etc
        /                  (/dev/dsk/c0t0d0s0 ): 1011174 blocks   275396 files

2. Insert the Solaris CD 1 and reboot.
3. During the boot process enter the OpenBoot prompt (`stop+a`).
4. Boot from the CDROM into single user mode.
  - Depending on the kernel environment variable set in the OpenBoot may have to specify the location of the kernel on the CDROM).

            ok boot cdrom -s
            ok boot cdrom /platform/sun4u/kernel/unix -s

5.  Mount the directory that contains `/etc`.

          # mkdir /tmp/mnt
          # mount /dev/dsk/c0t0d0s0 /tmp/mnt

  - Note, you may have to `fsck` the device (if not shut down cleanly).

            # fsck /dev/rdsk/c0t0d0s0 -y


6.  Change to the directory when the root password is located and backup the `/etc/shadow` file.

          # cd /tmp/mnt/etc
          # cp shadow shadow.bak

7.  Edit the `/etc/shadow` file and remove the root password.

          # TERM=xterm; export TERM
          # vi /tmp/mnt/etc/shadow

  - And change:

            /etc/shadow                root : xdexJE8X82VM : 6445::::::

  - to:

            /etc/shadow                root :: 64445:::::::

8.  Unmount the root filesystems and flush the filesystem cache

        # umount /tmp
        # sync; sync

9. Reboot the system
  - Should now be able to log on as root without being prompted for a password.
  - Immediately change the root password once logged on !

### Changing the `hostid` ###

- On Sun OS 4.1.x you can find the hostID by running:

        /usr/etc/devinfo -vp
        /usr/sbin/prtconf -vp

- The IDPROM contains the hostID, it is composed of the following:

        byte
        0       always 1 (format / version number)
        1       first byte of host ID
        2-7     6 byte ethernet address (first 3 bytes should be 08,00, 20)
        8-b     date of manufacture (usually all 0's)
        c       second byte of host id
        d       third byte of host id
        e       fourth byte of host id
        f       idprom checksum - bitwise xor of bytes 0-e

- e.g to print the values of the IDPROM:

        ok 0 idprom@ .           1
        ok 1 idprom@ .           80
        ok 2 idprom@ .           8
        ok 3 idprom@ .           0
        ok 4 idprom@ .           20
        ok 5 idprom@ .           ae
        ok 6 idprom@ .           b1
        ok 7 idprom@ .           bd
        ok 8 idprom@ .           0
        ok 9 idprom@ .           0
        ok a idprom@ .           0
        ok b idprom@ .           0
        ok c idprom@ .           ae
        ok d idprom@ .           b1
        ok e idprom@ .           bd
        ok f idprom@ .           a9

 
- To change the hostid to `80c01f3d`

        ok 80 1 mkp
        ok c0 c mkp
        ok 1f d mkp
        ok 3d e mkp 
        ok 0 f 0 do i idprom@ xor loop f mkp
        ok f idprom@ .

  - The last 2 lines are used to recompute a CRC that is used to check the hostID has not been corrupted.
