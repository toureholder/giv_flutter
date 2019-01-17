import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/model/base_page.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/post/post.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/util/presentation/custom_icons_icons.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();

  static String actionIdSearch = 'SEARCH';
  static String actionIdPost = 'POST';
}

class _BaseState extends BaseState<Base> implements HomeListener {
  int _currentIndex = 0;
  List<BasePage> _pages;

  BasePage get _currentPage => _pages[_currentIndex];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _setupPages();

    return CustomScaffold(
      body: _currentPage.child,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToPostPage,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Theme(
      data: ThemeData(primarySwatch: Colors.blue),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: _buildBottomNavigationBarList(),
        onTap: _onTabTapped,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData iconData, String text) {

    final icon = iconData == null ? Container() : Icon(iconData);

    return BottomNavigationBarItem(
        icon: icon,
        title: Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ));
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarList() {
    return _pages.map((BasePage page) {
      return _buildBottomNavigationBarItem(page.icon, page.iconText);
    }).toList();
  }

  void _goToPostPage() {
    navigation.push(Post());
  }

  void _onTabTapped(int index) {
    if (_currentPage?.child == null) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _setupPages() {
    _pages = [
      BasePage(
          child: Home(listener: this),
          icon: CustomIcons.ib_le_house,
          iconText: string('base_page_title_home')),
      BasePage(
          child: Categories(),
          icon: CustomIcons.ib_le_magnifying_glass,
          iconText: string('base_page_title_search')),
      BasePage.empty(),
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

  @override
  void invokeActionById(String actionId) {
    if (actionId == Base.actionIdSearch) {
      _onTabTapped(1);
      return;
    }

    if (actionId == Base.actionIdPost) {
      _goToPostPage();
      return;
    }
  }
}
