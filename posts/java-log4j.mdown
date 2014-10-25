Categories: java
Tags: log4j
      appender
      logger

## Overview

### Components ###

3 main components:

1. Logger (class)
  - Handles the majority of log operations.

2. Appender (interface)
  - Controls output of log operations.

3. Layout (abstract class)
  - Formatting output for `Appender`.

### Levels ###

        ALL     Lowest (turns on all logging)
        DEBUG
        INFO
        WARN
        ERROR
        FATAL
        OFF     Highest (turns off all logging)

- i.e. a log request of level `p` in a logger with level `q` is logged if `p >= q`.
- e.g. Setting level to `INFO` will log `INFO`, `WARN`, `ERROR`, `FATAL`

### Hierarchy ###

- Ancestor
  - Logger ancestor of another logger if its name is prefix of descendent logger name.
- Parent
  - Logger parent of child logger if no ancestors between itself and descendent logger.
- e.g. Logger `com.foo` parent of `com.foo.bar`
- e.g. Logger `java` parent of `java.util` and ancestor of `java.util.Vector`

#### Creation ####

- A parent logger will find and link to its descendent's automatically.
- Child loggers link to existing ancestors.
- e.g. `com.foo.bar` logger would be linked directly to the root logger if `com.foo` and `com` have not been created.
- Accessed using `Logger.getLogger()`

#### Root Logger ####

- A root logger always exists.
- Accessed using `Logger.getRootLogger()`

## Appender

- Controls where logging is outputted.
- Each enabled logging request for given logger forward to all appenders in that logger as well as appenders higher in the hierarchy.
- Appenders are inherited additively from the logger hierarchy (Note, there is an `additivity` flag that controls whether logging requests are forward up the `Appender` hierarchy).
- e.g. if a `ConsoleAppender` is added to the root logger, all logging requests will at least print on the console.
- e.g. `Appender`'s

        ConsoleAppender
        DailyRollingFileAppender
        FileAppender
        RollingFileAppender
        SMTPAppender
        SocketAppender
        SyslogAppender

## Layout ##

- `Appender` must have an associated layout.
- 3 types of layouts:
  1. `HTMLLayout` - HTML table.
  2. `PatternLayout` - Uses a conversion pattern (default none).
  3. `SimpleLayout` - Logs using the format `level - message`

## Usage ##

### Retrieve the root `Logger` ###

        Logger logger = Logger.getRootLogger();

### Setting the level ###

        Logger.setLevel((Level)Level.WARN);

### Using XML Configuration ###

        String xmlfname = "/tmp/log4j.xml";
        DOMConfigurator.configure(xmlfname);

#### Sample XML Configuration File

        <?xml version="1.0" encoding="UTF-8" ?>
        <!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
        
        <log4j:configuration xmlns:log4j='http://jakarta.apache.org/log4j/'>
        
          <appender name="STDOUT" class="org.apache.log4j.ConsoleAppender">
                   <layout class="org.apache.log4j.PatternLayout">
                     <param name="ConversionPattern"
                     value="%d %-5p  %C{2} (%M:%L) - %m%n"/>
                   </layout>      
          </appender>
          
                <root>
             <priority value ="debug"/>
               <appender-ref ref="STDOUT" />
          </root>
        </log4j:configuration>

### Using Property Files ###

        String propsfname = "/tmp/log4j.props";
        PropertyConfigurator.configure(propsfname);

#### Sample Property File ####

- Set root logger level to DEBUG and its only appender to A1.

        log4j.rootLogger=DEBUG, A1
        # A1 is set to be a ConsoleAppender.
        log4j.appender.A1=org.apache.log4j.ConsoleAppender
        # A1 uses PatternLayout.
        log4j.appender.A1.layout=org.apache.log4j.PatternLayout
        log4j.appender.A1.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n

### Programmatically creating `Appender`'s ###

#### `ConsoleAppender`

- With a default `PatternLayout`.

        ConsoleAppender appender = new ConsoleAppender(new PatternLayout());

#### `FileAppender`

        FileAppender appender = null;
        String fname = "/tmp/test.log";
        boolean append = true;
        
        try {
               appender = new FileAppender(new PatternLayout(), fname, true);
        } catch ( Exception e ) {
          // do something
        }

#### `WriteAppender`

        WriteAppender appender = null;
        String fname = "/tmp/test.log";
        
        try {
          appender = new WriteAppender(new PatternLayout(), new FileOutputStream(fname);
        } catch ( Exception e ) {
          // do something
        }

## Performance ##

### Avoid parameter construction cost ###

- i.e. concatenation, conversion.

Instead of:

      logger.debug(“Entry number: “ + i + “ is “ + String.valueOf(entry[i]));

Use:

      if ( logger.isDebugEnabled() ) {
        logger.debug(“Entry number: “ + i + “ is “ + String.valueOf(entry[i]));
      }

### Create as few `Logger`'s as possible ###

- The decision of whether to log or not consists of walking the `Logger` hierarchy.
- i.e. log4j must compare the levels of all loggers and if the logger has no level must search the ancestors.

