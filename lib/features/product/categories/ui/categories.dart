import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_icons_icons.dart';
import 'package:giv_flutter/util/presentation/dimens.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends BaseState<Categories> {
  CategoriesBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = CategoriesBloc();
    _searchBloc.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              return _buildListItem(context, categories[i]);
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
          hintText: string('search_hint'),
          hintStyle: TextStyle(color: Colors.grey),
          icon: Icon(
            CustomIcons.ib_le_magnifying_glass,
            color: Colors.grey,
          )),
    );
  }

  ListTile _buildListItem(BuildContext context, ProductCategory category) {
    return ListTile(
      title: Text(category.title),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        category.goToSubCategoryOrResult(navigation);
      },
    );
  }
}
