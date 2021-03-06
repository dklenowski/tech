Categories: perl
Tags: template
      class
      exe

## A new class ##

    [sourcecode language="perl"]
    package Apple;
    use strict;
    use warnings;
    
    our @ISA = qw//;
    our @EXPORT = qw//;
    our @EXPORT_OK = qw//;
    
    sub new {
      my ( $class, $arg ) = @_;
      
      my $self = {};
      $self->{arg} = $arg;
      
      bless $self, $class;
      return $self;
    }
    
    1;
    [/sourcecode]

## An executable ##

    [sourcecode language="perl"]
    use strict;
    use warnings;
    use Getopt::Long ();
    use Log::Log4perl ();
    
    use FindBin;
    use lib "$FindBin::Bin../lib";
    
    #
    # globals
    #
    
    our $xml_log_cfg = "../etc/log4.xml";
    
    #
    # methods
    #
    
    sub usage {
      print <<EOF
    Usage: test.pl [-h|--help]
      
    EOF
    ;
      exit 1;
    }
    
    #
    # main
    #
    
    our ( $opt_h );
    
    Getopt::Long::GetOptions( 'help' => \$opt_h );
    
    Log::Log4perl->init_once($xml_log_cfg);
    $logger = Log::Log4perl->get_logger();
    
    usage() if ( $opt_h );
    
    # do something
    [/sourcecode]

