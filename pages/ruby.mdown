Categories: ruby
Tags: ruby

# Ruby Stuff

## Implementation Notes

### Database Initialisation

  * Because 'rake db:migrate' does not create database, create separate script
(db/create.sql) with:
    * Database drop/create, grants etc.
    * You can then create the db using,

        mysql -u<user> < db/create.sql

  * Edit config/database.yml and set appropriate username/passwords.
  * Run 'rake db:migrate' to create the tables.

## Methods

### puts

  * aka print
  * automatically appends '\n'

e.g.

    puts result + resultStr

  * NB must manually convert numeric datatypes to string if appending to puts
output with "+"

e.g.  

    puts "price=" + tick.price # ERROR
    puts "price=" + tick.price_to_s # OK
    puts tick.price # OK


### nil

  * Instance of class NilClass
  * Default value for
    * instance variable that is not initialized
    * non-existent elements of container/collection
  * NB nil has boolean value of false

e.g.

    nil.to_s === ""
    nil.to_i == 0

  * NOTE: local variables not initialized to anything, not even nil

## Variables

  * Must start with lowercase letter or "_"

### Process

  1. If = on RHS of bareword local variable undergoing assignment.
  2. Checks for keywords.
  3. Otherwise bareword assumed to be a method call.

### Symbols

  * Instances of the built in class Symbol
  * Used to set attributes (i.e. object parameters)
  * Provides a labeling facility, cousin of string (not the same).
  * Immutable.
  * Like globals.

e.g.

    class Ticket
        attr_reader :name, :date, :price
        ..
    end

e.g. creation

    "a".to_sym
    # can now use :a

  * Differences verses strings:
    * Only 1 symbol object can exist for given unit of text
    * Symbols, unlike strings are immutable
    * Faster than strings

### Numbers

  * Ruby converts between number formats automatically.

i.e.

    Numeric -> Float
            -> Integer  -> Fixnum
                        -> Bignum


#### Conversions

    n = 98.6
    m = n.round # m=98
    to_i    # string to integer comparisons


### String

  * Quotes in ruby same as perl
  * Methods: concat, chomp, chop

to_s String to integer downcase lowercase upcase uppercase replace replace
contents of string

e.g.

    str="string one"
    str2='string two'   # escape sequences not evaluated


  * String Comparison str.equal?(str2) # this is an object comparison, not
contents

### Array

  * Methods: push, unshift, pop, concat(t)

e.g.

    a=Array.new(4)          # 4 - size, optimal
    a=[]                    # same as above
    a=[ 1, 2, "there" ]


### Hash

e.g.

    h=Hash.new
    h={}

    state["New York"]="NY"
    state.[]=("New York", "NY")


Notes: - No key, returns nil, except if you init with h=Hash.new(c) which will
return 0.

#### Methods


    puts h[key]         - accessor
    h.empty?            - returns true if h empty
    h.size
    h[key] = val        - setter
    h.store(key, val)   - setter
    h.clear             - remove all elements
    h.has_key?(key)     - getter
    h.key?(key)         - synonym for has_key
    h.has_value?(val)   - value getter
    h.value?(val)       - synonym for has_value


#### Iterating

    h.each_key { |key|
        puts "key=#{key}"
    }


## Loops

### for

    for i in ( 1..10 ) do
        ..
    end

    a = [ 1, 2, 3, 4, 5 ]
    for i in ( 0..(a.length-1) ) do
        ..
    end


### loop/while

    n = 1
    loop do
        n = n+1
        break if n > 9
    end

    n = 1
    while m < 9
        n = n+1
    end


### case

    answer = gets.chomp
    case answer
        when "y", "yes"
            ..
            break
        when "n", "no"
            ..
            break
        else
            puts "unknown op"

    end


## Conditionals

### if

    if <condition> then

    elsif <condition> then

    else

    end

Note, the `then` is optional, i.e. the following would work

    if <condition>
    
    end

### negation

    if not ( x == 1 )
    ..

    if !( x == 1 )
    ..
    unless ( x == 1 )


## Methods

### ! methods

  * Method name that ends with '!'
  * Labels method as 'dangerous', specifically as the dangerous equivalent of
a method without the bang
  * For built in classes, means (not always) that this method, unlike its non-
bang equivalent permanently modifiers its receiver.

#### Non-Bang Version

  * performs action and returns a new object, reflecting the results of the
action.

#### Bang Version

  * Performs action in-place.
  * Instead of creating new object, use original object.
  * e.g. sort/sort!, upcase/upcase!, chomp/chomp!

### Syntax


    def |<classname>|.<method>|(arguments)
        ....
    end


### Return Values

  * Value of last expression evaluated during execution of the method will be returned by default.
  * Can also explicitly specify return value.

e.g.

    def ticket.available?
        false
    end

e.g.

    def ticket.available?
        return false
    end


### ?

  * Indicates that the method will evaluate to true/false.
  * Convention, not explicitly required by Ruby.

### Default Values

  * Optional variables must occur after non-optional variables.

e.g.

    def math(a,b,c=1)

### Sponge

  * Sponge up other arguments and put them into an array.

e.g.

    def math(a,b,*c)

## Class

    Class c
        # initialize - special method called when 'new' invoked
        #
        
        def initialize(value)
            @instance_var = value       # @ - instance variable
        end

        # setter called either <instance>.price(65)
        # or via syntactic sugar <instance>.price = 65

        def price=(amount)
            @price=amount
        end

        # alternative setter
        def set_price(amount)
            @price=amount
        end


e.g. use

    a = new C(10)
    a.price=(20)    # setter
    a.price=20      # alternative way to call setter


### Variable Scope

    @       - instance variable
    $       - Global variable


### Class Method

    class Temp
        def Temp.cf(c)
            ..
        end
    end

    t=Temp.new
    t.cf(10)
    t::cf(10)


### Instance Method

    Ticket#price


### Private Method

    class C
        def initialize
            ...
        end

        def private1
            ...
        end
        private :priv1      # declaration of private method


## Syntactic Sugar

    x=1+2 is equivalent to x=1.+(2)

    def Object
        def+(x)
            ...
        end
    end

### Built In Methods

  * Methods that start with to_ and end with something that indicates a class
to which the method converts an object.

e.g.

    to_s    To String
    to_a    To Array
    to_i    To int
    to_f    To float

## Exceptions

  * Instance of class Exception
  * e.g. RuntimeError, NoMethodError, IOError
  * Use 'rescue' to handle exceptions

e.g.

    print "Enter number:"
    n = gets.to_i
    begin
        result=100/n
    rescue
        puts "Number didn't work, maybe 0?"
        exit
    end


  * To raise an exception use 'raise' method.

e.g.

    def method(x)
        raise ArgumentError, "Require < 10" unless x < 10
        ..
    end

    begin
        method(20)
    rescue ArgumentError
        puts "Unacceptable number"

    end


