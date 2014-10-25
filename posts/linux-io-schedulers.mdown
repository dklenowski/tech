Categories: linux
Tags: kernel
      io
      scheduler


### Reference ###

- [1] Linux I/O Schedulers, Hao-Ran Liu
- [2] Linux Block I/O Scheduling ,Aaron Carroll, December 22, 2007.
- [3] [switching-sched.txt](http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/block/switching-sched.txt;hb=HEAD)
- [4] [deadline-sched.txt](http://www.mjmwired.net/kernel/Documentation/block/deadline-iosched.txt)

### Notes ###

- Based on Linux 2.6.
- IO schedulers try to minimise disk seeks.
- Synchronous requests are typically `read` operations.
- Asynchronous requests are typically `write` operations.

         |------------------------| 
         |  |------------------|  |
         |  | ---------------- |  |   -->   Dispatch Queue  --> Device Driver
         |  | | IO Scheduler | |  |                                    |
         |  | ---------------- |  |                                    \/
         |  |     Elevator     |  |                             Block Device
         |  |------------------|  |
         |                        |
         |       Block Layer      |
         |------------------------|
                  /\
                  |
            Request Producer

#### Elevator ####

- Connects scheduler with generic block IO layer via interface exported via scheduler.
- Consists of block layer, the actual elevator, queues and a block device driver.

#### Merging ####

- Joining >= 2 "logically" adjacent requests in the same direction (read or write).
- IO requests "logically" adjacent when end sector one request corresponds to sector immediately before start of next request.
- Front Merge
  - New request before existing adjacent request.
- Back Merge
  - New request after existing adjacent request.

#### Coalescing ####

- If request merged, may be adjacent to another existing request.
- Requests can then be coalesced into a larger request.

### Scheduler Settings ###

- Elevators can be changed online.

#### Determine Current Scheduler ####

        cat /sys/block/<device>/queue/scheduler 
        
        e.g.
        [root@dave ~]# cat /sys/block/sda/queue/scheduler 
        noop anticipatory deadline [cfq]

#### Select a Scheduler ####

      echo SCHEDULER_NAME > /sys/block/<device>/queue/scheduler
      
      e.g.
      [root@dave ~]# echo noop > /sys/block/sda/queue/scheduler 
      [root@dave ~]# cat /sys/block/sda/queue/scheduler 
      [noop] anticipatory deadline cfq

### Scheduler Specific Settings

#### Deadline ####

##### `read_expire`

- Expiry time for read requests (ms).

          /sys/block/<device>/queue/iosched/read_expire
          
          [root@dave ~]# cat /sys/block/sda/queue/iosched/read_expire 
          500

##### `write_expire`

- Expiry time for write requests (ms).

          /sys/block/<device>/queue/iosched/write_expire
          
          [root@dave ~]# cat /sys/block/sda/queue/iosched/write_expire 
          5000

##### `fifo_batch`

- Maximum number of requests per batch.

          /sys/block/<device>/queue/iosched/fifo_batch
          
          [root@dave ~]# cat /sys/block/sda/queue/iosched/fifo_batch 
          16

##### `front_merge`

- Enables front merging.

          /sys/block/<device>/queue/iosched/front_merges
          
          [root@dave ~]# cat /sys/block/sda/queue/iosched/front_merges 
          1

#### Anticipatory ####

##### `read_batch_expire`

- How long to batch synchronous requests before switching to asynchronous batches (ms).

          /sys/block/<device>/queue/iosched/read_batch_expire

          [root@dave ~]# cat /sys/block/sda/queue/iosched/read_batch_expire 
          500

##### `write_batch_expire`

- How long to batch asynchronous requests before switching to synchronous batches (ms).

          /sys/block/<device>/queue/iosched/write_batch_expire

          [root@dave ~]# cat /sys/block/sda/queue/iosched/write_batch_expire 
          125

##### `antic_expire`

- Maximum time to anticipate a synchronous request (ms).

          /sys/block/<device>/queue/iosched/antic_expire

          [root@dave ~]# cat /sys/block/sda/queue/iosched/antic_expire 
          6

#### CFQ ####

##### `quantum`

- Maximum requests per queue to service each round.

          /sys/block/<device>/queue/iosched/quantum

          [root@dave ~]# cat /sys/block/sda/queue/iosched/quantum 
          4

##### `slice_async`

- Base time slice for asynchronous requests.
          
          /sys/block/<device>/queue/iosched/slice_async

          [root@dave ~]# cat /sys/block/sda/queue/iosched/slice_async
          40
          

##### `slice_sync`

- Base time slice for synchronous requests.

          /sys/block/<device>/queue/iosched/slice_sync

          [root@dave ~]# cat /sys/block/sda/queue/iosched/slice_sync 
          100

##### `slice_idle`

- Time to wait for queue to produce more IO requests before switching to new queue.

          /sys/block/<device>/queue/iosched/slice_idle

          [root@dave ~]# cat /sys/block/sda/queue/iosched/slice_idle 
          8



### IO Schedulers

#### NOOP Scheduler ####

- Useful for random access devices (e.g. flash)
- Requests are kept in FIFO.
- Before each request added, a *merge* operation is performed to see if the request can be merged/coalesced into a single large request.

#### Deadline Scheduler ####

- Reorders requires for IO performance and to prevent starvation.
- Favour reads over writes.
- Default expire times for requests:
        Read  500ms
        Write 5s 
- Two queues/lists:
  - Two (read and write) queues:
      - Red-Black Tree.
      - `sort_list`
      - Sorted according to request sector number.
  - Two (read and write) FIFO lists:
      - Doubly linked list.
      - `fifo_list`
- Each request assigned expiry time (deadline), i.e. `read_expire` and `write_expire`.
  - Dictates maximum time request allowed to go unserviced.
  - Soft deadlines.
- Requests pulled from sorted queues.
  - If request in FIFO expires (expiry time lapses), request is expedited.
      - Request processed from sorted queue, but start from first request in FIFO.
- Performs both back-merging (via `sort_list`) and front merging (if `front_merges` parameter enabled).

##### Batching #####

- Requests added to `sort_list` in increasing sector order in batches.
- Batch consists of up to `fifo_batch` contiguous (sector number) requests in same data direction.
- Batch terminated when:
  - No requests in same data direction.
  - Next request not sequential (wrt last request).
  - Current batch has dispatched `fifo_batch` requests.

#### Anticipatory Scheduler ####

- Reorders disk requests to improve seek performance and resource allocation.
- Similar Deadline Scheduler:
  - Sorted and FIFO queues.
  - Front merging.
  - Coalescing.
  - Request deadlines (same parameters as deadline i.e. `read_expire` and `write_expire`).
- Tries to balance expected benefits of waiting for requests for a process (in the same direction) against the cost of keeping the disk idle.
- Suitable for desktop, i.e. good interactive performance.
- Not suitable for RAID devices (assumes a single seeking head).
- Bad for controllers with TCQ (e.g. SCSI [Tagged Command Queuing](http://en.wikipedia.org/wiki/Tagged_Command_Queuing)).
  - Read requests are dispatched one at a time.

##### Batching #####

- Anticipatory Scheduler uses batches i.e. collection of requests in same direction (but not necessarily contiguous).
- Anticipatory Scheduler alternatives between dispatching read and write batches.

##### Anticipation #####

- Overcome *deceptive idleness*.
- Usually a period between when a process issues requests (*think time*).
  - Scheduler usually assumes process has no further requests and services other processes.
- If anticipation likely to occur, Anticipation Scheduler will insert a pause of up to `antic_expire` ms waiting for requests from the process.
  - Only occurs during synchronous (typical `read` requests).
  - If receives the anticipated request, will dispatch it immediately.
  - If a new synchronous request occurs, close than the one anticipated, will also dispatch it immediately.
  - If request anticipated does not arrive, processes the next request.

#### Completely Fair Queueing (CFQ) Scheduler ####

- Tries to provide each process with equal access time to underlying device.
- Can be configured to provide fairness at following levels:
  - Per Process
  - Per Process Group
  - Per User
  - Per User Group
- Each process has associated priority class, which defines the type of service.
- Priority classes:
  1. Real-Time (RT)
  2. Best-Effort (BE)
  3. Idle
- RT and BE further divided into 8 priority levels.
  - *0* - Highest Priority, *8* - Lowest Priority.
- Default is Best-Effort with level derived from `nice` value.

##### Queues #####

- Uses a `cfq_queue`
  - Requests stored in both a sector sorted queue and a FIFO list.
  - Queues serviced based on priority.
- Requests are entered into *service tree* and serviced according to queues priority.

###### Synchronous Requests ######

- Each initiator (process) has its own request queue.
- CFQ services these queues round robin.
- Because each process has own request queue, can apply per-process fairness.

###### Asynchronous Requests ######

- One queue per priority:
  - 8 RT queues
  - 8 BE queues
  - 8 Idle queues
- Shared among all process (therefore cannot apply per-process fairness).
- Writeback performed by `pdflush` kernel threads.
  - Therefore all data writes shared allotted IO bandwidth of `pdflush` threads.



