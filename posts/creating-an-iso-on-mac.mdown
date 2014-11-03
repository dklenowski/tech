Categories: mac
Tags: iso
      diskutil

## Creating an ISO on a MAC

        diskutil unmountDisk /dev/disk2s1
        dd if=/Users/dave/Downloads/debian-6.0.9-amd64-netinst.iso of=/dev/disk1 bs=1m
        diskutil eject /dev/disk1