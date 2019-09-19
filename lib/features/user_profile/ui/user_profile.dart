import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  final User user;
  final UserProfileBloc bloc;

  const UserProfile({Key key, @required this.bloc, this.user})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends BaseState<UserProfile> {
  User _user;
  UserProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _profileBloc = widget.bloc;
    _profileBloc.fetchUserProducts(_user.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(),
      body: _mainListView(),
    );
  }

  ListView _mainListView() {
    return ListView(
      children: <Widget>[
        _avatar(),
        _name(),
        _bio(),
        _userSince(),
        Spacing.vertical(Dimens.default_vertical_margin),
        Divider(),
        _productGridStreamBuilder(),
        Spacing.vertical(Dimens.default_vertical_margin),
      ],
    );
  }

  ContentStreamBuilder<List<Product>> _productGridStreamBuilder() {
    return ContentStreamBuilder(
      stream: _profileBloc.productsStream,
      onHasData: (List<Product> data) {
        return _productGrid(data);
      },
    );
  }

  Padding _name() => _textPadding(H6Text(
        _user.name,
        textAlign: TextAlign.center,
      ));

  Widget _userSince() {
    if (_user.createdAt == null) return Container();
    final text = string('member_since_',
        formatArg: DateFormat.yMMMM(localeString).format(_user.createdAt));
    return _textPadding(Body2Text(
      text,
      textAlign: TextAlign.center,
    ));
  }

  Widget _bio() {
    if (_user.bio == null) return Container();
    return _textPadding(Body2Text(
      _user.bio,
      textAlign: TextAlign.center,
    ));
  }

  Widget _avatar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AvatarImage(
              image: CustomImage.Image(url: _user.avatarUrl),
              width: 154.0,
              height: 154.0),
        ],
      ),
    );
  }

  Widget _productGrid(List<Product> products) {
    return products.isNotEmpty ? ProductGrid(products: products) : Container();
  }

  Padding _textPadding(Widget widget) {
    return Padding(
      padding: EdgeInsets.only(
          top: Dimens.default_vertical_margin,
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: widget,
    );
  }
}
