import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/model/base_page.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/util/presentation/custom_icons_icons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/themes.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => new _BaseState();
}

class _BaseState extends BaseState<Base> {
  int _currentIndex = 0;
  List<BasePage> _pages;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _setupPages();

    return CustomScaffold(
      body: _pages[_currentIndex].child,
      bottomNavigationBar: Themes.ofPrimaryBlue(_buildBottomNavigationBar()),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: _buildBottomNavigationBarList(),
      onTap: onTabTapped,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String text) {
    return BottomNavigationBarItem(
        icon: new Icon(icon),
        title: new Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ));
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarList() {
    return _pages.map((BasePage page) {
      return _buildBottomNavigationBarItem(page.icon, page.iconText);
    }).toList();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _setupPages() {
    _pages = [
      BasePage(
          child: Home(),
          icon: CustomIcons.ib_le_house,
          iconText: string('base_page_title_home')),
      BasePage(
          child: Categories(),
          icon: CustomIcons.ib_le_magnifying_glass,
          iconText: string('base_page_title_search')),
      BasePage(
          child: Home(),
          icon: CustomIcons.ib_b_trust,
          iconText: string('base_page_title_post')),
      BasePage(
          child: Home(),
          icon: CustomIcons.ib_le_chatv2,
          iconText: string('base_page_title_messages')),
      BasePage(
          child: Home(),
          icon: CustomIcons.ib_b_team,
          iconText: string('base_page_title_projects')),
    ];
  }
}
