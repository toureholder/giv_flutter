import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/material_search.dart';

class Search extends StatefulWidget {
  final String initialText;

  const Search({Key key, this.initialText}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends BaseState<Search> {
  SearchResultBloc _searchResultBloc;
  List<ProductCategory> _suggestedCategories;

  @override
  void initState() {
    super.initState();
    _searchResultBloc = SearchResultBloc();
  }

  @override
  void dispose() {
    _searchResultBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      resizeToAvoidBottomPadding: false,
      body: MaterialSearch<String>(
        placeholder: string('search_hint'),
        getResults: (String q) async {
          _suggestedCategories = await _searchResultBloc.getSearchSuggestions(q);
          return _suggestedCategories
              .map((category) => new MaterialSearchResult<String>(
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
      ),
    );
  }

  _searchByQuery(String q) {
    if (q?.isEmpty ?? true) return;
    navigation.pushReplacement(SearchResult(searchQuery: q),
        hasAnimation: false);
  }

  _searchByCategoryId(id) {
    ProductCategory selectedCategory =
        _suggestedCategories.firstWhere((it) => it.id.toString() == id);
    navigation.pushReplacement(
        SearchResult(category: selectedCategory, useCanonicalName: true),
        hasAnimation: false);
  }
}
