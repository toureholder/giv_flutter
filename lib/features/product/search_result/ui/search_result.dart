import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/detail/product_detail.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class SearchResult extends StatefulWidget {
  final ProductCategory category;
  final String searchQuery;

  const SearchResult({Key key, this.category, this.searchQuery})
      : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends BaseState<SearchResult> {
  SearchResultBloc _searchResultBloc;

  @override
  void initState() {
    super.initState();
    _searchResultBloc = SearchResultBloc();
    _searchResultBloc.fetchProducts(
        categoryId: widget?.category?.id, searchQuery: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchResultBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var title = widget.category?.title ?? widget.searchQuery;

    var appBar = widget.category == null
        ? SearchTeaserAppBar(q: widget.searchQuery)
        : CustomAppBar(title: title);

    return CustomScaffold(
        appBar: appBar,
        body: ContentStreamBuilder(
          stream: _searchResultBloc.result,
          onHasData: (StreamEvent<ProductSearchResult> event) {
            return event.isLoading()
                ? Center(child: CircularProgressIndicator())
                : _buildMainListView(context, event.data);
          },
        ));
  }

  ListView _buildMainListView(
      BuildContext context, ProductSearchResult result) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.grid(4), vertical: Dimens.grid(8)),
      children: _buildResultsGrid(context, result),
    );
  }

  List<Widget> _buildResultsGrid(
      BuildContext context, ProductSearchResult result) {
    var widgets = <Widget>[];

    widgets.add(_buildResultsHeader(result)); // Add Header
    widgets.addAll(_buildCustomGrid(context, result.products)); // Add Grid

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
          imageUrl: product.imageUrls.first),
    );
  }

  Container _buildResultsHeader(ProductSearchResult result) {
    final quantity = result.products.length;
    final buttonText = result.location?.name ?? string('action_filter');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BodyText(string('search_result_x_results', formatArg: '$quantity')),
          Spacing.horizontal(Dimens.default_horizontal_margin),
          Flexible(
            child: FlatButton.icon(
                color: Colors.grey[200],
                onPressed: () {
                  _navigateToLocationFilter(result.location);
                },
                icon: Icon(Icons.tune, color: Colors.grey),
                label: Flexible(
                  child: Text(
                    buttonText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          )
        ],
      ),
    );
  }

  _navigateToLocationFilter(Location location) async {
    final result = await navigation.push(LocationFilter(location: location));

    if (result == null) return;

    _searchResultBloc.fetchProducts(
        categoryId: widget?.category?.id,
        searchQuery: widget.searchQuery,
        locationFilter: result);
  }
}
