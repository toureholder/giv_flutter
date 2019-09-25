import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
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
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  final ProductCategory category;
  final String searchQuery;
  final bool useCanonicalName;
  final SearchResultBloc bloc;

  const SearchResult({
    Key key,
    @required this.bloc,
    this.category,
    this.searchQuery,
    this.useCanonicalName = false,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends BaseState<SearchResult> {
  SearchResultBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var categoryName = widget.useCanonicalName
        ? widget.category?.canonicalName
        : widget.category?.simpleName;

    var title = categoryName ?? widget.searchQuery;

    var appBar = widget.category == null
        ? SearchTeaserAppBar(q: widget.searchQuery)
        : CustomAppBar(title: title);

    return CustomScaffold(
        appBar: appBar,
        body: ContentStreamBuilder(
          stream: _bloc.result,
          onHasData: (StreamEvent<ProductSearchResult> event) {
            return event.isLoading
                ? Center(child: CircularProgressIndicator())
                : SearchResultListView(
                    children: _buildResultsGrid(event.data),
                  );
          },
        ));
  }

  List<Widget> _buildResultsGrid(ProductSearchResult result) {
    var widgets = <Widget>[];

    widgets.add(ResultsHeader(
      result: result,
      onSearchFilterButtonPressed: () =>
          _navigateToLocationFilter(result.location),
    ));

    widgets.add(ProductGrid(
      products: result.products,
    ));

    return widgets;
  }

  _navigateToLocationFilter(Location location) async {
    final result = await navigation.push(Consumer<LocationFilterBloc>(
      builder: (context, bloc, child) =>
          LocationFilter(bloc: bloc, location: location),
    ));
    if (result == null) return;
    _fetchProducts(locationFilter: result, isHardFilter: true);
  }

  _fetchProducts({Location locationFilter, bool isHardFilter}) {
    _bloc.fetchProducts(
        categoryId: widget?.category?.id,
        searchQuery: widget.searchQuery,
        locationFilter: locationFilter,
        isHardFilter: isHardFilter);
  }
}

class SearchResultListView extends StatelessWidget {
  final List<Widget> children;

  const SearchResultListView({
    Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.grid(4),
        vertical: Dimens.grid(8),
      ),
      children: children,
    );
  }
}

class ResultsHeader extends StatelessWidget {
  final ProductSearchResult result;
  final VoidCallback onSearchFilterButtonPressed;

  const ResultsHeader({
    Key key,
    @required this.result,
    @required this.onSearchFilterButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    final quantity = result.products.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BodyText(stringFunction(
            'search_result_x_results',
            formatArg: '$quantity',
          )),
          Spacing.horizontal(Dimens.default_horizontal_margin),
          Flexible(
            child: SearchFilterButton(
              onPressed: onSearchFilterButtonPressed,
              buttonText: result.location?.shortName,
            ),
          )
        ],
      ),
    );
  }
}

class SearchFilterButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SearchFilterButton({
    Key key,
    this.buttonText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        buttonText ?? GetLocalizedStringFunction(context)('action_filter');

    return GreyIconButton(
      onPressed: onPressed,
      text: text,
      isFlexible: true,
      icon: Icon(Icons.tune, color: Colors.grey),
    );
  }
}
