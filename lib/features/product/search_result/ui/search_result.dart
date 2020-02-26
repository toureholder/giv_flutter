import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
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
  final String forcedName;

  const SearchResult({
    Key key,
    @required this.bloc,
    this.category,
    this.searchQuery,
    this.useCanonicalName = false,
    this.forcedName,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends BaseState<SearchResult> {
  SearchResultBloc _bloc;
  List<Product> _products = [];
  bool _isInfiniteScrollOn;
  int _currentPage;
  ScrollController _scrollController;
  double _loadingWidgetOpacity;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bloc = widget.bloc;
    _enableInfiniteScroll();
    _observeScrolling();
    _fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final categoryName = widget.useCanonicalName
        ? widget.category?.canonicalName
        : widget.category?.simpleName;

    final title = widget.forcedName ?? categoryName;

    final appBar = title == null
        ? SearchTeaserAppBar(q: widget.searchQuery)
        : CustomAppBar(title: title);

    return CustomScaffold(
        appBar: appBar,
        body: ContentStreamBuilder(
          stream: _bloc.result,
          onHasData: (StreamEvent<ProductSearchResult> event) {
            return SearchResultListView(
              children: _buildResultsGrid(event.data),
              scrollController: _scrollController,
            );
          },
        ));
  }

  List<Widget> _buildResultsGrid(ProductSearchResult result) {
    var widgets = <Widget>[];

    if (result != null) {
      final products = result.products;

      // Widgets rebuild whenever they want and I don't want to duplicate items
      if (_products.where((it) => it.id == products.first.id).isEmpty)
        _products.addAll(products);

      if (result.products.length < Config.paginationDefaultPerPage)
        _disableInfiniteScroll();
    }

    widgets.add(
      ResultsHeader(
        result: result,
        onSearchFilterButtonPressed: () =>
            _navigateToLocationFilter(result?.location),
      ),
    );

    widgets.add(
      ProductGrid(
        products: _products,
      ),
    );

    if (_products.isEmpty && result != null)
      widgets.add(
        SearchResultEmptyState(
          locationFilter: result.location,
          searchQuery: widget.searchQuery,
          category: widget.category,
        ),
      );

    widgets.addAll(
      [
        Spacing.vertical(Dimens.default_vertical_margin),
        LoadingMore(opacity: _loadingWidgetOpacity),
      ],
    );

    return widgets;
  }

  _disableInfiniteScroll() {
    _isInfiniteScrollOn = false;
    _loadingWidgetOpacity = 0.0;
  }

  _enableInfiniteScroll() {
    _currentPage = 0;
    _isInfiniteScrollOn = true;
    _products.clear();
    _loadingWidgetOpacity = 1.0;
  }

  _fetchProducts({Location locationFilter, bool isHardFilter}) {
    _currentPage++;

    _bloc.fetchProducts(
      categoryId: widget?.category?.id,
      searchQuery: widget.searchQuery,
      locationFilter: locationFilter,
      isHardFilter: isHardFilter,
      page: _currentPage,
    );
  }

  _navigateToLocationFilter(Location location) async {
    final result = await navigation.push(Consumer<LocationFilterBloc>(
      builder: (context, bloc, child) =>
          LocationFilter(bloc: bloc, location: location),
    ));

    if (result == null) return;

    _enableInfiniteScroll();
    _fetchProducts(locationFilter: result, isHardFilter: true);
  }

  _observeScrolling() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _isInfiniteScrollOn) {
        _fetchProducts();
      }
    });
  }
}

class SearchResultListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController scrollController;

  const SearchResultListView({
    Key key,
    @required this.children,
    @required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
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
    return Opacity(
      opacity: result == null ? 0.0 : 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.grid(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: SearchFilterButton(
                onPressed: onSearchFilterButtonPressed,
                buttonText: result?.location?.mediumName,
              ),
            )
          ],
        ),
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
    final text = buttonText ??
        GetLocalizedStringFunction(context)('action_location_filter');

    return GreyOutlineIconButton(
      onPressed: onPressed,
      text: text,
      isFlexible: true,
      iconData: Icons.tune,
    );
  }
}

class LoadingMore extends StatelessWidget {
  final double opacity;

  const LoadingMore({Key key, @required this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchResultEmptyState extends StatefulWidget {
  final Location locationFilter;
  final ProductCategory category;
  final String searchQuery;

  const SearchResultEmptyState({
    Key key,
    @required this.locationFilter,
    @required this.category,
    @required this.searchQuery,
  }) : super(key: key);

  @override
  _SearchResultEmptyStateState createState() => _SearchResultEmptyStateState();
}

class _SearchResultEmptyStateState extends BaseState<SearchResultEmptyState> {
  Location _locationFilter;
  ProductCategory _category;
  String _searchQuery;

  @override
  void initState() {
    super.initState();
    _locationFilter = widget.locationFilter;
    _category = widget.category;
    _searchQuery = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final text = _getEmptySateText(_locationFilter, _category, _searchQuery);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.grid(48),
        horizontal: Dimens.default_horizontal_margin,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'images/undraw_thoughts_2196f3.svg',
            width: 172.0,
            fit: BoxFit.cover,
          ),
          Spacing.vertical(Dimens.grid(20)),
          Body2Text(
            string(text),
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptySateText(location, category, searchQuery) {
    String text;

    if (location?.city != null) {
      if (category != null) {
        text = string(
            'search_result_empty_state_nothing_from_category_in_your_city',
            formatArg: category.canonicalName);
      } else if (searchQuery != null) {
        text = string(
            'search_result_empty_state_nothing_from_search_term_in_your_city',
            formatArg: searchQuery);
      } else {
        text = string('search_result_empty_state_nothing_in_your_city');
      }
    } else if (location?.state != null) {
      if (category != null) {
        text = string(
            'search_result_empty_state_nothing_from_category_in_your_state',
            formatArg: category.canonicalName);
      } else if (searchQuery != null) {
        text = string(
            'search_result_empty_state_nothing_from_search_term_in_your_state',
            formatArg: searchQuery);
      } else {
        text = string('search_result_empty_state_nothing_in_your_state');
      }
    } else {
      if (category != null) {
        text = string(
            'search_result_empty_state_nothing_from_category',
            formatArg: category.canonicalName);
      } else if (searchQuery != null) {
        text = string(
            'search_result_empty_state_nothing_from_search_term',
            formatArg: searchQuery);
      } else {
        text = string('search_result_empty_state_nothing');
      }
    }

    return text;
  }
}
