import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';

class Categories extends StatefulWidget {
  final bool showSearch;
  final bool returnChoice;
  final List<int> hideThese;
  final bool fetchAll;
  final CategoriesBloc bloc;

  const Categories(
      {Key key,
      @required this.bloc,
      this.showSearch = true,
      this.returnChoice = false,
      this.hideThese,
      this.fetchAll = false})
      : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends BaseState<Categories> {
  CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = widget.bloc;
    _categoriesBloc.fetchCategories(fetchAll: widget.fetchAll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var appBar = widget.showSearch
        ? SearchTeaserAppBar(leading: Icon(Icons.search))
        : CustomAppBar(title: string('page_title_categories'));

    return CustomScaffold(
      appBar: appBar,
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
    if (widget.hideThese != null)
      categories.removeWhere((it) => widget.hideThese.contains(it.id));

    return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length + 1,
        itemBuilder: (context, i) {
          return i < categories.length
              ? CategoryListTile(
                  category: categories[i],
                  returnChoice: widget.returnChoice,
                  hideThese: widget.hideThese,
                )
              : Spacing.vertical(Dimens.default_vertical_margin);
        });
  }
}
