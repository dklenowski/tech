Categories: java
Tags: locks

## Introduction ##

- `ReentrantLock` introduced in Java 5 and provides better throughput (with more threads).

## Convention ##

        lock.lock();
        try {
          // do something
        } finally {
          lock.unlock();
        }

## Deadlocks ##

- Monitor cyclic locking dependency
- Lock cyclic locking dependency
- External resource based dependency
- Live lock

## `ReentrantLock` ##

### fair lock ###

- Threads acquire fair lock in the order in which they are requested.
- Newly requesting thread is queued if the lock is held by another thread or if threads are queued waiting for the lock.

### Non fair lock ###

- Permits *barging*.
- Newly requesting thread is queued only if the lock is currently held.
- In most circumstances, usually faster than fair locks (esp. under contention).

## `synchronized` ##

- aka intrinsic locking
- Explicit (`ReentrantLock`) usually slightly beats intrinsic locks on Java 6.
- Explicit (`ReentrantLock`) usually has dramatic performance improvements over intrinsic locks on Java 5.

## `ReentrantReadWriteLock` ##

- Write lock has a unique owner and can be released only by the thread that acquired it.

