Categories: amazon
Tags: amazon
      ebs
      elastic block store

### Creating and mounting an EBS volumes

1. Create the EBS volume

          Elastic Block Store > Volumes > Create Volume

2. Attach the volume to an `instanceId` (note your instance and volume must reside in the same zone).

          Volumes > Attach Volume

3. Check `/var/log/messages` to see if the device was attached.

4. Assuming the volume was attached as `sdh` run

        # yes | mkfs -t ext3 /dev/sdh

4. Create the mount point.

        #  mkdir /mnt/data-store

3. Mount the EBS volume

        #  mount /dev/sdh /mnt/data-store

