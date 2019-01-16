import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/features/home/ui/home_carousel.dart';
import 'package:giv_flutter/features/product/detail/product_detail.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends BaseState<Home> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _homeBloc.fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: string('home_title')),
      body: ContentStreamBuilder(
          stream: _homeBloc.content,
          onHasData: (data) {
            return _buildMainListView(context, data);
          }),
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  ListView _buildMainListView(BuildContext context, HomeContent content) {
    return ListView(
      children: _buildContent(context, content),
    );
  }

  List<Widget> _buildContent(BuildContext context, HomeContent content) {
    final categories = content.productCategories;
    final heroItems = content.heroItems;

    var widgets = <Widget>[
      _buildCarouselContainer(heroItems),
      Spacing.vertical(Dimens.grid(15))
    ];

    categories.forEach((category) {
      widgets.add(_buildSectionHeader(context, category));
      widgets.add(_buildItemList(context, category.products));
    });

    return widgets;
  }

  Widget _buildItemList(BuildContext context, List<Product> products) {
    return Padding(
      padding: EdgeInsets.only(top: Dimens.grid(4), bottom: Dimens.grid(16)),
      child: SizedBox(
        height: Dimens.home_product_image_dimension,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, i) {
            return _buildItem(context, products[i],
                isLastItem: i == products.length - 1);
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Product product,
      {isLastItem = false}) {
    return GestureDetector(
      onTap: () {
        navigation.push(ProductDetail(product: product));
      },
      child: Container(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: isLastItem ? Dimens.default_horizontal_margin : 0.0),
        child: RoundedCorners(
          child: CachedNetworkImage(
            placeholder: RoundedCorners(
              child: Container(
                height: Dimens.home_product_image_dimension,
                width: Dimens.home_product_image_dimension,
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
            ),
            fit: BoxFit.cover,
            width: Dimens.home_product_image_dimension,
            imageUrl: product.imageUrls.first,
          ),
        ),
      ),
    );
  }

  Container _buildSectionHeader(
      BuildContext context, ProductCategory category) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(Dimens.default_horizontal_margin, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Subtitle(
            category.title,
            weight: SyntheticFontWeight.semiBold,
          ),
          SmallFlatPrimaryButton(
            onPressed: () {
              category.goToSubCategoryOrResult(navigation);
            },
            text: string('common_more'),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselContainer(List<CarouselItem> heroItems) {
    final _pageController = PageController();
    return HomeCarousel(
      items: heroItems,
      height: 156.0,
      pageController: _pageController,
      onTap: () {},
      autoAdvance: true,
      loop: true,
    );
  }
}