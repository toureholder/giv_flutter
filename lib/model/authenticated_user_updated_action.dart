import 'package:flutter/material.dart';

class AuthUserUpdatedAction extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
