import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class BasePage {
  final Widget child;
  final IconData icon;
  final String iconText;
  final String actionId;

  BasePage({this.child, this.icon, this.iconText, @required this.actionId});

  BasePage.empty() : child = null, icon = null, iconText = '', actionId = null;
}
