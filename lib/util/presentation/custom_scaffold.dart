import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;

  const CustomScaffold({
    Key key,
    this.appBar,
    this.body,
    this.backgroundColor = Colors.white,
    this.bottomNavigationBar
  })
      : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
