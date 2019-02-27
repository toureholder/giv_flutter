import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/i_want_it_dialog.dart';
import 'package:giv_flutter/features/profile/profile.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final bool isMine;

  const ProductDetail({Key key, this.product, this.isMine = false})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BaseState<ProductDetail> {
  Product _product;
  ProductDetailBloc _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _productDetailBloc = ProductDetailBloc();
    _productDetailBloc.fetchLocationDetails(_product.location);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        actions: widget.isMine
            ? <Widget>[
                MediumFlatPrimaryButton(
                  text: string('common_edit'),
                  onPressed: () {
                    navigation.pushReplacement(NewListing(
                      product: widget.product,
                    ));
                  },
                )
              ]
            : null,
      ),
      body: ListView(children: <Widget>[
        _imageCarousel(context, _product.images),
        _textPadding(H6Text(_product.title)),
        _locationStreamBuilder(),
        _iWantItButton(context),
        _textPadding(Body2Text(_product.description)),
        _publishedAt(),
        Spacing.vertical(Dimens.grid(8)),
        Divider(),
        Spacing.vertical(Dimens.grid(8)),
        _userRow(),
        Spacing.vertical(Dimens.grid(16)),
      ]),
    );
  }

  Padding _publishedAt() {
    return _textPadding(Body2Text(string('published_on_',
        formatArg:
            DateFormat.yMMMMd(localeString).format(_product.updatedAt))));
  }

  Widget _locationStreamBuilder() {
    return StreamBuilder<Location>(
        stream: _productDetailBloc.locationStream,
        builder: (context, AsyncSnapshot snapshot) {
          return _locationWidget(snapshot.data);
        });
  }

  Widget _locationWidget(Location location) {
    if (location?.isOk ?? false) widget.product?.location = location;

    Widget locationWidget = location == null
        ? Padding(
            padding: EdgeInsets.only(
              left: Dimens.default_horizontal_margin,
              right: 200.0,
              top: 29.0,
              bottom: 4.0,
            ),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
              backgroundColor: Colors.grey[100],
            ))
        : _textPadding(Subtitle(
            location?.mediumName ?? '',
            weight: SyntheticFontWeight.semiBold,
          ));

    return locationWidget;
  }

  Widget _iWantItButton(BuildContext context) {
    if (widget.isMine) return Container();

    final user = _product.user;
    final message =
        string('whatsapp_message_interested', formatArg: _product.title);

    return Padding(
      padding: EdgeInsets.all(Dimens.default_horizontal_margin),
      child: PrimaryButton(
          text: string('i_want_it'),
          onPressed: () {
            if (user.phoneNumber != null) _showIWantItDialog(message);
          }),
    );
  }

  Padding _userRow() {
    final user = _product.user;
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: GestureDetector(
        onTap: _goToUserProfile,
        child: Row(
          children: <Widget>[
            AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
            Spacing.horizontal(Dimens.grid(6)),
            Body2Text(user.name)
          ],
        ),
      ),
    );
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

  Widget _imageCarousel(BuildContext context, List<CustomImage.Image> images) {
    final _pageController = PageController();

    final imageUrls = images.map((it) => it.url).toList();

    return ImageCarousel(
      imageUrls: imageUrls,
      height: 300.0,
      pageController: _pageController,
      onTap: () {
        int index = _pageController.page.toInt();
        navigation.push(PhotoViewPage(image: images[index]));
      },
      withIndicator: true,
      isFaded: !_product.isActive,
    );
  }

  _goToUserProfile() {
    navigation.push(UserProfile(
      user: _product.user,
    ));
  }

  _showIWantItDialog(String message) async {
    var isAuthenticated = await Prefs.isAuthenticated();

    final fullPhoneNumber =
        '${_product?.user?.countryCallingCode}${_product?.user?.phoneNumber}';

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return IWantItDialog(
            phoneNumber: fullPhoneNumber,
            message: message,
            isAuthenticated: isAuthenticated,
          );
        });
  }
}
