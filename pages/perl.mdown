Categories: perl
Tags: perl

## Miscellaneous

## Data Types ##

- Perl has 3 fundamental data types:

### Scalar ###

- Represents either a number, string or a reference.

### Array ###

- Represents an ordered collection of scalars.

### Hash ###

- Represents a collection of key, value pairs of scalars.


### Special Literals ###

      print "File=" . __FILE__ . "\n"
      print "Line=" . __LINE__ . "\n"
      print "Package=" . __PACKAGE__ . "\n"

### Arrays ###

      my @a = ();
      my @a = (1, 2, 3);
      
      # for array references (anonymous arrays)
      my $ra = [];
      my $ra = [1, "hello"];

### Hashes ###

      my %h = ();
      my %h = ( key1 => "value1", key2 => "value2" );
      
      # for hash references (anonymous hashes)
      my $h = {};
      my $h = { key1 => "value1", key2 => "value2" };


#### `exists()`

- Checks whether the key exists, does not check whether the value exists (i.e. is defined).

        my %h = ( 'a' => undef, 'b' => 0, 'c' => 1 );
        print "a exists\n" if ( exists($h{'a'}) ); # prints "a exists\n"
        print "b exists\n" if ( exists($h{'b'}) ); # prints "b exists\n"
        print "c exists\n" if ( exists($h{'c'}) ); # prints "c exists\n"
        print "d exists\n" if ( exists($h{'d'}) ); # prints nothing

#### `defined()`

- Checks both whether the key exists and the value exists (i.e. is defined).

        my %h = ( 'a' => undef, 'b' => 0, 'c' => 1 );
        print "a defined\n" if ( defined($h{'a'}) ); # prints nothing
        print "b defined\n" if ( defined($h{'b'}) ); # prints "b defined\n"
        print "c defined\n" if ( defined($h{'c'}) ); # prints "c defined\n"
        print "d defined\n" if ( defined($h{'d'}) ); # prints nothing

#### conditional check

- Checks both key exists and the value is defined.
- If the key exists, performs a conditional `if` check on the value (i.e. a value of `0` will be `false`).

        my %h = ( 'a' => undef, 'b' => 0, 'c' => 1 );
        print "a true\n" if ( $h{'a'} ); # prints nothing
        print "b true\n" if ( $h{'b'} ); # prints nothing
        print "c true\n" if ( $h{'c'} ); # prints "c true\n"
        print "d true\n" if ( $h{'d'} ); # prints nothing

## References ##

- A reference is an ordinary scalar.
- Perl does not automatically dereference, you must explicitly dereference.

        my $a = "testing";
        my $ref = \$a;
        $$ref++;

        my @a = (10, 20);
        my $refa = \@array;
        $$refa[0] = 20;
        $refa->[0] = 20;

        my %h = ( "jerry" => "seinfeld" );
        my $refh = \%h;
        $$refh{"cosmo"} = "kramer";
        $refh->{"cosmo"} = "kramer";

- To query a reference:

        my $a = 10; 
        my $refa = \$a;
        # ref($a) is FALSE
        # ref($refa) returns "SCALAR"

### Symbolic References ###

- Only work for global variables (i.e. not `my`).

        our $x = 10;
        $var = "x";
        $$var = 30;   # modifies $x to 30

- To turn off:

        use strict 'refs';

## Variables ##

### Global Variables

- Stored in symbol table (i.e. hashtable internally).
  - One symbol table per package.
- Uses typeglobs to separate duplicate variable names.

### Lexical `my` Variables

- Are not listed in symbol table.
- Listed in scratchpad for block.

### Constants

- Use typeglobs to create a scalar reference to a typeglob (i.e. a selective reference as the other forms (non scalar) are not referenced.)

        
        # declare constants so strict checking is happy
        our $PI;
        
        # now define our constants
        *PI = \3.14;


## Objects

### Notation ###

- `::` notation
  - Perl figures out the class at run time.

- `->` notation
  - Faster, because the function to be called is known at compile time.


### Creating Object references

        package Something;
        
        use strict;
        use warnings;
        
        use Exporter ();
        our @ISA = qw/Exporter/;
        our @EXPORTOK = qw//;
        
        sub new {
          my ( $class ) = @_;
          
          my $self = {};
          $self->{logger} = Log::Log4perl->get_logger();
          
          bless($self, $class);
          return $self;
        }

### Subroutines/Methods ###

- 2 ways to call method for package
  - `Bug::print("a message")`
    - `print` treated as regular subroutine.
    - Argument list contains `("a message")`.
  - `$bug>print("a message")`
    - `print` treated as a method so argument list contains `($ref, "a message")`
    - i.e. a reference to the object is passed as the first parameter.
- Because `$ref` is passed as a method, subroutines/methods usually written as:

        package Bug;
        
        sub print {
          my ( $self, @args ) = @_;

          # NB good to lexically scope argument list @_ with @args
          # since changing element of @_ actually changes callers version  
          # of corresponding argument.

          ..
        }


#### Instance Methods

- Implementation:

        package Employee;

        sub new { 
          ...
        }

        sub calculateSalary {
          my ( $self ) = @_;
          return $self->{baseSalary} + $self->{superContributions};
        }

- Use arrow notation to access instance methods, i.e.:

        my $emp = Employee->new();
        my $salary = $emp->calculateSalary();

- In general use:

        $objref->method(@args);

- Note, use `ref` to determine what class the variable belongs to, e.g.:

        print "Variable is a " . ref($objref) . "\n";


#### Static Methods

- Use dotted notation, i.e.

            my $isValidId = Employee::validId($id);

### Inheritance

#### `@ISA`

- Specifies list of modules.
- When perl does not find a particular class or instance method in module, looks to see if the module is in `@ISA`.
- IF so, checks to see any module supports the missing function, picking the first one it can find and passing control to it.

        package Config;

        sub new {
          sub ( $class ) = @_;
          
          my $self = {};
          $self->{logger} = Log::Log4perl->get_logger();

          bless($self, $class);
          return $self;
        }

        package BranchConfig;

        use base qw( Config );

        sub new {
          my ( $class ) = @_;

          my $self = $class->SUPER::new();
          $self->{op} = "branch";
          
          bless($self, $class);
          return $self;
        }


- Note:

        use base qw(Foo Bar);

- is (roughly) equivalent to:

        BEGIN { 
          require Foo; 
          require Bar; 
          push @ISA, qw(Foo Bar); 
        }

#### `SUPER`

- Causes perl to search for the method in the `@ISA`, e.g.

        $objref->SUPER::doSomething();

- which will cause perl to search the `@ISA` hierarchy for the appropriate `doSomething()` subroutine.

#### `DESTROY`

- Perl automatically garbage collects a data structure when its reference count drops to zero.
- If a data structure has been blessed into a module, perl allows that module to perform some clean up before it destroys the object by calling the `DESTROY` with a reference to the object that is being destroyed as an argument.

        package Employee;

        sub DESTROY {
          my ( $self ) = @_;
          ..
        }

- Note, don't have to provide a `DESTROY` method.
  - But if you don't, and `AUTOLOAD` defined (called when function not found), must perform a check to ensure the `DESTROY` method is not propagated. i.e.

            sub AUTOLOAD {
              my $ref = $_[0];
            
              # $AUTOLOAD contains the name of the missing method
              # don't propagate DESTROY methods
              return if $AUTOLOAD =~ /::DESTROY/;
              ..
            }



