import 'package:flutter/material.dart';
import 'package:giv_flutter/values/colors.dart';

class CustomScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool resizeToAvoidBottomPadding;

  const CustomScaffold(
      {Key key,
      this.appBar,
      this.body,
      this.backgroundColor = CustomColors.backgroundColor,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.resizeToAvoidBottomPadding = true})
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
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomPadding,
    );
  }
}
