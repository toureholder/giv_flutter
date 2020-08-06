import 'package:flutter/material.dart';
import 'package:giv_flutter/features/home/ui/home.dart';

class QuickMenuItem {
  final String text;
  final List<Color> colorList;
  final String actionId;

  QuickMenuItem(
      {@required this.text, @required this.colorList, @required this.actionId});

  static List<QuickMenuItem> fakeList() => [
        QuickMenuItem(
            text: 'First menu item',
            colorList: [Colors.red[50], Colors.red[100]],
            actionId: Home.actionIdSearch)
      ];

  static List<QuickMenuItem> fakeListWithOneAction(String actionId) => [
        QuickMenuItem(
            text: 'First menu item',
            colorList: [Colors.red[50], Colors.red[100]],
            actionId: actionId)
      ];

  static List<QuickMenuItem> hardCodedList() => [
        QuickMenuItem(
          text: 'quick_menu_option_join_group',
          colorList: [Colors.blue[50], Colors.blue[100]],
          actionId: Home.actionIdJoinGroup,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_create_listing',
          colorList: [Colors.deepPurple[50], Colors.deepPurple[100]],
          actionId: Home.actionIdPost,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_create_group',
          colorList: [Colors.amber[50], Colors.amber[100]],
          actionId: Home.actionIdCreateGroup,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_browse_listing',
          colorList: [Colors.green[50], Colors.green[100]],
          actionId: Home.actionIdSearch,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_go_to_my_groups',
          colorList: [Colors.red[50], Colors.red[100]],
          actionId: Home.actionIdMyGroups,
        )
      ];
}
