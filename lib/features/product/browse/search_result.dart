import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/detail/product_detail.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';


class SearchResult extends StatefulWidget {
  final ProductCategory category;

  const SearchResult({Key key, this.category}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends BaseState<SearchResult> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBarBuilder().setTitle(widget.category.title).build(),
        body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.grid(4),
              vertical: Dimens.grid(8)) ,
          children: _buildResultsGrid(context),
        ));
  }

  List<Widget> _buildResultsGrid(BuildContext context) {
    var products = Product.getMockList();
    var widgets = <Widget>[];

    widgets.add(_buildResultsHeader(products.length)); // Add Header
    widgets.addAll(_buildCustomGrid(context, products)); // Add Grid

    return widgets;
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
        navigation.push(ProductDetail(product: product));
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
      padding: EdgeInsets.only(top: Dimens.grid(6)),
      child: Text(
          product.title,
          style: Theme.of(context).textTheme.caption,
        ),
    );
  }

  Widget _productImage(Product product) {
    return RoundedCorners(
      child: CachedNetworkImage(
          placeholder: RoundedCorners(
            child: Container(
              height: Dimens.home_product_image_dimension,
              width: Dimens.home_product_image_dimension,
              decoration: BoxDecoration(
                  color: Colors.grey[200]
              ),
            ),
          ),
          fit: BoxFit.cover,
          height: Dimens.search_result_image_height,
          imageUrl: product.imageUrls.first),
    );
  }

  Container _buildResultsHeader(int quantity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$quantity Resultados'),
          RaisedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.location_on, color: Colors.grey),
              label: Text('Distrito Federal'))
        ],
      ),
    );
  }
}
