## Programmatically trigger route

      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NewScreen(_withVar)
          )
      );

## Using custom icons

	..
	icon: Image.asset('icons/vs-18.png'))
	..


## Stateful Widgets

### Maintaining State

- `createState()` is called each time the page is reloaded on screen.
  - i.e. all variables in the `State` class will be reset to the defaults or values set in `initState()`.

		class FirstPage extends StatefulWidget {
		  final String created;
		
		  FirstPage({Key key) : super(key:key);
		
		  @override
		  _FirstPageState createState() => _FirstPageState();
		}
		
		class _FirstPageState extends State<FirstPage> {
		  final String _created = timestamp();

		  @override
		  void initState() {
            // $_created will be recreated on each page refresh, therefore NOT persistent across page reloads.
		    print("State created on $_created");
		    super.initState();
		  }
		  ...



### Stateful Widgets are immutable

- i.e. all variables must be `final`

		class FirstPage extends StatefulWidget {
		  final String created;
		  final ValueChanged<PageStatus> onChanged;
		
		  FirstPage({Key key, @required this.onChanged}) :
		        created = timestamp(),
		        super(key:key);
		
		  @override
		  _FirstPageState createState() => _FirstPageState();
		}
		...


### State Classes

#### `setState`

- To rebuild the widget call `setState`

		// update state variables and then call setState
		setState(() {});

- or

        setState(() {
          // updat the state variables inside setState
          _updated = timestamp();
        });


#### `widget` variable

- You can't access parent `widget` variables in the constructor of the State class.

e.g.

##### Bad

	class FirstPage extends StatefulWidget {
	  final String created = timestamp();
	
	  FirstPage({Key key}) : super(key:key);
	
	  @override
	  _FirstPageState createState() => _FirstPageState();
	}
	
	class _FirstPageState extends State<FirstPage> {
	  _FirstPageState() {
	  	// BAD: widget.created is null
	    print("State created at ${widget.created}");
	  }
	...

##### Good

	class FirstPage extends StatefulWidget {
	  final String created = timestamp();
	
	  FirstPage({Key key}) : super(key:key);
	
	  @override
	  _FirstPageState createState() => _FirstPageState();
	}
	
	class _FirstPageState extends State<FirstPage> {
	  @override
	  void initState() {
	  	// GOOD: Can access widget variables
	    print("Page created on ${widget.created}");
	    super.initState();
	  }


