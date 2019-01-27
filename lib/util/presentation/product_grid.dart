import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/detail/product_detail.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool isMine;

  const ProductGrid({Key key, @required this.products, this.isMine = false})
      : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends BaseState<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: _buildCustomGrid(context, widget.products),
    );
  }

  List<Row> _buildCustomGrid(BuildContext context, List<Product> products) {
    const GRID_COLUMNS = 2;
    var grid = <Row>[];
    var i = 0;
    products.forEach((product) {
      if (grid.isEmpty || grid.last.children.length == GRID_COLUMNS) {
        var isLastItem = (i == products.length - 1) ? true : false;
        grid.add(_newGridRow(context, product, isLastItem: isLastItem));
      } else {
        grid.last.children.add(
          _newGridCell(context, product),
        );
      }
      i++;
    });
    return grid;
  }

  Row _newGridRow(BuildContext context, Product product,
      {bool isLastItem = false}) {
    var row = new Row(
      children: <Widget>[
        _newGridCell(context, product),
      ],
    );

    if (isLastItem) {
      row.children.add(_emptyGridCell());
    }

    return row;
  }

  Expanded _newGridCell(BuildContext context, Product product) {
    return Expanded(
      child: _buildGridCell(context, product),
    );
  }

  Expanded _emptyGridCell() {
    return Expanded(
      child: SizedBox(),
    );
  }

  Widget _buildGridCell(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        _goToProductDetail(product);
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.grid(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            _productImage(product),
            _productTitle(product, context)
          ],
        ),
      ),
    );
  }

  Widget _productTitle(Product product, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Dimens.grid(4)),
      child: Body2Text(product.title),
    );
  }

  Widget _productImage(Product product) {
    return RoundedCorners(
      child: CachedNetworkImage(
          placeholder: RoundedCorners(
            child: Container(
              height: Dimens.home_product_image_dimension,
              width: Dimens.home_product_image_dimension,
              decoration: BoxDecoration(color: Colors.grey[200]),
            ),
          ),
          fit: BoxFit.cover,
          height: Dimens.search_result_image_height,
          imageUrl: product.images.first.url),
    );
  }

  _goToProductDetail (Product product) {
   navigation.push(ProductDetail(
      product: product,
      isMine: widget.isMine,
    ));
  }
}
