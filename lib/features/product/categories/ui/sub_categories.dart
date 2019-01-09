import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/app_bar_builder.dart';

class SubCategories extends StatefulWidget {
  final ProductCategory category;

  const SubCategories({Key key, this.category}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends BaseState<SubCategories> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBarBuilder().setTitle(widget.category.title).build(),
      body: ListView(
        children: _buildList(context, widget.category.subCategories),
      ),
    );
  }

  List<Widget> _buildList(
      BuildContext context, List<ProductCategory> categories) {
    return categories.map((it) => _buildListItem(context, it)).toList();
  }

  ListTile _buildListItem(BuildContext context, ProductCategory category) {
    return ListTile(
      title: Text(category.title),
      onTap: () {
        category.goToSubCategoryOrResult(navigation);
      },
    );
  }
}
