Categories: linux
Tags: ssd
      performance

## References ##

- [https://wiki.archlinux.org/index.php/SSD#Tips_for_Maximizing_SSD_Performance](https://wiki.archlinux.org/index.php/SSD#Tips_for_Maximizing_SSD_Performance)
- [http://www.techmetica.com/howto/sata-ahci-mode-bios-setting.-what-does-it-do/#ixzz1ZQmJuynY](http://www.techmetica.com/howto/sata-ahci-mode-bios-setting.-what-does-it-do/#ixzz1ZQmJuynY)

## Tuning ##

### `/etc/fstab` options

#### `noatime`, `nodiratime`

- Disable `atime` updates on files (`noatime`) and directories (`nodiratime`).

#### `discard`

- Enable TRIM command (Does not work with `ext3`).
- Note, can also enable on a mounted filesystem using:

        # tune2fs -o discard /dev/sda1.

### Disable journaling ###

- Care must be taken when disabling journaling as this may affect filesystem recovery (e.g. in a system failure).

        # tune2fs -O ^has_journal /dev/sda1
        # tune2fs -l /dev/sdb1

### Kernel ###

#### `Scheduler`

- Preferrably to use `noop` scheduler with ssd disks.

        # echo noop > /sys/block/sdb/queue/scheduler

#### `/etc/rc.local`

        sysctl -w vm.swappiness=1 # Strongly discourage swapping
        sysctl -w vm.vfs_cache_pressure=50 # Don't shrink the inode cache aggressively

#### CPU Settings

        # echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        # echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        # cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_max > \ 
          /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate

#### Page Cache Settings ####

- Reference: [http://www.westnet.com/~gsmith/content/linux-pdflush.htm](http://www.westnet.com/~gsmith/content/linux-pdflush.htm)

        # echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
        # echo 20 > /proc/sys/vm/dirty_ratio
        # echo 10 > /proc/sys/vm/dirty_background_ratio

## Testing Automatic TRIM

- Make a 50MB file with random data:
  
          # dd if=/dev/urandom of=tempfile count=100 bs=512k oflag=direct

- Check the starting LBA address of the file:
  
          # hdparm --fibmap tempfile

- Read the first address of the file, note that you need to put the first LBA in place of [ADDRESS]:
  
          # hdparm --read-sector [ADDRESS] /dev/sdX

- Now remove the file and synchronize the filesystem:

          # rm tempfile
          # sync

- Use the same command as in 4 to re-read the LBA (if you get only zeros, then automatic TRIM is working):

          # hdparm --read-sector [ADDRESS] /dev/sdX

