Categories: java
            jdb
Tags: java
      jdb

## Java Debugger (jdb)

- To examine local (stack) variables, class must be compiled using the ‘-g’ option
- To run:

        # jdb <classname> <arguments>

- Note can also debug across the network using tcp (the interpreter (e.g. appletviewer) must have been started using the -debug option).

        # java - host <hostname> -password <password>


## `jdb` Options

- Add a breakpoint to a method (e.g. to stop in .main)

        stop in <class>.<method>

- Add a breakpoint to a specified line in file.

        stop at <class>:<line>

- Run the program.

        run

- Print arguments passed to the debugger.

        list

- Print methods of a class.

        method <classname>

- View classes (after VM started)

        classes

- Display local variables and their values.

        locals

- Step through a line of code (note a line can be a “{“)

        step

- Executes until the current method returns to the caller.

        step up

- Dumps class info e.g. superclass

        dump <class>

- Dump thread information (where `#` - thread number)

        dump t@#

- Print the class information (e.g. instance info like data members and current class).

        print <class>