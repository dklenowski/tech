Categories: linux
Tags: perl
      carriage
      windows

    perl -pi -e 'tr/\cM//d;' <filename>
    perl -pi -e 'tr/\r//d;' <filename>