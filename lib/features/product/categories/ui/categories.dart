import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
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
      appBar: SearchTeaserAppBar(leading: Icon(Icons.search)),
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, i) {
          return CategoryListTile(category: categories[i]);
        });
  }
}
