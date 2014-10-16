Categories: linux
            memory
Tags: memory
      top
      vmstat
      meminfo
      free

## References ##

- [1]     [http://www.gnutoolbox.com/linux-free-command/](http://www.gnutoolbox.com/linux-free-command/)
- [2]     [http://lwn.net/Articles/28345/](http://lwn.net/Articles/28345/)


## `free` ##

 - See [1] for a pic.


        # free
                     total       used       free     shared    buffers     cached
        Mem:      16426736   16224084     202652          0     213516    7216488
        -/+ buffers/cache:    8794080    7632656
        Swap:      8393952    2667232    5726720


        used(buffers/cache) + free(buffers/cache) = total memory
        8794080+7632656=16426736    // where 16426736 is the total amount of memory of the system
        buffers(Mem) - The amount of memory used for raw disk blocks.
        cached(Mem) - The amount of memory used for the pagecache.
        
        buffers(Mem)+cached(Mem)+free(Mem)=free(buffers/cache) // memory that is effectively available to be used.
        213516+7216488+202652=7632656
        

## `top`

        # from the top 2 lines of top
        Mem:  16426736k total, 16089220k used,   337516k free,   211308k buffers
        Swap:  8393952k total,  2667232k used,  5726720k free,  7153368k cached

        used+free=total // for mem
        used+free=total // for swap

## `vmstat`

        # vmstat
        procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
         r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
         0  0 2667232 197544 213564 7221284    0    0   191   255    0    0  4  3 92  1  0

- where:
  - `si` Swap Ins.
  - `so` Swap Outs.

### `Cache Values`


        # vmstat -m
        Cache                       Num  Total   Size  Pages
        ...
        ext3_inode_cache          66427  66760    760      5
        ..
        skbuff_head_cache         12372  15810    256     15
        ..
        buffer_head              1606923 1821880     96     40

where:

#### `buffer_head`

- Memory allocated for block descriptors via the Slab Allocator.
- i.e. `buffer_head` is a block descriptor that contains all information kernel needs to manipulate buffers (and corresponding data blocks).
  - i.e. in memory -> buffer, on disk -> blocks

#### `ext3_inode_cache`

- Memory allocated via the Slab Allocator (i.e. via `kmem_cache_*` calls) to store `ext3_inode_info` `inode` information.
- i.e. whenever a file is created/opened, its `inode` information is stored in the `ext3_inode_cache`..

#### `skbuff_head_cache`

- Socket buffers allocated via the Slab Allocator.
- i.e. Socket Buffers are lower layer doubly linked lists that are used to exchange data between the various network layers (e.g. via pointers rather than memory copies).
- There are different socket buffers for transmit and receive (each with their own linked lists).


## `/proc/meminfo`

        # cat /proc/meminfo 
        MemTotal:     16426736 kB
        MemFree:        113268 kB
        Buffers:        208432 kB
        Cached:        7217616 kB
        SwapCached:    1485364 kB
        Active:       11274424 kB
        Inactive:      4409576 kB
        HighTotal:           0 kB
        HighFree:            0 kB
        LowTotal:     16426736 kB
        LowFree:        113268 kB
        SwapTotal:     8393952 kB
        SwapFree:      5726720 kB
        Dirty:             724 kB
        Writeback:           0 kB
        AnonPages:     8236668 kB
        Mapped:          40892 kB
        Slab:           337404 kB
        PageTables:      42416 kB
        NFS_Unstable:        0 kB
        Bounce:              0 kB
        CommitLimit:  16607320 kB
        Committed_AS: 12944384 kB
        VmallocTotal: 34359738367 kB
        VmallocUsed:    273024 kB
        VmallocChunk: 34359465315 kB
        HugePages_Total:     0
        HugePages_Free:      0
        HugePages_Rsvd:      0
        Hugepagesize:     2048 kB

where:

### `SwapCached` ###

- An in-memory region used to store information that is either swappable or being loaded back into main memory.
- i.e.
  1. If data is being swapped to disk, it is first placed in the `swapCache`, then swapped to disk.
  2. Then a file is being read back into memory from swap, it is first loaded into the `swapCache`, then the RAM is mapped to the process.
- For both the conditions above, the `swapCache` is used to avoid race conditions.

The following 4 definitions are from [3]

### `Buffers` 

- Relatively temporary storage for raw disk blocks shouldn't get tremendously large (20MB or so).
- File system metadata.

### `Cached`

- In-memory cache for files read from the disk (the `pageCache`).  Doesn't include SwapCached

### `Active`

- Memory that has been used more recently and usually not reclaimed unless absolutely necessary.

### `Inactive`

- Memory which has been less recently used.  It is more eligible to be reclaimed for other purposes
