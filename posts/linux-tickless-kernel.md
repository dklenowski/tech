Categories: linux
            unix
Tags: kernel
      tickless
      timer
      jiffies

## References ##

- [1]     Getting maximum mileage out of tickless, Suresh Siddha, Venkatesh Pallipadi, Arjan Van De Ven, Intel Open Source Technology Centre

## Overview ##

- Tickless kernel is a kernel without the regular timer tick.

## Measuring ticks ##

        /proc/timer_stats
        /proc/acpi/proessor/CPU*/power

## Implementation Notes ##

- Clock event devices used to schedule next event interrupt.
- Clock event device selection done in hardware.
- Linux kernel provides timers of tick (HZ) based timer resolution.

### `hrtimers` ###

- High Resolution Linux Timers (> `2.6.21`)
- Provides periodic timer ticks (managed by per CPU clockevent device).

> "Hrtimer based periodic tick enabled the functionality of the tickless idle kernel.
> When a CPU goes into idle state, timer framework evaluates the next scheduled timer event
> and in the case that the next event is further away than the next periodic tick, it 
> reprograms the per-CPU clockevent device to this future event. This will allow
> the idle CPU to go into longer idle sleeps without the unnecessary interruption by the periodic tick. " [1]

- Note, using `hrtimer` is not a full tickless or dynamic tick (dyntick) implementation, simply removes the tick during idle states.


### `__round_jiffies()` ###

- Used to reduce number of staggered interrupts.
  - i.e. Timers do not know about other timers.
  - Can result in staggered timers at system level.

- `__round_jiffies()` rounds jiffy timeout to nearest second.
  - For kernel API calls where precision not important.
  - Allows timers to expire at same jiffy, reduces staggered interrupts.

### `deferrabletimers`

> "Timer that works as a normal timer when the processor is active, but will be deferred to a later time when the processor is idle." [1]

- e.g. for `cpufreq ondemand governor`
- Only available for kernel usage.

### Broadcast Timers ###

- Always working timer.
- Shared across a pool of processors.
- Used to wake up any processor in the pool.

> "HPET is superior than PIT, in terms of max timeout value and thus can reduce the number of interrupts when the system is idle." [1]

### Idle Process Load Balancing ###

- In linux kernel, timer ticks also allow each processor to perform load balancing.
  - i.e. to ensure load is distributed across processors in system.
- This periodic load balancing delayed in tickless kernels, performance affected.
- Solution in > `2.6.21`:
  - Nominates an owner among idle CPU's
  - The owner is responsible for the idle load balancing (ILB).
  - Owner has the periodic tick active.

### Noisy Userspace ###

- Userspace can be noisy and can be difficult to achieve a truly idle system.
  - esp. for GUI's (e.g. gnome).
- Work is being done to improve the situation:

> "Instead of polling periodically for checking for status changes, 
> applications and daemons should use some sort of event notification where possible and perform the actions based on the triggered event" [1]
