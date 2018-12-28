import 'package:flutter/material.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/features/product/browse/sub_category_list.dart';
import 'package:giv_flutter/features/search/bloc/search_bloc.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_icons_icons.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc();
    _searchBloc.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentStreamBuilder(
        stream: _searchBloc.categories,
        onHasData: (data) {
          return _buildMainListView(context, data);
        },
      ),
    );
  }

  ListView _buildMainListView(BuildContext context, List<ProductCategory> categories) {
    return ListView(
      children: <Widget>[
        _buildSearchFieldContainer(),
        ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              return _buildListItem(context, categories[i].title);
            }
        )
      ],
    );
  }

  Container _buildSearchFieldContainer() {
    return Container(
            color: Colors.white,
            height: kToolbarHeight,
            child: _buildSearchField(),
            padding: EdgeInsets.symmetric(horizontal: Dimens.default_horizontal_margin),
            alignment: Alignment(0.0, 0.0),
        );
  }

  TextField _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Busque no Giv',
          hintStyle: TextStyle(color: Colors.grey),
          icon: Icon(
            CustomIcons.ib_le_magnifying_glass,
            color: Colors.grey,
          )),
    );
  }

  ListTile _buildListItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        _pushSubCategoryList(context, title);
      },
    );
  }

  void _pushSubCategoryList(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) {
            return SubCategoryList(title: title);
          })
    );
  }
}
