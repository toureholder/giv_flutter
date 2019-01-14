import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends BaseState<Categories> {
  CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = CategoriesBloc();
    _categoriesBloc.fetchCategories();
  }

  @override
  void dispose() {
    _categoriesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      body: ContentStreamBuilder(
        stream: _categoriesBloc.categories,
        onHasData: (data) {
          return _buildMainListView(context, data);
        },
      ),
    );
  }

  ListView _buildMainListView(
      BuildContext context, List<ProductCategory> categories) {
    return ListView(
      children: <Widget>[
        SearchTeaserAppBar(leading: Icon(Icons.search)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              return _buildListItem(context, categories[i]);
            })
      ],
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
