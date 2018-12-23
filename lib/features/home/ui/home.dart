import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/custom/content_stream_builder.dart';
import 'package:giv_flutter/features/detail/product_detail.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    homeBloc.fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder().setTitle('Início').build(),
      body: ContentStreamBuilder(context,
          stream: homeBloc.content,
          onHasData: _buildMainListView
      ),
    );
  }

  @override
  void dispose() {
    homeBloc.dispose();
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

    categories.forEach((category){
      widgets.add(_buildSectionHeader(context, category.title));
      widgets.add(_buildItemList(context, category.products));
    });

    return widgets;
  }

  Widget _buildItemList(BuildContext context, List<Product> products) {
    return Padding(
      padding: EdgeInsets.only(top: Dimens.grid(4), bottom: Dimens.grid(16)),
      child: SizedBox(
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, i) {
                return _buildItem(context, products[i], isLastItem: i == products.length - 1);
              },
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, Product product, {isLastItem = false}) {
    return GestureDetector(
      onTap: () {
        _pushProductDetail(context, product);
      },
      child: Container(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: isLastItem ? Dimens.default_horizontal_margin : 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 120.0,
              imageUrl: product.imageUrls.first,
          ),
        ),
      ),
    );
  }

  Container _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.default_horizontal_margin, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subhead,
          ),
          FlatButton(
            onPressed: (){},
            child: Text('MAIS'),
          ),
        ],
      ),
    );
  }

  Container _buildSeeMoreComponent() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            )),
        padding: EdgeInsets.fromLTRB(
            Dimens.grid(8),
            Dimens.grid(2),
            Dimens.grid(6),
            Dimens.grid(2)
        ),
        child: Row(
          children: <Widget>[
            Text(
              'MAIS',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
            Spacing.horizontal(1.0),
            Icon(Icons.chevron_right, color: Colors.white, size: Dimens.grid(6),)
          ],
        ),
      );
  }

  Container _buildCarouselContainer(List<CarouselItem> heroItems) {
    return Container(
      child: _buildCarousel(heroItems),
      height: 156.0,
    );
  }

  Carousel _buildCarousel(List<CarouselItem> heroItems) {
    return Carousel(
      children: _buildImageList(heroItems),
      displayDuration: Duration(seconds: 10),
    );
  }

  List<Widget> _buildImageList(List<CarouselItem> heroItems) =>
      heroItems.map((item) => _buildFadeInImage(item.imageUrl)).toList();

  CachedNetworkImage _buildFadeInImage(String url) {
    return CachedNetworkImage(
        placeholder: Image.asset('images/placeholder_home_banner_image.jpg'),
        fit: BoxFit.cover,
        imageUrl: url);
  }

  void _pushProductDetail(BuildContext context, Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetail(product: product);
            })
    );
  }
}
