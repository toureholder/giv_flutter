import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

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
    _fetchProducts();
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
            return event.isLoading
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
    widgets.add(ProductGrid(
      products: result.products,
    ));

    return widgets;
  }

  Container _buildResultsHeader(ProductSearchResult result) {
    final quantity = result.products.length;
    final buttonText = result.location?.shortName ?? string('action_filter');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BodyText(string('search_result_x_results', formatArg: '$quantity')),
          Spacing.horizontal(Dimens.default_horizontal_margin),
          Flexible(
            child: GreyIconButton(
              onPressed: () {
                _navigateToLocationFilter(result.location);
              },
              text: buttonText,
              isFlexible: true,
              icon: Icon(Icons.tune, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  _navigateToLocationFilter(Location location) async {
    final result = await navigation.push(LocationFilter(location: location));
    if (result == null) return;
    _fetchProducts(locationFilter: result);
  }

  _fetchProducts({Location locationFilter}) {
    _searchResultBloc.fetchProducts(
        categoryId: widget?.category?.id,
        searchQuery: widget.searchQuery,
        locationFilter: locationFilter);
  }
}
