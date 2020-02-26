import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

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
    // TODO: We have problem here. Since where aren't instantiating a new bloc,
    // instances of this widget will display the result loaded by other
    // instances build after it. Flutter onResume() ?

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
        onHasData: (List<ProductCategory> data) {
          return CategoryListView(
            categories: data,
            returnChoice: widget.returnChoice,
            hideThese: widget.hideThese,
          );
        },
      ),
    );
  }
}

class CategoryListView extends StatelessWidget {
  final List<ProductCategory> categories;
  final bool returnChoice;
  final List<int> hideThese;

  const CategoryListView({
    Key key,
    @required this.categories,
    @required this.returnChoice,
    @required this.hideThese,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideThese != null)
      categories.removeWhere((it) => hideThese.contains(it.id));

    return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length + 2,
        itemBuilder: (context, i) {
          return (i == 0)
              ? AllProductsListTile()
              : (i < categories.length + 1)
                  ? CategoryListTile(
                      category: categories[i - 1],
                      returnChoice: returnChoice,
                      hideThese: hideThese,
                    )
                  : Spacing.vertical(Dimens.default_vertical_margin);
        });
  }
}

class AllProductsListTile extends StatefulWidget {
  @override
  _AllProductsListTileState createState() => _AllProductsListTileState();
}

class _AllProductsListTileState extends BaseState<AllProductsListTile> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final categoryName = string('categories_everything_list_item_title');

    return CategoryListTileUI(
      categoryName: categoryName,
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        navigation.push(Consumer<SearchResultBloc>(
          builder: (context, bloc, child) => SearchResult(
            forcedName: categoryName,
            bloc: bloc,
          ),
        ));
      },
    );
  }
}
