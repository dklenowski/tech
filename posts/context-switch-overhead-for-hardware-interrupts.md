Categories: unix
            linux
Tags: context switch
      context
      interrupts
      clock
      tick
      fasties
      slowies

## Reference ##

- [1] The Context-Switch Overhead Inflicted by Hardware Interrupts (and the Enigma of Do-Nothing Loops), Dan Tsafrir, IBM T.J. Watson Research Center

## Definition (context switch) ##

- "Any two threads of execution that share the same processor."
- When a hardware interrupt fires:
  - OS suspends current application.
  - Switches to kernel space.
  - Invokes interrupt handler (kernel running in **interrupt context**).
  - Handler terminates.
  - OS restores user context from userspace.

## Clock Interrupts ##

- Utilised through most modern OS's (unix).
- Kernel generates periodic interrupts at fixed intervals (1/2 ms to 15 ms).
- tick
  - Time when interrupt fires.
- tick duration
  - Time between 2 consecutive ticks.
- Tick Handler
  - interrupt invokes kernel routine (i.e. the tick handler).
  - Responsible for:
    - Delivering time services and alarm signals.
    - Accounting for CPU usage.
    - Initiating involuntary preemption.

- e.g. freebsd has a 1000 Hz tick rate and a 100 ms quantum.
  - For a single process, 1000 context switches /sec, preempted by tick handler.

### Tick Overhead ###

- Commonly assumed that tick overhead accounts for 1% of available CPU cycles.
- Does not take into account:
  - Platform
  - Workload
  - Tick frequency
  - type of overhead i.e.
    - direct overhead - time to execute handler.
    - indirect overhead - degradation due to cache state changes.
  - Parallel nature of work

### Direct Overhead ###

#### 1. Trap Time

- Overhead from switch from user to kernel space and back.
- Takes roughly the same number of cycles regardless of the CPU clock speed.
- < 1 microsecond on a Pentium IV 2.2 GHz

#### 2. Tick Handler Duration

- Overhead to process clock interrupt dependent on how the time is obtained.
- i.e. accessing via the Programmable Interrupt Timer (PIT) is faster than accessing the Time-Stamp Cycle Counter (TSC).
- < 1 microsecond on a Pentium IV 2.2 GHz for the PIT.

### Indirect Overhead ###

- Measured by running an application (array sort) at different tick interrupts and measuring the time taken (minus the direct overhead).
- Some of the results (for a Pentium IV 2.2 GHz):

        Number of          Array sort [milliseconds]
        Processors        100 Hz  1 KHz   5 KHz   10 KHz    20 KHz
        1                 10.93   11.01   11.25   11.62     12.26
        2                 10.90   10.98   11.21   11.58     12.16
        4                 10.89   10.98   11.22   11.57     12.15
        8                 10.90   10.97   11.22   11.58     12.16

- Linux 2.4 uses epochs:
  - An old epoch ends and a new ones begins when all runnable (not sleeping) processes in the system exhaust their allocated quantum.
  - When all processes quanta used, kernel declares new epoch and cycles through processes (runnable and sleeping) to renew their quanta.
  - Problem is that scheduler must iterate through all processes to declare a new epoch (a linear renew loop).
    - This linear renew loop can be time consuming.
    - Increasing the multiprogramming level reduces the renew frequency and hence the overall overhead.
    - But the run list traversal becomes longer with each runnable process.
    - i.e. there are 2 contrasting effects: less renew events verses a longer run list.

### Findings ###

- In general, for tick overhead (single threaded or multi threaded):
  - 80% of the overhead is indirect, leaving only 20% direct overhead.
- Overhead is linear:

        $latex f(n)=n(P_{trap}+P_{handler}+P_{indirect)}) $

  - where the coefficients need to be measured for the particular system.

## Parallel Jobs ##

- **noise**
  - Each computation prolonged to the duration of the slowest thread.

- Sporadic OS activity (e.g. long ticks) is amplified on large parallel jobs.
  - e.g. a long tick out of 10000 clock interrupts has a minimal effect on a serial job.
  - a long tick on a job that spans 10000 processors can be an issue.

> "If the delay experienced is due to the fact that the OS is handling some interrupt, the
> resulting slowdown can only be attributed to the indirect overhead of the associated application/interrupt context switch."

### Modelling Noise on Parallel Jobs ###

- Let $latex p $ be the per node probability that some process delayed due to noise, then:

        $latex d_{p}(n)=1-(1-p)^{n} $

  - where:
    - $latex d_{p}(n) $ - probability that job delated within the current computation phase.
    - $latex n $ - the number of nodes.

- For a small enough $latex p $, the following approximation holds:

        $latex d_{p}(n)\approx pn $

- This approximation holds if the following constraint is met:

        $latex d_{p}(n)\leq1-(1-{\displaystyle \frac{1}{10n}})^{n}\approx1-e^{{\textstyle -\frac{1}{10}}}\approx0.1 $

- IF the above constraint is not met:

        $latex d_{p}(n)\approx1-e^{-np} $

- $latex p $ calculated using:

      $latex p=G*Hz $

  - where:
    - $latex G $ - granularity of jobs. i.e. the duration of the compute phase in seconds.
    - $latex Hz $ - The number of interrupts per second.

- i.e. the smaller the granularity ($latex G $), the more significant the slow down.

## Assessing Delays ##

Using a simple `for` loop (with 1000000 iterations) the following observations were made:

- An overhead penalty (indirect+direct) of up to 6-8% was found.
  - This was attributed to cache misses (in L1 and L2).
  - Mostly L1 misses (millions of L1 misses as opposed to thousands of L2 misses).
  - Increasing tick rate increased L1 misses and only marginally affected L2.

- Majority L1 misses due to handler, not benchmark itself.

## Fasties and Slowies ##

### Fasties ###

- Using a simple `for` loop, loop duration had samples that were shorter than baseline.

> "It is possible that the processor occasionally works faster."

- i.e. "fasties" (elusive to track).

### Slowies ###

- The converse to fasties (i.e. slowies) were also found.
- These were not OS specific.

## Conclusions ##

- Interrupts have a large part in the noisiness that was observed.
- Reducing the Hz stabilises the system.
- Cache misses are a factor (up to hundreds per tick), but do not account for all the overall overhead.

> "Indirect overhead inflicted by periodic interrupts are inconclusive and workload dependent."

> "For hardware clock interrupts (ticks), we found the overall impact on an array sorting application is a 0.5-1.5% slowdown at 1000 Hz,
> and exact value is dependent on the process and on whether each tick is slowed down by an external timer chip read or not"

- Overall overhead shown to be:

        $latex overhead(hz)=hz*(P_{trap}+P_{handler}+P_{indirect}) $

 - where:
  - $latex hz $ - tick frequency.
  - $latex P_{trap} $ - time taken to trap the kernel and return.
  - $latex P_{handler} $ - Direct overhead of interrupt handling routine.
  - $latex P_{indirect} $ - Per application indirect overhead due to cache effects.

- For intel processors:

> "The overall overhead is steadily declining."
> "For PIT, the dominant indirect component is steadily growing in relative terms (up to 6 times the direct component), but is declining in absolute terms."
> "For TSC, the overhead is dominated by the direct component (incurred by the slow external read with fixed duration across processor generations)."

