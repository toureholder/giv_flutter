import 'package:flutter/material.dart';

class AppBarBuilder {
  String title = "";

  AppBarBuilder setTitle(String title) {
    this.title = title;
    return this;
  }

  AppBar build() => AppBar(
    title: new Text(
      this.title,
      style: TextStyle(color: Colors.black87),
    ),
    elevation: 0.0,
  );
}