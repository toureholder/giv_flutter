import 'package:flutter/material.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/values/colors.dart';

class QuickMenuItem {
  final String text;
  final List<Color> colorList;
  final String actionId;

  QuickMenuItem({
    @required this.text,
    @required this.colorList,
    @required this.actionId,
  });

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
          text: 'quick_menu_option_create_donation',
          colorList: [Colors.blue[100], Colors.blue[200]],
          actionId: Home.actionIdPostDonation,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_create_request',
          colorList: [
            CustomColors.accentColor.withOpacity(0.4),
            Colors.amber[200]
          ],
          actionId: Home.actionIdPostRequest,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_create_group',
          colorList: [Colors.red[100], Colors.red[200]],
          actionId: Home.actionIdCreateGroup,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_join_group',
          colorList: [Colors.green[100], Colors.green[200]],
          actionId: Home.actionIdJoinGroup,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_browse_listing',
          colorList: [Colors.deepPurple[100], Colors.deepPurple[200]],
          actionId: Home.actionIdSearch,
        ),
        QuickMenuItem(
          text: 'quick_menu_option_go_to_my_groups',
          colorList: [Colors.amber[100], Colors.amber[200]],
          actionId: Home.actionIdMyGroups,
        )
      ];
}
