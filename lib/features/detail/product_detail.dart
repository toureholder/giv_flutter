import 'package:flutter/material.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';
import 'package:giv_flutter/util/presentation/dots_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/features/detail/photo_view_page.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder().build(),
      body: ListView(children: <Widget>[
        _carouselWithIndicator(context),
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
                imageUrl: "https://randomuser.me/api/portraits/women/17.jpg",
              ),
            ),
            Spacing.horizontal(Dimens.grid(6)),
            Text(
              'Mariano Angelino',
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

  Stack _carouselWithIndicator(BuildContext context) {
    final _pageController = PageController();
    return new Stack(
      children: <Widget>[
        _imageCarousel(context, _pageController),
        _dotIndicator(_pageController)
      ],
    );
  }

  Container _imageCarousel(BuildContext context, PageController _pageController) {
    return new Container(
        height: 300.0,
        color: Colors.blue,
        child: new PageView(
          controller: _pageController,
          children: _buildImageList(context, product.imageUrls),
        ));
  }

  Positioned _dotIndicator(PageController _pageController) {
    final _kDuration = const Duration(milliseconds: 300);
    final _kCurve = Curves.ease;

    return new Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: new Container(
          color: Colors.grey[800].withOpacity(0.25),
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: new DotsIndicator(
              controller: _pageController,
              itemCount: 5,
              onPageSelected: (int page) {
                _pageController.animateToPage(
                  page,
                  duration: _kDuration,
                  curve: _kCurve,
                );
              },
            ),
          ),
        ));
  }

  List<Widget> _buildImageList(BuildContext context, List<String> imgList) =>
      imgList.map((url) => _buildFadeInImage(context, url)).toList();

  Widget _buildFadeInImage(BuildContext context, String url) {
    return GestureDetector(
      onTap: (){_pushPhotoView(context, url);},
      child: CachedNetworkImage(
          placeholder: Image.asset('images/placeholder_home_banner_image.jpg'),
          fit: BoxFit.cover,
          imageUrl: url),
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
