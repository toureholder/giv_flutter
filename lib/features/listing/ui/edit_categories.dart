import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditCategories extends StatefulWidget {
  final List<ProductCategory> categories;

  const EditCategories({Key key, this.categories}) : super(key: key);

  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends BaseState<EditCategories> {
  List<ProductCategory> _editedList = [];

  @override
  void initState() {
    super.initState();
    if (widget.categories != null ) _editedList.addAll(widget.categories);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(title: string('edit_categories_title')),
      body: ListView(
        children: [
          ListView(
            shrinkWrap: true,
            children: _buildList(context),
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          Padding(
            padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
            child: PrimaryButton(
              text: string('shared_action_save'),
              onPressed: () {
                if (_editedList.isNotEmpty) navigation.pop(_editedList);
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    final list = _editedList
        .map((it) => ListTile(
              title: BodyText(it.title),
              trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeCategoryById(it.id);
                  }),
            ))
        .toList();

    if (_editedList.length < Config.maxProductCategories) {
      list.add(ListTile(
        title: BodyText(
          string('edit_categories_add_text'),
          color: Theme.of(context).primaryColor,
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _addNewCategory),
        onTap: _addNewCategory,
      ));
    } else {
      list.add(ListTile(
        title: Center(
          child: Body2Text(
            string('edit_categories_add_limit_warning'),
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    return list;
  }

  void _removeCategoryById(int categoryId) {
    setState(() {
      _editedList.removeWhere((it) => it.id == categoryId);
    });
  }

  void _addNewCategory() async {
    final result = await navigation.push(Categories(
      showSearch: false,
      returnChoice: true,
    ));

    if (result != null) {
      setState(() {
        _addCategory(result);
      });
    }
  }

  void _addCategory(ProductCategory category) {
    final found = _editedList.where((it) => it.id == category.id);
    if (found.isNotEmpty) return;

    _editedList.add(category);
  }
}
