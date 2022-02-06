import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/search/search.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:provider/provider.dart';

class SearchTeaserAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final String q;

  const SearchTeaserAppBar({Key key, this.leading, this.q}) : super(key: key);

  @override
  _SearchTeaserAppBarState createState() => _SearchTeaserAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + Dimens.app_bar_bottom_border_height);
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
              hintText: widget.q ?? string('search_hint'),
              hintStyle: CustomTypography.titleHint),
          style: CustomTypography.title,
        ),
        GestureDetector(
          onTap: _goToSearch,
          child: Container(
            color: Colors.transparent,
            height: kToolbarHeight,
          ),
        )
      ]),
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      bottom: AppBarBottomBorder(),
    );
  }

  void _goToSearch() => navigation.push(
        Consumer<SearchResultBloc>(
          builder: (context, bloc, child) => Search(
            initialText: widget.q,
            bloc: bloc,
          ),
        ),
        hasAnimation: false,
      );
}
