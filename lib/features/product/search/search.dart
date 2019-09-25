import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/material_search.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String initialText;
  final SearchResultBloc bloc;

  const Search({Key key, @required this.bloc, this.initialText})
      : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends BaseState<Search> {
  SearchResultBloc _searchResultBloc;
  List<ProductCategory> _suggestedCategories;

  @override
  void initState() {
    super.initState();
    _searchResultBloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
        resizeToAvoidBottomPadding: false,
        body: AndroidTheme(child: _buildSearchBar()));
  }

  Widget _buildSearchBar() {
    return MaterialSearch<String>(
      placeholder: string('search_hint'),
      getResults: (String q) async {
        _suggestedCategories = await _searchResultBloc.getSearchSuggestions(q);
        return _suggestedCategories
            .map((category) => MaterialSearchResult<String>(
                  value: category.id
                      .toString(), //The value must be of type <String>
                  text: category
                      .canonicalName, //String that will be show in the list
                  icon: Icons.search,
                ))
            .toList();
      },
      elevation: 0.0,
      textInputAction: TextInputAction.search,
      initialText: widget.initialText,
      onSelect: _searchByCategoryId,
      onSubmit: _searchByQuery,
    );
  }

  _searchByQuery(String q) {
    if (q?.isEmpty ?? true) return;
    navigation.pushReplacement(
        Consumer<SearchResultBloc>(
          builder: (context, bloc, child) => SearchResult(
            searchQuery: q,
            bloc: bloc,
          ),
        ),
        hasAnimation: false);
  }

  _searchByCategoryId(id) {
    ProductCategory selectedCategory =
        _suggestedCategories.firstWhere((it) => it.id.toString() == id);
    navigation.pushReplacement(
        Consumer<SearchResultBloc>(
          builder: (context, bloc, child) => SearchResult(
            category: selectedCategory,
            useCanonicalName: true,
            bloc: bloc,
          ),
        ),
        hasAnimation: false);
  }
}
