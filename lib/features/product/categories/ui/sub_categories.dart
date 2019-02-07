import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class SubCategories extends StatefulWidget {
  final ProductCategory category;
  final bool returnChoice;

  const SubCategories({Key key, this.category, this.returnChoice = false})
      : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends BaseState<SubCategories> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(title: widget.category.simpleName),
      body: ListView(
        children: _buildList(context, widget.category.subCategories),
      ),
    );
  }

  List<Widget> _buildList(
      BuildContext context, List<ProductCategory> categories) {

    final parentWidget = widget.category;

    final parentCategory = ProductCategory(
      id: parentWidget.id,
      simpleName: parentWidget.getNameAsParent(context),
      canonicalName: parentWidget.canonicalName
    );

    final finalList = List<ProductCategory>.from(categories);
    finalList.insert(0, parentCategory);

    return finalList
        .map((it) => CategoryListTile(
              category: it,
              returnChoice: widget.returnChoice,
            ))
        .toList();
  }
}
