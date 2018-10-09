import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: new Text('Hello world')
      ),
    );
  }
}
