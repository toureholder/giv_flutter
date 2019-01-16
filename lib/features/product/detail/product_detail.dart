import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BaseState<ProductDetail> {
  Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(),
      body: ListView(children: <Widget>[
        _imageCarousel(context, product.imageUrls),
        _textPadding(H6Text(product.title)),
        _textPadding(Subtitle(
          product.location,
          weight: SyntheticFontWeight.semiBold,
        )),
        _iWantItButton(context),
        _textPadding(Body2Text(product.description)),
        Spacing.vertical(Dimens.grid(8)),
        Divider(),
        Spacing.vertical(Dimens.grid(8)),
        _userRow(),
        Spacing.vertical(Dimens.grid(16)),
      ]),
    );
  }

  Padding _iWantItButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.default_horizontal_margin),
      child: PrimaryButton(text: string('i_want_it'), onPressed: () {}),
    );
  }

  Padding _userRow() {
    final user = product.user;
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 32.0,
              height: 32.0,
              imageUrl: user.avatarUrl,
            ),
          ),
          Spacing.horizontal(Dimens.grid(6)),
          Body2Text(user.name)
        ],
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

  Widget _imageCarousel(BuildContext context, List<String> imageUrls) {
    final _pageController = PageController();
    return ImageCarousel(
      imageUrls: imageUrls,
      height: 300.0,
      pageController: _pageController,
      onTap: () {
        int index = _pageController.page.toInt();
        navigation.push(PhotoViewPage(imageUrl: imageUrls[index]));
      },
      withIndicator: true,
    );
  }
}
