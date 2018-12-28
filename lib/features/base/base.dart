import 'package:flutter/material.dart';
import 'package:giv_flutter/features/base/model/base_page.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/search/ui/search.dart';
import 'package:giv_flutter/util/presentation/custom_icons_icons.dart';
import 'package:giv_flutter/util/presentation/themes.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => new _BaseState();
}

class _BaseState extends State<Base> {
  int _currentIndex = 0;

  final List<BasePage> _pages = [
    BasePage(
        child: Home(),
        icon: CustomIcons.ib_le_house,
        iconText: 'Início'),
    BasePage(
        child: Search(),
        icon: CustomIcons.ib_le_magnifying_glass,
        iconText: 'Busca'),
    BasePage(
        child: Home(),
        icon: CustomIcons.ib_b_trust,
        iconText: 'Anunciar'),
    BasePage(
        child: Home(),
        icon: CustomIcons.ib_le_chatv2,
        iconText: 'Mensagens'),
    BasePage(
        child: Home(),
        icon: CustomIcons.ib_b_team,
        iconText: 'Projetos'),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
}
