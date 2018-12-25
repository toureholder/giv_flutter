import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder().build(),
      body: ListView(children: <Widget>[
        _imageCarousel(context, product.imageUrls),
        _textPadding(Text(product.title, style: CustomTypography.headline6)),
        _textPadding(Text(product.location, style: CustomTypography.subtitle2)),
        _iWantItButton(context),
        _textPadding(Text(product.description, style: CustomTypography.body2)),
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
        child: CustomButton.primary(context, text: "EU QUERO", onPressed: (){}),
      );
  }

  Padding _userRow() {
    final user = product.user;
    return Padding(
        padding: EdgeInsets.only(left: Dimens.default_horizontal_margin, right: Dimens.default_horizontal_margin),
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
            Text(
              user.name,
              style: CustomTypography.body2,
            )
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
      onTap: _pushPhotoView,
      withIndicator: true,
    );
  }

  void _pushPhotoView(BuildContext context, String imageUrl) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return PhotoViewPage(imageUrl: imageUrl,);
            })
    );
  }
}
