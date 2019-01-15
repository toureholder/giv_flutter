import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class CategoryListTile extends StatefulWidget {
  final ProductCategory category;

  const CategoryListTile({Key key, this.category}) : super(key: key);

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

    return ListTile(
      title: BodyText(category.title),
      trailing: trailing,
      onTap: () {
        category.goToSubCategoryOrResult(navigation);
      },
    );
  }
}
