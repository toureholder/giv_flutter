import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/model/product/Product.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/features/detail/product_detail.dart';

class Home extends StatelessWidget {
  final List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_o_que_eh_minimalismo.jpg?alt=media&token=dfe0d449-0044-4c9b-88f4-5f9375d94784',
    'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_7_coisas.jpg?alt=media&token=3b17aa2f-feb6-46d0-8ee9-28405dca88d5',
    'https://firebasestorage.googleapis.com/v0/b/pullup-life.appspot.com/o/marketing%2Ftemp_giv%2Fgiv_banner_o_prazer.jpg?alt=media&token=66484516-8339-4569-97cd-62cc1b1c89ba',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder().setTitle('Início').build(),
      body: ListView(
        children: <Widget>[
          _buildCarouselContainer(),
          Spacing.vertical(Dimens.grid(15)),
          _buildSectionHeader(context,  'Perto de você'),
          _buildItemList(context, Product.getMockList(6, prefix: "")),
          _buildSectionHeader(context,  'Livros - Brasília -DF'),
          _buildItemList(context, Product.getMockList(6, prefix: "2")),
          _buildSectionHeader(context,  'Roupas femininas - Brasília -DF'),
          _buildItemList(context, Product.getMockList(6, prefix: "1")),
        ],
      ),
    );
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

  Container _buildCarouselContainer() {
    return Container(
      child: _buildCarousel(),
      height: 156.0,
    );
  }

  Carousel _buildCarousel() {
    return Carousel(
      children: _buildImageList(),
      displayDuration: Duration(seconds: 10),
    );
  }

  List<Widget> _buildImageList() =>
      imgList.map((url) => _buildFadeInImage(url)).toList();

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
