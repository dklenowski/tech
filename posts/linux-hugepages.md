Categories: linux
Tags: hugepages
      huge
      page
      memory

## References 

- [Page Table structures and Venn Diagrams](http://linux-mm.org/HugePages)
- [Overview of Hugepages](http://lwn.net/Articles/374424/)
- [Oracle and Hugepages](http://www.oracledatabase12g.com/wp-content/uploads/html/HugePages%20on%20Linux%20What%20It%20Is...%20and%20What%20It%20Is%20Not.htm)
- [Applications that support huge pages](http://wiki.debian.org/Hugepages)

## Kernel Source References

- [Shared Memory Segments](http://lxr.free-electrons.com/source/ipc/shm.c)
- [Allocation of Huge Pages](http://lxr.free-electrons.com/source/fs/hugetlbfs/inode.c)


## Restrictions

- Hugepages cannot be swapped onto disk.
- The stack cannot be backed using hugepages.
- Hugepages and regular pages cannot be mixed.
- May require reboot when configured (if not enough free memory available).

## Process ##

### Ensure huge page table configured into kernel ###

        # cat /proc/meminfo |grep Hugepagesize
        Hugepagesize:       2048 kB


### Modify `SHMMAX` ###

        # echo 4294967295 > /proc/sys/kernel/shmmax


### Configure number of huge page's ###

- For 3 GB (assuming a large page size of 2048k, then `3g = 3 x 1024m = 3072m = 3072 * 1024k = 3145728k`, and `3145728k / 2048k = 1536`):

        # echo 1536 > /proc/sys/vm/nr_hugepages

## Java Notes ##

For Java you must use the following command line arguments, in order to use huge pages:

        java -XX:+UseLargePages

- Note, your `-Xmx` setting must be available to completely fit into the number of huge pages comfortably.
- e.g. for `-Xmx3192m` the number of huge pages (using a page size of 2048k) required was 1640 (overhead 13504k).



