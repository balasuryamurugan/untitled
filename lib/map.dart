import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
class _MyHomePageState extends State<MyHomePage> {
  Position position;

  void _getUserPosition() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    Position userLocation = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      position = userLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    Workmanager.registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: Duration(minutes: 15),
    );
    // this._getUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.position.toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}


const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        Position userLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        break;
    }
    return Future.value(true);
  });
}