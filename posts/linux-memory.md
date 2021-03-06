Categories: unix
            linux
Tags: memory
      overhead
      slab
      cache
      vm
      page

## References ##

- [1]     Understanding the Linux Kernel, Second Edition, Daniel P Bovet and Marco Cesati, Dec 2002.
- [2]     Understanding the Linux Virtual Memory Manager, Mel Gorman, 2004
- [3]     Where is the memory going? Memory wast under Linux. Andi Kleen, SUSE Labs, Aug 15, 2006.
- [5]     Understanding Virtual Memory in Redhat Enterprise Linux 4, Neil Horman, December 13, 2005.

# Implementation Notes

## Overheads [3] ##

### `struct page`

- Around 56 bytes per page overhead on 64 bit and 32 bytes per page on 32 bit.
- For 4K page:
  - 64 bit, 1.37 % overhead.
  - 32 bit, 0.78 % overhead.

### Buddy Allocator

- Rounding overhead as pages must be a multiple of `2^n*PAGE_SIZE`

### Dentry Cache and Inode Cache

- Heaviest cache uses dentry cache (dcache) and inode cache.

## Viewing Slab Cache Information 

    # cat /proc/slabinfo
    # slabtop

## Viewing Page Table Information ##

    # cat /proc/meminfo

## VM Tunables ##

- Taken from [5]

### `/proc/sys/vm/block_dump`

- Boolean.
- Enable message logging of submitted IO requests and page writes.
- Messages are written as `debug` syslog messages.

### `/proc/sys/vm/dirty_background_ratio`

- Percentage of memory that needs to be dirty before `pdflush` begins writing out the dirty data to disk.

### `/proc/sys/vm/dirty_expire_centisecs`

- Hundredths of a second.
- Defines how long a disk buffer can remain in RAM in a dirty state.
- If buffer dirty, and has been in RAM longer than `dirty_expire_centisecs`, written to disk next time the `pdflush` thread runs.

### `/proc/sys/vm/dirty_writeback_centisecs`

- Hundredths of a second.
- Defines poll interval between iterations of the `pdflush` threads.
- Lower value, `pdflush` wakes up more often, but this can affect system responsiveness.

### `/proc/sys/vm/dirty_ratio`

- Expressed as a percentage of total system memory.
- Defines limit at which processes which are generating dirty buffers will begin to synchronously write out the data to disk, rather than relying in the `pdflush` daemon.

> "Increasing tends to make write access faster for a process, but at the expense of a larger workload presented to the `pdflush`, should that memory be required for other uses later." [5]

### `/proc/sys/vm/page_cluster`

- On a page fault, 2^page_cluster pages are read ahead.
- Defines how many pages of data are read into memory on a page fault.
- Increase this value for applications that require on allot of sequential data.
- Decrease this value for applications that make small random memory accesses.

### `/proc/sys/vm/min_free_kbytes`

- Defines the number of kilobytes VM must keep as free in the ZONE_NORMAL zone of each node in system.

### `/proc/sys/vm/swappiness`

- How quickly the VM will reclaim mapped pages, rather than just flushing out dirty pagecache data.

> "Should Distress + (Mappedpercent/2) + Swappiness >= 100, then the VM will try to unmap pages in an effort to reclaim memory, rather than just attempting to expunge pagecache." [5]

- where:

#### Distress ####

> "This is a measurement of how much difficulty the VM is having reclaiming pages. 
   Each time the VM tries to reclaim memory, it scans 1/nth of the inactive lists 
  in each zone in an effort to reclaim pages. Each time a pass over the list is made, 
  if the number of inactive clean + free pages in that zone is not over the low water mark, 
  n is decreased by one. Distress is measured as 100 >> n" [5]

#### Mapped percent 

> "This is a measure of the percentage of total sys- tem memory that is taken up with mapped pages. 
  It is computed as (numbermappedpages)/(totalpages) ∗ 100 " [5]

#### Swappiness ####

- Value defined in `/proc/sys/vm/swappiness`

### `/proc/sys/vm/vfs_cache_pressure`

