import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/material_search.dart';

class Search extends StatefulWidget {
  final String initialText;

  const Search({Key key, this.initialText}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends BaseState<Search> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      body: MaterialSearch<String>(
        placeholder: string('search_hint'),
        results: [],
        elevation: 0.0,
        textInputAction: TextInputAction.search,
        initialText: widget.initialText,
        onSubmit: (String q) {
          navigation.pushReplacement(SearchResult(searchQuery: q), hasAnimation: false);
        },
      ),
    );
  }
}
