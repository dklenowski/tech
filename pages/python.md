Categories: python
Tags: python


# Python Basics

## Args

    def save(self, *args, **kwargs):
        if 'index' in kwargs:
            to_index = kwargs.pop('index')
           
         super(Obj, self).save(*args, **kwargs)


## Miscellaneous ##

### Printing a string/int combination ###

      [sourcecode language="python"]
      print "String=" + str + " Length=" + str(len(str))
      [/sourcecode]

## Regular Expressions ##

- You need to escape `\` in string literals that are parsed to `re`
- Or use raw strings, e.g. from  [http://docs.python.org/howto/regex.html](http://docs.python.org/howto/regex.html).


        Regular String  Raw string
        "ab*"           r"ab*"
        "\\\\section"   r"\\section"
        "\\w+\\s+\\1"   r"\w+\s+\1"

- Examples:

        [sourcecode language="python"]
        if not re.search(r"\.tar.gz$", fname):
          print "File %s is not a tar'ed gzip!"
        [/sourcecode]

## Notes

- The null variable is `None`


## Dictionary ##

### Miscellaneous ###

      [sourcecode language="python"]
      # length
      len(d)
      [/sourcecode]

### Initialisation ###

      [sourcecode language="python"]
      d = {}
      [/sourcecode]

### Looping ###

      [sourcecode language="python"]
      for key in d:
        # do something with d[key]
      [/sourcecode]

### Key Existence ###

      [sourcecode language="python"]
      if key in d:
        # do something with d[key]
      ..
      try:
        d[key] += 1
      except KeyError:
        # key does not exist in d, must create
        d[key] = 0
      [/sourcecode]

## String ##

### Miscellaneous ###

      [sourcecode language="python"]
      # splitting a triple quote string
      lines = str.split('\n')

      # splitting a line
      import shlex
      flds = shlex.split(line)
      [/sourcecode]

### Appending ###

      [sourcecode language="python"]
      base_dir="/tmp"
      log_file=base_dir + "/test.log"
      [/sourcecode]

or

      [sourcecode language="python"]
      base_dir="/tmp"
      log_file="%s/tmp" % base_dir
      [/sourcecode]

### File Routines ###

    [sourcecode language="python"]
    import shutil

    src = os.path.join("some", "path")
    dst = os.path.join("some", "other", "path")

    try:
      shutil.copyfile(src, dst)
    except Exception, e:
      print str(e)
    [/sourcecode]

### Read lines from file

    [sourcecode language="python"]
    with open('myfile', 'r') as inp:
      for line in inp:
        doSomething(line)

### Recursively search a directory ###

    [sourcecode language="python"]
    import os

    p = os.path.join("some", "path")
    for root, dirs, files in os.walk(p):
      for name in files:
        abspath = os.path.join(root, name)
        print "File Name=%s abspath=%s" % ( name, abspath)
    [/sourcecode]

## Naming Convention

http://code.google.com/p/soc/wiki/PythonStyleGuide#Naming

## Main

        [sourcecode language="python"]
        if __name__ == '__main__': main()
        [/sourcecode]

## DocString

- Use either triple single quotes or triple double quotes (http://www.python.org/dev/peps/pep-0257/).
- Both serve same purpose, so more convention.


        [sourcecode language="python"]
        def function():
          '''
          A function that does something
          '''
        [/sourcecode]


- Note, Python does not support docstring's on variables.
  - Have to use an external docstring generators e.g. http://epydoc.sourceforge.net/manual-docstring.html supports docstring for variable names.
  - e.g. using epydoc:


        [sourcecode language="python"]
        #: docstring for x
        x = 22
        y = 22 #: docstring for y
        [/sourcecode]

## Strings

- Ref: http://wiki.python.org/moin/PythonSpeed/PerformanceTips#StringConcatenation
- Avoid:

        [sourcecode language="python"]
        out = "" + head + prologue + query + tail + ""
        [/sourcecode]

- Instead, use:

        [sourcecode language="python"]
        out = "%s%s%s%s" % (head, prologue, query, tail)
        [/sourcecode]

## Globals

- To modify a global variable (say for a script that simply run's the `main` method, you need to use the `global` keyword.

        [sourcecode language="python"]
        #
        # globals
        #
        default_pass = ""

        def f():
          global default_pass
          if default_pass == "":
            default_pass = "testing"

        def main():
          f()

        if __name__ == "__main__"
          main()
        [/sourcecode]

## Getopt

        [sourcecode language="python"]
        import getopt

        try:
          opts, args = getopt.getopt(sys.argv[1:], 'a:r:g:s')
        except getopt.GetoptError, err:
          print str(err)
          usage()

        for opt, arg in opts:
          if opt == 'a':
            argval = arg
          elif ..:
          elif ..:
          else:
        [/sourcecode]

## enums

Python has no "enum" construct, instead uses classes:

        [sourcecode language="python"]
        class ConnectionType:
          SSH, TELNET = range(2)

        if <conditional>:
          cType = ConnectionType.TELNET
        [/sourcecode]

## Logging

        [sourcecode language="python"]
        import logging
        ..
        LOG = logging.getLogger("<logging_realm>")
        ...
        logging.basicConfig(format = "%(asctime)s: [%(levelname)s] - %(message)s")
        LOG.setLevel(logging.DEBUG)

        LOG.debug("debug message")
        LOG.warn("warn message")
        LOG.critical("critical message")
        [/sourcecode]

## Exceptions

Standard Exceptions: http://docs.python.org/library/exceptions.html

# Template

        [sourcecode language="python"]
        #!/usr/bin/env python
        # encoding: utf-8
        """
        Sample layout
        """

        import sys
        import getopt
        import logging
        import os

        ##
        # constants
        ##

        LOG = logging.getLogger("sample");

        HELP_MSG = """
          A help message.
        """

        ##
        # classes
        ##

        """
        Generic Usage exception.
        """
        class Usage(Exception):
          def __init__(self, msg):
            self.msg = msg

        """
        Stores configuration information for the script.
        """
        class Config:
          # default config file
          cfg_file = '/tmp/test.txt'

          @staticmethod
          def validate():
            if not os.path.exists(Config.cfg_file):
              raise ConfigException("Main configuration file %s does not exist?" % Config.cfg_file)

        """
        An exception for Config.validate()
        """
        class ConfigException(Exception):
          def __init__(self, msg):
            self.msg = msg


        """
        A class used like an enum
        """
        class Op:
          LOCK, UNLOCK = range(2)

          @staticmethod
          def str(value):
            if value == RepoOp.LOCK:
              return "lock"
            elif value == RepoOp.UNLOCK:
              return "unlock"

        ##
        # main methods
        ##

        """
        Do something
        """
        def doSomething():
          print "I am doing something"

        """
        Main.
        """
        def main(argv=None):
          if argv is None:
            argv = sys.argv

          logging.basicConfig(format = "%(asctime)s: [%(levelname)s] - %(message)s")
          LOG.setLevel(logging.DEBUG)

          try:
            try:
              opts, args = getopt.getopt(argv[1:], "ho:", [ "help", "output=o" ])
            except getopt.error, msg:
              raise Usage(msg)
              return 1

            if len(opts) == 0:
              # must have at least 1 command line argument
              raise Usage(HELP_MSG)

            for option, value in opts:
              if option in ("-h", "--help"):
                raise Usage(HELP_MSG)

          except Usage, err:
            print str(err.msg)
            return 1

          # do something
          return 0

          #
          # main
          #
          if __name__ == "__main__":
            sys.exit(main())
        [/sourcecode]

