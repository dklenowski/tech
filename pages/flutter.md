## Dependencies

e.g. to add `camera`

1. Edit `pubspec.yaml` and add the dependency.

		dependencies:
		...
			camera:

2. Install

		flutter packages get

3. Use

		import 'package:camera/camera.dart';

## Layouts

### `Center`

- Single child and positions in middle of parent.

### `Container`

Ref: https://medium.com/jlouage/container-de5b0d3ad184

- No child, automatically fill given area, otherwise wrap height/weight of child.
- Should not be rendered without a parent widget (e.g. `Center`, `Column`, `Row` etc)
- Typically used if you need to do some alignment.

## Miscellaneous

### Screen Size

	final Size screenSize = MediaQuery.of(context).size;
	

## Program Structure

### Basic Setup

		void main() => runApp(new MyApp());
		
		class MyApp extends StatelessWidget {
		  @override
		  Widget build(BuildContext context) {
		    return new MaterialApp(title: 'Flutter Demo',
		      theme: new ThemeData(primarySwatch: Colors.blue,),
		      home: new MyHomePage(title: 'Flutter Demo Home Page'),
		    );
		  }
		}
		
		class MyHomePage extends StatefulWidget {
		  MyHomePage({Key key, this.title}) : super(key: key);
		  final String title;
		
		  @override
		  _MyHomePageState createState() => new _MyHomePageState();
		}
		
		class _MyHomePageState extends State<MyHomePage> {
		  int _counter = 0;
		
		  void _incrementCounter() {
		    setState(() {
		      _counter++;
		    });
		  }
		
		  @override
		  Widget build(BuildContext context) {
		    return new Scaffold(
		      appBar: new AppBar(
		        title: new Text(widget.title),
		      ),
		      body: new Center(
		        child: new Column(
		          mainAxisAlignment: MainAxisAlignment.center,
		          children: <Widget>[
		            new Text(
		              'You have pushed the button this many times:',
		            ),
		            new Text(
		              '$_counter',
		              style: Theme.of(context).textTheme.display1,
		            ),
		          ],
		        ),
		      ),
		      floatingActionButton: new FloatingActionButton(
		        onPressed: _incrementCounter,
		        tooltip: 'Increment',
		        child: new Icon(Icons.add),
		      ), // This trailing comma makes auto-formatting nicer for build methods.
		    );
		  }
		}		