Categories: virtualisation
Tags: linux
      kvm
      virtualisation


## Create an empty disk

    dd if=/dev/zero of=/var/lib/libvirt/images/host.img bs=1M count=8092

## Attach a disk from the command line

    virsh attach-disk <hostname> /var/lib/libvirt/images/ubuntu-14.04.2-server-amd64.iso hdc --type cdrom --mode readonly


## Update config.xml

    virsh update-device <host> host.xml