- Bias on reclaiming inodes and dendrites verse reclamation via swap and pagecache.
- Default 100 provides fair balance between both.
- Reducing value favours reclamation of swap and pagecache.
- Increasing value favours reclamation by flushing inodes and dendrites.

# Theory

## Memory Management Unit (MMU) ##

- Hardware used to provide a Virtual Memory sub-system.
- Map's virtual addresses to physical addresses using page tables.
- Accomplishes this through the use of page tables that eventually (through multiple tables) provide a pointer to the start of a physical page corresponding to the virtual address in RAM.

## Physical Page Creation ##

### Zoned Buddy Allocator ###

- Page allocation management for entire system.

> "Manages lists of physically contiguous pages and maps them into the MMU page tables, so as to provide other kernel
> subsystems with valid physical address ranges within when the kernel requests them (Physical to Virtual Address mapping is handled by a higher layer)" [5]

> "All physical pages in RAM cataloged by buddy allocated and grouped into lists. Each list represents clusters of 2^n pages, where n is incremented in each list" [5]

- e.g. 4k page, objects are 4k (single page cluster), 8k (two page clusters), 16k, 32k etc
- Memory Request:
  1. Request comes in, value rounded to nearest power of two and entry removed from appropriate list.
    - Memory can be wasted due to rounding.
    - i.e. allocation doesn't fit `2^n*PAGE_SIZE`, is rounded up to the next power-of-two boundary.
  2. Registered in page tables of MMU.
  3. Physical address returned to allocator, which is then mapped to a virtual address.

- Manages memory zones which define pools of memory [5]
  1. DMA - First 16 MB RAM, used by legacy devices to perform direct memory operations.
  2. NORMAL - 16 MB to 3.9 GB - Used by kernel for internal data strictures, some other system and userspace allocations.
  3. HIGHMEM - All memory above 3.9 GB, used exclusively for system allocations (e.g. file system buffers, user space allocations etc).

## Allocators ##

### Slab Allocator ###

- Front end to Buddy Allocator.
- i.e. Gets memory in pages from Buddy Allocator.
- Allows kernel components to create caches of memory objects of a given size.

> "The Slab Allocator is responsible for placing as many of the caches objects on a page as possible and monitoring which objects are free and which are allocated." [5]

- Tries to cluster objects on the same type together using small blocks so as to try to avoid fragmentation.
  - i.e. typically objects of the same type normally have similar live times.
- A continuous memory area managed in a cache called a **slab**.
  - Single slab cache can contain multiple slabs.
  - Slab never shared between caches.

## Kernel Threads

### `kswapd` Daemon

> "Periodically scans all `pgdat` data structures in the kernel looking for dirty pages to write out to swap space.
> It does this in an effort to keep the number of free and clean pages above pre-calculated safe thresholds. " [5]

### `pdflush` Daemon

> "Responsible for managing the migration of cached file system data to its backing store on disk
> As system load increases, the effective priority of the `pdflush` daemon likewise increases to continue to keep free memory at safe levels, subject to VM tunables. " [5]

## Caches ##

### Slab Cache ###

- i.e. the cache that utilises the slab allocator.

### Page Cache ###

- Manages cached file data and anonymous memory used by programs.
- This includes:
  - program text+data (minus kernel stuff).
  - file data read/written.
  - filesystem metadata.

## Page States ##

- Taken from [5]

### FREE ###

- Page available for use.
- All pages available for allocation begin in this state.

### ACTIVE ###

- Page that has been allocated from the Buddy Allocator.
- i.e. actively being used by a kernel or user process.

### INACTIVE DIRTY ###

- Fallen into disuse and candidate for removal from main memory.
- `kscand` periodically scans pages incrementing a counter if the page was accessed since `kscand` last visited the page.
  - If the counter reaches 0, page moved to Inactive Dirty State.
- Kept in list of pages to be laundered.

### Inactive Clean ###

- Laundered.
- i.e. contents of page are in sync with the backing data on disk.
- Therefore may be deallocated by VM.






