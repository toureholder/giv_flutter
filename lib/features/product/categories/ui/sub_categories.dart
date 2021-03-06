import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class SubCategories extends StatefulWidget {
  final ProductCategory category;
  final bool returnChoice;
  final List<int> hideThese;
  final ListingType listingType;

  const SubCategories({
    Key key,
    this.category,
    this.returnChoice = false,
    this.hideThese,
    this.listingType,
  }) : super(key: key);

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
        children: _buildList(_subCategories),
      ),
    );
  }

  List<Widget> _buildList(List<ProductCategory> categories) {
    if (widget.hideThese != null)
      categories.removeWhere(
        (it) => widget.hideThese.contains(it.id),
      );

    final category = widget.category;

    final parentCategory = ProductCategory(
      id: category.id,
      simpleName: category.getNameAsParent(context),
      canonicalName: category.canonicalName,
    );

    final finalList = List<ProductCategory>.from(categories);

    if (_noSiblingsWereSelected()) finalList.insert(0, parentCategory);

    return finalList
        .map((it) => CategoryListTile(
              category: it,
              returnChoice: widget.returnChoice,
              hideThese: widget.hideThese,
              listingType: widget.listingType,
            ))
        .toList();
  }

  bool _noSiblingsWereSelected() {
    if (widget.hideThese == null || widget.hideThese.isEmpty) return true;

    final subCategoryIds = _originalSubCategoryList.map((it) => it.id).toList();
    return subCategoryIds.every((it) => !widget.hideThese.contains(it));
  }
}
