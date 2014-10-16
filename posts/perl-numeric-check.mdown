Categories: perl
Tags: config
      package

Reference [http://www.perl.com/doc/FMTEYEWTK/is_numeric.html](http://www.perl.com/doc/FMTEYEWTK/is_numeric.html)

Since a perl `SCALAR` can be numeric or a string, you must manually check if a `SCALAR` is numeric, i.e.



        #!/usr/bin/perl
        use strict;
        use warnings;
        
        our $debug = 1;
        
        #
        # returns 1 if $i is a number, 0 otherwise.
        #
        sub isnumber {
          no warnings 'numeric';
          my ( $i ) = @_;
        
          if ( $i+0 ne $i ) {
            print "[Debug] - $i is not a number\n" if ( $debug );
            return 0;
          }
        
          print "[Debug] - $i is a number\n" if ( $debug );
          return 1;
        }
        
        
        #
        # testing
        #
        isnumber("");
        isnumber(0);
        isnumber("0");
        isnumber(10);
        isnumber(1.05);
        isnumber(1e10);
        isnumber("a");
        isnumber("foo");
        isnumber("10");


