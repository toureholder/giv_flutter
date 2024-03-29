import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Widget leading;
  final double titleOpacity;

  const CustomAppBar({
    Key key,
    this.title = "",
    this.actions,
    this.leading,
    this.titleOpacity = 1.0,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends BaseState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AppBar(
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 50),
          opacity: widget.titleOpacity,
          child: Text(
            widget.title,
            style: TextStyle(
              color: CustomColors.appBarTextColor,
            ),
          ),
        ),
        leading: widget.leading,
        elevation: 0.0,
        actions: widget.actions,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        bottom: AppBarBottomBorder());
  }
}

class AppBarBottomBorder extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: Dimens.app_bar_bottom_border_height,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(Dimens.app_bar_bottom_border_height);
}
