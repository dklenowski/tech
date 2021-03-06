Categories: programming
Tags: javascript

# Javascript

## Datatypes

### Numbers

- Single number type (64 bit float)

        var i = 1e2 // equivalent to i = 100
        var j = 1.0
        isNaN(j)

### Strings

- 16 bit unicode

        var name = 'dave' // = "dave" is equivalent

#### Concatenation

    var a = "c"
    var b = "a"
    var d = "t"

    var name = c + a + t // === 'cat'


### falsy

Falsy values:
  - `false`
  - `null`
  - `undefined`
  - empty string `''`
  - number `0`
  - number `NaN`

All other values are truthy, including

  - `true`
  - string `false`
  - all objects

 ### Object Literals

- Passed by reference.

        var empty_obj = {};
        var stooge = {
        	"first-name": "dave",
        	"last-name": "klenowski"
        }

- properties name can be any string (including empty str)
- quotes around property name optional privded name is legal javascript name (and not a reserved word).

#### Nesting

	var flight = {
	    airline: "Oceanic",
	    number: 815,
	    departure: {
	        IATA: "SYD",
	        time: "2004-09-22 14:55",
	        city: "Sydney"
		},
		arrival: {
	    	IATA: "LAX",
	    	time: "2004-09-23 10:42",
	    	city: "Los Angeles"
		} };

#### Retreival

	stooge["first-name"]  // Joe
	flight.departure.IATA // SYD

	stooge["middle-name"] // undefined
	flight.status         // undefined

	var middle = stooge["middle-name"] || "(none)"

	flight.equipment        // undefined
	flight.equipment.model  // throw TypeError (i.e. retreiving value from undefined)

#### Update

	stooge['first-name'] = 'eddie';
	stooge['middle-name'] = 'curly';   // object modifed to incldue middle name

#### Delete

	delete stooge['first-name'];

#### Reference

	var x = stooge;
	x.nickname = 'curly';
	var nick = stooge.nickname; // nick = Curly x and stooge reference same object

#### Prototype

- All objects created from object literals linked to `Object.prototype`.
- Prototype link only used in retreival (i.e. if property missing, javascript will try the prototype for the property).

### Reflection

	typeof flight.number   // nnumber
	typeof flight.status   // string
	typeof flight.arrival  // object
	typeof flight.manifest // undefined
 	typeof flight.constructor // 'function'

- For properties, instead use

	 flight.hasOwnProperty('number') // true


## Functions

- Functions are objects.
- Linked to `Function.prototype` (which links to `Object.prototype`).

- Every function created with a `prototype` property.
	- Value is an object with a constructor property.

### Arguments

- `arguments` array available to all functions when invoked.

### Return

- Function always returns a value.
- If return not specifed, then `undefined` return.
- If function invoked with `new` and the return value is not an object, `this` (the new object) is returned instead.


### Methods

- i.e. method invocation pattern

		var myObject = {
		    value: 0,
		    increment: function (inc) {
		         this.value += typeof inc === 'number' ? inc : 1;
		} };
		
		myObject.increment( ); 
		console.log(myObject.value); // 1
		myObject.increment(2);
		console.log(myObject.value); // 3

### Function

- i.e. function invocation pattern
        
        var sum = add(3, 4)

- for this function, `this` is bound to the global object.
  - therefore inner functions dont work because `this` bound to the wrong value.
  - for this, need to use methods (with a workaround)

            // Augment myObject with a double method.
            myObject.double = function () {
            	var that = this; // Workaround.
            	var helper = function () {
            		that.value = add(that.value, that.value);
            	};
            
            	helper(); // Invoke helper as a function.
            };
            	
            // Invoke double as a method.
            myObject.double();
            document.writeln(myObject.getValue()); // 6

## Constructor

- constructor invocation pattern.

        // Create a constructor function called Quo.
        // It makes an object with a status property.
        var Quo = function (string) {
        	this.status = string;
        };
        	
        // Give all instances of Quo a public method
        // called get_status.
        Quo.prototype.get_status = function () {
        	return this.status;
        };
        	 
        // Make an instance of Quo.
        var myQuo = new Quo("confused");
        document.writeln(myQuo.get_status()); // confused

## Function with method

- `apply` method lets us construct array of arguments to invoke a function.

- Case 1:

        var arr = [3 ,4]
        var sum = add.apply(null, array); // sum is 7

- Case 2:

        var statusObject = {
          status: 'A-OK'
        };
           
        // statusObject does not inherit from Quo.prototype,
        // but we can invoke the get_status method on
        // statusObject even though statusObject does not have
        // a get_status method.
        var status = Quo.prototype.get_status.apply(statusObject); // status is 'A-OK'

## Augmenting Functinos

- Changing basic types of language.
- e.g. like adding a method to `Object.prototype`.



