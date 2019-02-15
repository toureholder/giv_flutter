import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class SubCategories extends StatefulWidget {
  final ProductCategory category;
  final bool returnChoice;
  final List<int> hideThese;

  const SubCategories(
      {Key key, this.category, this.returnChoice = false, this.hideThese})
      : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends BaseState<SubCategories> {
  List<ProductCategory> _subCategories;
  List<ProductCategory> _originalSubCategoryList;

  @override
  void initState() {
    super.initState();
    _subCategories = List<ProductCategory>.from(widget.category.subCategories);
    _originalSubCategoryList = List<ProductCategory>.from(_subCategories);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: widget.category.simpleName),
      body: ListView(
        children: _buildList(context, _subCategories),
      ),
    );
  }

  List<Widget> _buildList(
      BuildContext context, List<ProductCategory> categories) {
    if (widget.hideThese != null)
      categories.removeWhere((it) => widget.hideThese.contains(it.id));

    final parentWidget = widget.category;

    final parentCategory = ProductCategory(
        id: parentWidget.id,
        simpleName: parentWidget.getNameAsParent(context),
        canonicalName: parentWidget.canonicalName);

    final finalList = List<ProductCategory>.from(categories);

    if (_noSiblingsWhereSelected()) finalList.insert(0, parentCategory);

    return finalList
        .map((it) => CategoryListTile(
              category: it,
              returnChoice: widget.returnChoice,
              hideThese: widget.hideThese,
            ))
        .toList();
  }

  bool _noSiblingsWhereSelected() {
    if (widget.hideThese == null  || widget.hideThese.isEmpty) return true;

    final subCategoryIds = _originalSubCategoryList.map((it) => it.id).toList();
    return subCategoryIds.every((it) => !widget.hideThese.contains(it));
  }
}
