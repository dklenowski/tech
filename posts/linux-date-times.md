Categories: linux
Tags: time
      date
      datetime

## Linux Clocks

### Hardware Clock

- aka Real Time Clock (RTC)
- Used to set time across reboots.
- To view:

        # hwclock --utc
        Mon 10 Oct 2011 08:30:20 PM EST  -0.265128 seconds

- Should set in UTC (as there is nowhere in the CMOS where you can set DST for the hardware clock).

        # cat /etc/sysconfig/clock 
        ZONE="Australia/Sydney"
        UTC=true
        ARC=false

- If using NTP, not necessary (and can cause issues) to sync the hardware clock to the system clock.

### System Clock

- Used by the OS.
- To view:

        # date
        Mon Oct 10 20:32:02 EST 2011

- Set system clock using `date` and sync to hardware clock using:

        # hwclock --systohc --utc

### Timezone ###

- Current timezone can be found in:

        # cat /etc/sysconfig/clock | grep ZONE
        ZONE="Australia/Sydney"

- Or by checking the symlink of `/etc/localtime`

- To change the timezone, edit `/etc/sysconfig/clock` and re-symlink `/etc/localtime`, i.e.

        # ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

- By default, during installation, the /etc/localtime file is copied and not symlinked.
- If that occurs, it can be more difficult to determine the current timezone, 
        
        # md5sum /etc/localtime
        # find /usr/share/zoneinfo -type f -exec md5sum {} \; | grep 85285c5495cd5b8834ab62446d9110a9
        85285c5495cd5b8834ab62446d9110a9  /usr/share/zoneinfo/Australia/NSW
        85285c5495cd5b8834ab62446d9110a9  /usr/share/zoneinfo/Australia/Sydney
        ...






