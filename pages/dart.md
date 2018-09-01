## Layout

		// Define a function.
		printInteger(int aNumber) {
		  print('The number is $aNumber.'); // Print to console.
		}
		
		// This is where the app starts executing.
		main() {
		  var number = 42; // Declare and initialize a variable.
		  printInteger(number); // Call a function.
		}

## Variables

	var i = 1;
	var s = 'strs';
	String s = 'asdasd';


	var _v = 1;		// '_' means variable is private to library.

### Defaults

- All variables are `null` by default.

		int i;
		assert(i == null);

### Dynamic

- Dont restrict object to specific type.

		dynamic name = 'Bob';


### Final/const

- For variables that dont change.
- Final variable can bet set once.
- Const variable is a compile time constant (implicitly final).

		final name = 'Bob';
		final String name = 'dave';

## Functions

### Fat (`=>`) notation

	isNoble(atomicNumber) {
		return _nobleGases[atomicNumber] != null;
	}

is equivalent to

	bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;

i.e.

	=> is equivalent to { return expr; }

### Optional Parameters

- Either positional, named but not both.

#### Optional Named Parameters

	void enableFlags({bool bold, bool hidden}) {...}
	..
	enableFlags(bold: true, hidden: false);

- Can use `required` keyword to make a named parameter required.

		const Scrollbar({Key key, @required Widget child})

#### Optional Positional Parameters

	String say(String from, String msg, [String device]) {
	  var result = '$from says $msg';
	  if (device != null) {
	    result = '$result with a $device';
	  }
	  return result;
	}
	
	assert(say('Bob', 'Howdy') == 'Bob says Howdy');
	
	assert(say('Bob', 'Howdy', 'smoke signal') ==
	    'Bob says Howdy with a smoke signal');

With constructor syntactic sugar:

	class AuthMessage {
	  String type;
	  String errorMessage;
	  AuthMessage(this.type, [this.errorMessage]);
	}


#### Default Values

- Optional parameters can have default values.
- Nb, old code/implementation used `:` instead of `=` for default parameters.

		void enableFlags({bool bold = false, bool hidden = false}) {...}
		String say(String from, String msg,
    		[String device = 'carrier pigeon', String mood]) {
    		...
    	}


# Classes

	var p = Point(1, 1);

## Constructors

- Constructor names can be either `ClassName` or `ClassName.identifier`.

		Point(this.x, this.y); // syntactic sugar

- Order or execution:
	- initializer list
	- superclass’s no-arg constructor
	- main class’s no-arg constructor


### Named Constructor

	class Point {
	  num x, y;
	
	  Point(this.x, this.y);
	
	  // Named constructor
	  Point.origin() {
	    x = 0;
	    y = 0;
	  }
	}
	..
	var point = Point.origin();


### Initializer Lists

- Initalize instance variables before constructor runs.


		// Initializer list sets instance variables before
		// the constructor body runs.
		Point.fromJson(Map<String, num> json)
		    : x = json['x'], 
		    y = json['y'] {
			print('In Point.fromJson(): ($x, $y)');
		}

### Constructors with named parameters

- Shortcut way to invoke constructors with named parameters.

		class Point {
			num x, y;
		
			Point({this.x=1, this.y=1});
			factory Point.fromJson(Map<String, dynamic> json) {
				return Point(x: json['x'], y: json['y']);
			}
		}
		
		void main() {
			var m = {
		    	'x': 10,
		    	'y': 12
			};
		
			var p1 = Point();
			var p2 = Point.fromJson(m);
			var p3 = Point(x: 11, y: 12);
			var p4 = Point(x: 2);
		}


### Invoke non-default superclass constructor

	class Person {
	  String firstName;
	
	  Person.fromJson(Map data) {
	    print('in Person');
	  }
	}
	
	class Employee extends Person {
	  // Person does not have a default constructor;
	  // you must call super.fromJson(data).
	  Employee.fromJson(Map data) : super.fromJson(data) {
	    print('in Employee');
	  }
	}


### Redirecting constructors

- Body empty, constructor call appears after `:`

		class Point {
			num x, y;
		
			// The main constructor for this class.
			Point(this.x, this.y);
		
			// Delegates to the main constructor.
			Point.alongXAxis(num x) : this(x, 0);
		}


### Constant Constructors


	class ImmutablePoint {
	  static final ImmutablePoint origin =
	      const ImmutablePoint(0, 0);
	
	  final num x, y;
	
	  const ImmutablePoint(this.x, this.y);
	}

### Factory constructor

- Implements constructor that doesn't always create new instance of its class.
- e.g. from cache, or instance of subtype.

		class Logger {
		    final String name;
		    bool mute = false;
		
		    // _cache is library-private, thanks to
		    // the _ in front of its name.
		    static final Map<String, Logger> _cache =
		            <String, Logger>{};
		
		    factory Logger(String name) {
		        if (_cache.containsKey(name)) {
		            return _cache[name];
		        } else {
		            final logger = Logger._internal(name);
		            _cache[name] = logger;
		            return logger;
		        }
		    }
		
		    Logger._internal(this.name);
		
		    void log(String msg) {
		        if (!mute) print(msg);
		    }
		}


## Methods

### Instance Methods

- Can access instance variables and `this`.


		import 'dart:math';
		
		class Point {
			num x, y;
		
			Point(this.x, this.y);
		
			num distanceTo(Point other) {
		    	var dx = x - other.x;
		    	var dy = y - other.y;
		    	return sqrt(dx * dx + dy * dy);
			}
		}


### Getters and Setters

- Each instance variable implied getter and setter.
- Implement additonal using `get` and `set`.
