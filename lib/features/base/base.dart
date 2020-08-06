import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/model/base_page.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:provider/provider.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();

  static String actionIdHome = 'HOME';
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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: CustomScaffold(
        body: _currentPage.child,
        floatingActionButton: BasePageFab(onPressed: _goToPostPage),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
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
      IconData iconData, String text, String widgetKey) {
    final icon = iconData == null
        ? Container()
        : Icon(
            iconData,
            key: Key(widgetKey),
          );

    return BottomNavigationBarItem(
        icon: icon,
        title: Text(
          text,
          style: TextStyle(fontSize: 12.0),
        ));
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarList() {
    return _pages.map((BasePage page) {
      return _buildBottomNavigationBarItem(
          page.icon, page.iconText, page.actionId);
    }).toList();
  }

  void _goToPostPage() {
    navigation.push(Consumer<NewListingBloc>(
      builder: (context, bloc, child) => NewListing(
        bloc: bloc,
      ),
    ));
  }

  void _goToSearchPage() {
    int index = _getIndexByActionId(Base.actionIdSearch);
    _onTabTapped(index);
  }

  void _goToHomePage() {
    int index = _getIndexByActionId(Base.actionIdHome);
    _onTabTapped(index);
  }

  void _onTabTapped(int index) {
    if (_pages[index]?.child == null) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _setupPages() {
    _pages = [
      BasePage(
        child: Consumer<HomeBloc>(
          builder: (context, bloc, child) => Home(
            listener: this,
            bloc: bloc,
          ),
        ),
        icon: Icons.home,
        iconText: string('base_page_title_home'),
        actionId: Base.actionIdHome,
      ),
      BasePage.empty(),
      BasePage.empty(),
      BasePage(
        child: Consumer<CategoriesBloc>(
          builder: (context, bloc, child) => Categories(
            bloc: bloc,
          ),
        ),
        icon: Icons.search,
        iconText: string('base_page_title_search'),
        actionId: Base.actionIdSearch,
      ),
    ];
  }

  Future<bool> _onBackPressed() async {
    final homeIndex = _getIndexByActionId(Base.actionIdHome);
    if (_currentIndex != homeIndex) {
      _goToHomePage();
      return false;
    } else {
      return true;
    }
  }

  int _getIndexByActionId(String actionId) =>
      _pages.indexWhere((it) => it.actionId == actionId);

  @override
  void invokeActionById(String actionId) {
    if (actionId == Base.actionIdSearch) {
      _goToSearchPage();
      return;
    }

    if (actionId == Base.actionIdPost) {
      _goToPostPage();
      return;
    }
  }
}

class BasePageFab extends StatelessWidget {
  final VoidCallback onPressed;

  const BasePageFab({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(Icons.add),
      label:
          Text(GetLocalizedStringFunction(context)('shared_action_create_ad')),
    );
  }
}
