import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/search/search.dart';

class SearchTeaserAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final String q;

  const SearchTeaserAppBar({
    Key key, this.leading, this.q}) : super(key: key);

  @override
  _SearchTeaserAppBarState createState() => _SearchTeaserAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchTeaserAppBarState extends BaseState<SearchTeaserAppBar> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AppBar(
      leading: widget.leading,
      title:
          Stack(alignment: AlignmentDirectional.centerStart, children: <Widget>[
        TextField(
          decoration: new InputDecoration.collapsed(
              hintText: widget.q ?? string('search_hint')),
          style: Theme.of(context).textTheme.title,
        ),
        GestureDetector(
          onTap: () {
            navigation.push(Search(initialText: widget.q,), hasAnimation: false);
          },
          child: Container(
            color: Colors.transparent,
            height: kToolbarHeight,
          ),
        )
      ]),
      elevation: 0.0,
    );
  }
}
