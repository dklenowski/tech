Categories: linux
Tags: kvm
      console
      virsh

## Adding a console to a KVM host

- Before you move a KVM VM into production, it is good to ensure a console is enabled.
- To enable console access on a KVM VM, edit `/etc/inittab` on the VM and ensure the following line is uncommented:

        T0:23:respawn:/sbin/getty -L ttyS0 9600 vt100

- Restart the init process on the VM using the following command:

        init q

- Test the console by using the following command from the KVM hypervisor:

        virsh console <host>