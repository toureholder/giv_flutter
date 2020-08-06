import 'package:flutter/material.dart';
import 'package:giv_flutter/model/group/group.dart';

class GroupUpdatedAction extends ChangeNotifier {
  Group _group;

  Group get group => _group;

  void setGroup(Group group) {
    _group = group;
    notifyListeners();
  }
}
