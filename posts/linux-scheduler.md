Categories: linux
Tags: scheduler
      process
      thread

## References ##

- [1]     Understanding the Linux 2.6.8.1 CPU Scheduler, Josh Aas, Silicon Graphics , 17/02/2005

## Terms ##

### Program ###

- Instructions + data.

### Process ###

- Instance of a program.
- i.e. running program.
- Can have multiple "threads" of execution.

### Thread ###

- Also called a task.

### Non-Preemptable ###

- < Linux 2.4.x kernel.
- i.e. tasks cannot be resumed immediately (if required).

### Preemptable ###

- > Linux 2.6.x kernel.
- Although there are certain points where kernel cannot be preempted. (e.g. during the `schedule()` scheduler function, the function will turn off preemption).

### Interruptible ###

- Task can wake up prematurely to respond to signals.

### Uninterruptible ###

- Task cannot wake up prematurely.

### CPU Scheduling ###

- Each CPU can only execute one thread of a process at a time.
- Kernel has a scheduler that determines which thread can run.

> "Normally the scheduler runs in its own thread, which is woken up by a timer interrupt. Otherwise, 
> it is invoked via a system call or another kernel thread that wishes to yield the CPU" [1]

> "A thread allowed to execute for a certain amount of time, then a context switch to the scheduler thread will occur,
> followed by another context switch to a thread of the scheduler's choice" [1]

> "Schedulers tend to give IO bound threads priority access to CPU's" [1]


## Linux Processes/Threads ##

> "In linux, all threads are simply processes." [1]
> "A process is a group of threads that share a thread group ID (TGID)." [1]

> "Linux assigns unique PID's to every thread, but the (POSIX) PID is really the tasks TGID." [1]

> "The linux threading model combined with certain tricks like COW (Copy On Write) forking algorithm causes process and thread spawning to be very fast and efficient in Linux." [1]


## Linux Scheduler 2.6 

- Since linux 2.5.x schedulers have been designed to be O(1).

### `runqueue` ###

- `runqueue` created for each CPU to keep track of all runnable tasks (for that CPU).
- Each `runqueue` has 2 priority arrays:
  1. **active priority array** 
    - All tasks begin in this array.
    - Once they have run (i.e. there timeslice has expired) they move to the **expired priority array**.
  2. **expired priority array**
    - Contains all tasks that have used there timeslice for this iteration.

> "When there are no more runnable tasks in the active priority arrays, it is simply swapped with the expired priority array (i.e. a pointer update)." [1]

- Only 1 task can modify a `runqueue` at any given time (e.g. by acquiring a lock).

### Priority Arrays ###

- Array of linked lists (one for each priority level).
- Linux has 140 priority levels.

        // /usr/src/linux-headers-2.6.38-11-server/include/linux/sched.h
        #define MAX_USER_RT_PRIO        100
        #define MAX_RT_PRIO             MAX_USER_RT_PRIO
        
        #define MAX_PRIO                (MAX_RT_PRIO + 40)
        #define DEFAULT_PRIO            (MAX_RT_PRIO + 20)
        

> "Linux always schedules the highest priority task on the system. and if multiple tasks exist at the same priority level, they are scheduled round robin with each other." [1]

- A new timeslice value is calculated for a process when it is moved to the expired process array.

### Static Priority (aka `nice` value) ###

- Static priority, range -20 to 19, default 0.
  - Higher nice values mean the task is given a lower priority.
  - i.e. "Tasks with higher nice values are nicer to other tasks" [1]

> "The scheduler never changes a tasks static priority." [1]

- i.e. static priorities allow the user to change the priority of a process.

### Dynamic Priority ###

> "The linux 2.6.8.1 scheduler rewards IO bound tasks and punishes CPU bound tasks by adding or subtracting from a tasks static priority. This adjustment is called a task's dynamic priority" [1]

> "If a task is interactive (schedulers term for IO bound), its priority is boosted. If it is  CPU hog, it will get a penalty." [1]

> "In the linux 2.6.8.1 scheduler, the maximum priority bonus is 5 and the maximum penalty bonus is 5." [1]

- Uses heuristics to determine dynamic priority (e.g. `sleep_avg` is the primary heuristic).
- Bonuses/penalties are not given to RT processes.
- Calculated using `effective_prio()`.


#### `sleep_avg`

> "When a task is woken up from sleep, its total sleep time is added to is sleep_avg.
> When a task gives up the CPU, voluntarily or involuntary,the time the current task spent running is subtracted from its `sleep_avg`." [1]

- `sleep_avg` cannot exceed `MAX_SLEEP_AVG`.

> "The higher a tasks `sleep_avg`, the higher its dynamic priority will be." [1]

### Timeslice ###

