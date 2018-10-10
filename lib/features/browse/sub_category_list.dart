import 'package:flutter/material.dart';
import 'package:giv_flutter/features/browse/search_result.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';

class SubCategoryList extends StatelessWidget {
  final String title;

  const SubCategoryList({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder().setTitle(title).build(),
      body: ListView(
        children: <Widget>[
          _buildListItem(context, 'Tudo de livros'),
          _buildListItem(context, 'Economia'),
          _buildListItem(context, 'Romance'),
          _buildListItem(context, 'Auto-ajuda'),
          _buildListItem(context, 'Em inglês'),
        ],
      ),
    );
  }

  ListTile _buildListItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        _pushSearchResult(context, title);
      },
    );
  }

  void _pushSearchResult(BuildContext context, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return SearchResult(title: title);
            })
    );
  }
}