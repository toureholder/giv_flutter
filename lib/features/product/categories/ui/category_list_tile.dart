import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class CategoryListTile extends StatefulWidget {
  final ProductCategory category;
  final bool returnChoice;

  const CategoryListTile({Key key, this.category, this.returnChoice = false}) : super(key: key);

  @override
  _CategoryListTileState createState() => _CategoryListTileState();
}

class _CategoryListTileState extends BaseState<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final category = widget.category;

    final trailing =
        category.hasSubCategories ? Icon(Icons.chevron_right) : null;

    final onTap = widget.returnChoice ? _returnChoice : _goToSubCategoryOrResult;

    return ListTile(
      title: BodyText(category.title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _returnChoice() async {
    if (widget.category?.subCategories?.isNotEmpty ?? false) {
      final result = await navigation.push(SubCategories(category: widget.category, returnChoice: true,));
      if (result != null) navigation.pop(result);
      return;
    }

    navigation.pop(widget.category);
  }

  void _goToSubCategoryOrResult() {
    widget.category.goToSubCategoryOrResult(navigation);
  }
}