- Scales tasks static priority to a range of timeslice values.
- Timeslice called using `task_timeslice()` which is a call to the following macro:

        # define BASE_TIMESLICE(p) 
          (MIN_TIMESLICE + 
          ((MAX_TIMESLICE - MIN_TIMESLICE) * (MAX_PRIO-1 - (p)->static_prio) / (MAX_USER_PRIO-1)))  

- Note, that a processes timeslice does not have to be filled at once, can be broken into chunks of `TIMESLICE_GRANULARITY`.

> "The function `scheduler_tick()` checks to see if the currently running tasks has been taking the CPU from other tasks of the same dynamic priority for too long (`TIMESLICE_GRANULARITY`).
> If a tasks has been running for `TIMESLICE_GRANULARITY` and the task of the same dynamic priority exists, a round robin switch between other tasks of the same dynamic priority is made" [1]

> "Every 1 ms, a timer interrupt calls `scheduler_tick()`. If a tasks has run out of timeslice, it is normally given a new timeslice and put on the expired priority array for its runqueue. However `scheduler_tick()` will reinsert interactive tasks into the active priority array with their new timeslice so long as nothing is starving in expired priority array." [1]

### Interactivity Credit ###

> "Tasks get an interactive credit (`interactive_credit`) when they sleep for a long time, and lose an interactive credit when they run for a long time." [1]

#### High Interactivity ####

- > 100 interactivity credits.
- Less time subtracted from `sleep_avg`.

#### Low Interactivity ####

- < -100 interactivity credits.
- Limited in their `sleep_avg`.

## `waitqueue`

- Tasks that are waiting for an event to occur.

> "Sleeping tasks are added to `waitqueue`'s before going to sleep in order to be woken up when the event they are waiting for occurs" [1]

- Function `try_to_wake_up()` inside scheduler called and periodically checks to see if each task in the `waitqueue` can be added back to the `runqueue`.

## `schedule()`

- Main scheduler function.
- Picks the new task to run and performs a context switch to the new task.
- Called when:
  1. Task wishes to give up the CPU voluntarily (e.g. `sys_sched_yield()`).
  2. "`scheduler_tick()` sets the `TIF_NEED_RESCHED` flag on a tasks because it has run out of timeslice" [1]

### `scheduler_tick()`

> "`scheduler_tick()` function called during every system time tick, via a clock interrupt.
> It checks the state of the currently running tasks, and other tasks in a CPU's `runqueue` to see if scheduling and load balancing is necessary" [1]

### Load Balancing ###

- Load balancing performed via `rebalance_tick()` (note, this function also calculates the `cpu_load`).
- Responsible for moving tasks (via `move_tasks()` between CPU's).

#### Migration Threads

> "Every CPU has migration thread, which is a kernel thread that runs at a high priority and makes sure that `runqueue`'s are balanced." [1]

## Soft RT Scheduling

- "soft" - i.e. does not guarantee scheduling requirements will be met.

> "RT tasks have priorities 0 to 99 while non-RT takes priorities map onto the internal priority range 100-140.
> Because RT tasks have lower priorities than non-RT tasks, they will always preempt non-RT tasks.
> As long as RT tasks are runnable, no other tasks can run because RT tasks operate with different scheduling schemes. " [1]

### `SCHED_FIFO`

- RT scheduling algorithm using First In First Out semantics.
- Don't have timeslices.
- Scheduled by priority.

### `SCHED_RR`

- RT scheduling algorithm using Round Robin semantics.
- Have timeslices, always pre-empted by `SCHED_FIFO` tasks.
- Scheduled by priority.

## Scheduler Tuning ##

- Macros in `kernel/sched.c`

### `MIN_TIMESLICE`

- Minimum timeslice a task can receive.

### `MAX_TIMESLICE`

- Maximum timeslice a task can receive.

### Notes on `MIN_TIMESLICE` and `MAX_TIMESLICE` ###

- Increasing timeslice can improve performance since less context switches.

> "However, since IO bound tasks tend to have higher dynamic priorities than CPU bound tasks, interactive tasks are likely to preempt other tasks  no matter how long their timeslices are; that means that interactivity suffers a bit less from long timeslices." [1]

### `PRIO_BONUS_RATIO`

> "This is the middle percentage of the total priority range that tasks can receive as a bonus or a punishment in dynamic priority calculations.
> By default the value is 25, so tasks can move up 25% or down 25% from the middle value of 0." [1]

- Setting high, `nice()` has less effect (since priority calculations are based on the higher dynamic priority rewards).
- Setting low, `nice()` has more effect.


### `MAX_SLEEP_AVG`

> "The longer `MAX_SLEEP_AVG` gets, the longer tasks will need to sleep in order to be considered active." [1]

### `STARVATION_LIMIT`

> "If another task has not run for longer than `STARVATION_LIMIT` specifies, then interactive tasks stop running in order for the starving tasks to get CPU time." [1]



