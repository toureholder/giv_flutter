import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/product_detail.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;

  const ProductGrid({Key key, @required this.products})
      : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends BaseState<ProductGrid> {
  List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: _buildCustomGrid(context, _products),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
    final foregroundDecoration = product.isActive
        ? null
        : BoxDecoration(color: CustomColors.inActiveForeground);

    return GestureDetector(
      onTap: () {
        _goToProductDetail(product);
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.grid(6)),
        foregroundDecoration: foregroundDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
      child: Body2Text(
        product.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _productImage(Product product) {
    return RoundedCorners(
      child: CachedNetworkImage(
          placeholder: (context, url) => RoundedCorners(
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

  _goToProductDetail(Product product) async {
    final result = await navigation.push(Consumer<ProductDetailBloc>(
      builder: (context, bloc, child) => ProductDetail(
        product: product,
        bloc: bloc,
      ),
    ));

    if (result != null && result is Product) {
      final productIndex = _products.indexWhere((it) => it.id == product.id);
      setState(() {
        _products[productIndex] = result;
      });
    }
  }
}
