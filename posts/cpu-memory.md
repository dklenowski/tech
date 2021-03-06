Categories: cpu
            linux
Tags: memory
      uma
      numa

## References ##

[1]   [http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.2/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Non_Uniform_Memory_Access.html](http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_MRG/1.2/html/Realtime_Tuning_Guide/sect-Realtime_Tuning_Guide-Realtime_Specific_Tuning-Non_Uniform_Memory_Access.html)
[2]   [http://msdn.microsoft.com/en-us/library/ms178144.aspx](http://msdn.microsoft.com/en-us/library/ms178144.aspx)
[3]   Non-Uniform Memory Access (NUMA), Nakul Machanda and Karan Anand, New York University.
[4]   [http://lse.sourceforge.net/numa/status/description.html](http://lse.sourceforge.net/numa/status/description.html)
[5]   Cache Organization and Memory Management of the Intel Nehalem Computer Architecture, Trent Rolf, Universift of Utah Computer Engineering, December 2009

## Shared Memory Architecture ##

- All processors share memory.
- 2 main types:
  1. Uniform Memory Access
  2. Non Uniform Memory Access

## UMA ##

- Uniform Memory Access
- All processors connected to memory through a single bus.

## NUMA

- Provides separate memory for each processor/group of processors.
- A "scalable network" interconnects the memory from different processors.
  - Traditional approach was to lock memory access to a single processor (in a multiprocessor system).
- Uses **local** and **remote** memory:
  - Local
    - Memory on the same node as the CPU currently running the process.
  - Remote/foreign
    - Memory that does not belong to the node on which the process is currently running.
- Cache coherence can also be an issue (difficult to synchronise cpu caches).
- Supersedes SMP (Symmetric Multi Processor) where all memory access is posted to the same shared memory bus.

### NUMA Groups

- Also possible for a group of CPU's to have its own memory/IO channels. etc

### Software NUMA ###

- Software NUMA allows software to match memory with CPU's.
- Typically use on a system which has multiple CPU's and no hardware NUMA.

### Hardware NUMA ###

- Have more than 1 system bus, each serving a single/small set of processors.

### Advantages

- Scalability, difficult to synchronise memory access from >12 processors.

### ccNUMA

- Cache Coherent NUMA.
- Synonymous to NUMA, as non-cache coherent NUMA don't really exist.

### Notes ###

- Configuring memory as interleaved in the BIOS turns off NUMA functionality.s
- From [1]
  - `taskset` will not work in NUMA is enabled on the system, instead use `numactl`.
  - NUMA systems have been known to interact badly with realtime applications, as they can introduce unexpected latencies.

## Implementation

### Front Side Bus (FSB)

- Implemented on UMA systems.
- CPU interacts with Memory Controller Hub (MCH) which in turn connects to memory.
- IO hub also connected to MCH.
- MCH can be a bottleneck.

### Quick Path Interconnect (QPI) ###

- Implemented on NUMA systems.
- Memory directly connected to CPU.
- CPU has a memory controller embedded in it.
- CPU's are connected to an IO Hub and to each other as well.

### Translation Lookaside Buffer (TLB)

- TLB located in the processor.
- TLB is a high speed buffer that maps virtual addresses to physical addresses.

> "When a page of memory is mapped to the TLB, it is accessed quickly in the cache" [5]
> "Intel introduced dual-level TLB's in Nehalem architecture (second level has up to 512 entries)" [5]
> "The gains from the TLB are significant, but the most dramatic improvements come from the changes to the overall cache-memory layout." [5]

### Memory Controller

- Newer Intel CPU's (e.g. Nehalem) integrated the memory controller to the processor die.
  - Flexibility is maintained by allowing changes to the size of the controller and the number of channels.

## OS Requirements ##

- Reference [3]
- Need to be able to calculate the NUMA distance (i.e. access time for memory).
- Needs to also provide a mechanism for processor affinity.
- Must use "first touch"

### First Touch ###

- Reference [4]
- i.e. a memory allocation policy.
- User program is allocated memory on the node close to the one containing the CPU on which the process is running.
- Therefore, page faults needs to be processed from the node containing the page-faulting CPU.

> "Because the first CPU to touch the page will be the CPU that faults the page in, this default policy is called "first touch". " [4]

## Cache Coherence ##

### Problem ###

- Processor updates a memory location in its cache, other processors may have copies.
  - Updating main memory alone does not solve the problem.

### Protocols ###

#### MESI ####

- Implemented on older Intel 486 processor.
- See [http://en.wikipedia.org/wiki/MESI_protocol](http://en.wikipedia.org/wiki/MESI_protocol)

#### MESIF ####

- Supersedes MESI.
- Implemented on newer processors e.g. Core i7, Nehalem etc
- The cache line is in one of the five states (see [5] for details):
  - Modified
  - Exclusive
  - Shared
  - Invalid
  - Forward



