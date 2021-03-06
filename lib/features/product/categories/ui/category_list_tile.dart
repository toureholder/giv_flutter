import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/product/categories/ui/sub_categories.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/typography.dart';

class CategoryListTile extends StatefulWidget {
  final ProductCategory category;
  final bool returnChoice;
  final List<int> hideThese;
  final ListingType listingType;

  const CategoryListTile({
    Key key,
    this.category,
    this.returnChoice = false,
    this.hideThese,
    this.listingType,
  }) : super(key: key);

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

    final onTap =
        widget.returnChoice ? _returnChoice : _goToSubCategoryOrResult;

    return CategoryListTileUI(
      categoryName: category.simpleName,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _returnChoice() async {
    if (widget.category?.subCategories?.isNotEmpty ?? false) {
      final result = await navigation.push(SubCategories(
        category: widget.category,
        returnChoice: true,
        hideThese: widget.hideThese,
      ));
      if (result != null) navigation.pop(result);
      return;
    }

    navigation.pop(widget.category);
  }

  void _goToSubCategoryOrResult() {
    widget.category.goToSubCategoryOrResult(
      navigation,
      listingType: widget.listingType,
    );
  }
}

class CategoryListTileUI extends StatelessWidget {
  final String categoryName;
  final Icon trailing;
  final GestureTapCallback onTap;

  const CategoryListTileUI({
    Key key,
    @required this.categoryName,
    @required this.trailing,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: BodyText(categoryName),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        CustomDivider(),
      ],
    );
  }
}
