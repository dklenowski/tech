Categories: programming
Tags: thread
      java

## References ##

- [1]     Java Cookbook, Second Edition, Safari, 2004.

## Theory ##

### Timeslicing ###

- Each thread receives brief burst (quantum) of time with which the thread can execute.
- The java scheduler ensures several equal high priority threads execute for a 
quantum of time in a round robin fashion.
  - Note, higher priority threads could postpone lower threads execution indefinitely.

### Non Timeslicing

- Each thread in a set of equal priority threads runs to completion 
(unless the thread leaves the running state).

## Basics ##

- Two ways to implement a thread:
  - implement `Runnable`
  - extend the `Thread` class

- Notes:
  - Threads are not necessarily run in the order in which they are created.
  - Order is indeterminate (can adjust using the `Thread.setPriority()` method).

### Using `Thread` class

        public class SimpleThread extends Thread {
          volatile boolean shouldRun;       // false stops thread
             
          public SimpleThread() {
            // initialization 
            shouldRun = true;
          }
          
          public void run() {
            while ( shouldRun ) {
              // threaded code to execute
            }
          }
        }

and to use:

        public class ThreadedApp {
          SimpleThread thr;
          
          public void init() { }
          
          public void start() {
            thr = new SimpleThread();
            thr.start();
          }
          
          public void stop() {
            thr.shouldRun = false;
            thr = null;
          } 
        }

### Using `Runnable` interface

The Runnable interface is defined as:

        public interface Runnable {
          public abstract void run();
        }

A basic implementation consists of 

        public class SimpleThread implements Runnable {
          public void run() {
            // code for thread to execute
          }
        }
        
and to use

        public void ThreadedApp {
          public void init() {
            Runnable runnable = new SimpleThread();
                
            // tie the run() method of the Runnable interface
            // with the Thread class
            
            Thread thr = new Thread(runnable);
            thr.start();
          }
        }

## Stopping a Thread ##

- `Thread.stop()` was originally used, has been deprecated.
- Use a boolean test in the main loop of the `run()` method.

<pre>
        public class SimpleThread extends Thread {
          protected volatile boolean done;
          
          public SimpleThread() {
            ...
            done = false;
          }
          
          public void shutdown() {
            done = true;
          }
          
          public void run() {
            while ( !done ) {
              doSomething();
              try {
                sleep(1000);
              } catch ( InterruptedException ie ) {
                // nothing to do
              }
          }
        }
</pre>


## Implementation  ##

### Thread Start/Stop

#### `start()`

- Performs initialisation and calls `run()`.
- Begins process assigning CPU time to thread resulting in, eventually, 
the threads `run()` method being called.
- Notes:
    - Calling `start()` a thread that has already started causes `IllegalThreadException` to be thrown.
    - If the `start()` method is called after the thread has stopped, nothing happens, the thread is in a state where it cannot be restarted.

#### `run()`

- Must override.
- Code within `run()` will be simultaneously executed with other threads.
- When method returns, thread can never be restarted/reused.
  - i.e. when `run()` method returns, thread terminates.

### Thread States

#### New/Born

- Thread object created, but hasn't been started (therefore cannot run).

#### Ready/Runnable

- Thread's `start()` method called.

#### Running

- Highest priority when thread enters running state.
- System assigns a processor to the thread.
- i.e. the thread begins executing.

#### Blocked

- Something prevents the thread from running (i.e. wont perform any operations).
- e.g. waiting for IO.

#### Sleeping

- i.e. when the `sleep()` method called.
- When called on a running thread, the thread becomes ready after the designated time expires.
- During this time, the thread cannot use the CPU.

#### Waiting

- i.e. when the `wait()` method called.
- When called on a running thread, the thread becomes ready on a call to `notify()` 
issued by another thread associated with that object.
- Every thread in a waiting state for a given object becomes ready on a call to `notifyAll()`.

#### Dead

- Normal way for a thread to die is by returning from its `run()` method.


### Thread Information ###

#### `Thread.currentThread()`

- Returns current thread of execution.

#### `Thread.enumerate(Thread threadArray[])`

- Stores all active threads into an array.
- Thread is removed from the array either when the thread is stopped or the `run()` method has completed.

### Thread Operations ###

#### `sleep(time)`

- Pause a thread.
- Causes current thread (thread that made the call) to sleep for specified period.
- Calling thread placed in blocked state.

#### `isAlive()`

- Thread is alive from sometime before the thread is started (i.e. after calling the `start()`)
to sometime after the thread is actually stopped (i.e. transitional periods).

#### `join()`

- Waits in the `join()` method until the thread has finished executing (died) before returning.
- i.e. can be used to wait for a thread to finish processing up to some point.
- This method returns as soon as the thread is considered "not alive" (i.e. dead)
- Basically accomplishes the same task as the `sleep()` and `isAlive()` methods combined.

#### `wait()`

- Causes a thread to sleep until `notify()` or `notifyAll()` is called.
- e.g. threads that read asynchronous data typically call `wait()`.

#### `notify()`

- Starts all threads that called wait() on the same object
- The writer thread usually calls notify() when the data the reader wants to read is ready.
          
- Old days there was suspend() or resume() methods for threads (now deprecated)
- Must now create own methods:
  - Note cant call the new methods suspend() or resume() because java will complain that you are trying to override deprecated methods.

## Synchronisation and Blocking

### Blocking ###

Typical reasons a thread has been block include:

- The thread has been put to `sleep`.
- `suspend()` method has been called on the thread.
  - Wont resume until the thread gets a `resume()` message.
- `wait()` method has been called on the thread.
  - Wont resume until the `notify()` or `notifyAll()` messages are received.
- Thread is waiting for IO to complete.
- Thread is trying to call a synchronised method on another object, and that objects lock is not available.
- `yield()` method has been called on a thread.

## Thread synchronisation

- Never know when a thread is going to execute (therefore must use synchronisation).
- Using locks:
    a.  First thread that accesses a resource locks it.
  b.  Other threads cannot access that resource until it is unlocked.

### `synchronized()` methods

- Only 1 thread at a time can call a `synchronized` method for a particular object 
(although that thread can call more than one of the objects `synchronized` methods).
- Note, there is a single lock shared by all `synchronized` methods of a particular object.
  - There is also a single lock per class (as part of the Class object for the class) so that `synchronized` static methods can lock each other out from simultaneous access of static data on a class wide basis.
- NOTE: Every method that access a critical shared resource must use synchronised or it wont work.
- To place a lock on a method, use the `synchronized` keyword at the start of the method.

        synchronized void f() {
          // do something
        }

### Critical Sections

- Used to synchronise a block of code.
- Typically used inside a `run()` method to isolate part of the code.
      
        // global object
        static final Object lock = new Object();

        synchronized ( lock ) {
          // single threaded code ..
        }

      
#### Synchronised Object

- The object whose lock is being used to synchronise the enclosed code.
- Before the synchronised block can be entered, the lock must be acquired on Synchronised Object. e.g.

        synchronized ( this ) {
          // do something ..
        }

### Synchronisation Efficiency

- Acquiring a lock multiplies the cost of a method call (i.e. entering and 
exiting from the method, not executing the body of the method) by a minimum of 4 times.


