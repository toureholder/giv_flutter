import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
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

  @override
  void initState() {
    super.initState();
    _product = widget.product;
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
                    navigation.pushReplacement(NewListing(product: widget.product,));
                  },
                )
              ]
            : null,
      ),
      body: ListView(children: <Widget>[
        _imageCarousel(context, _product.images),
        _textPadding(H6Text(_product.title)),
        _textPadding(Subtitle(
          _product.location?.mediumName ?? '',
          weight: SyntheticFontWeight.semiBold,
        )),
        _iWantItButton(context),
        _textPadding(Body2Text(_product.description)),
        Spacing.vertical(Dimens.grid(8)),
        Divider(),
        Spacing.vertical(Dimens.grid(8)),
        _userRow(),
        Spacing.vertical(Dimens.grid(16)),
      ]),
    );
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
            if (user.phoneNumber != null)
              Util.openWhatsApp(
                  '${user.countryCallingCode}${user.phoneNumber}', message);
          }),
    );
  }

  Padding _userRow() {
    final user = _product.user;
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
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
    );
  }
}
