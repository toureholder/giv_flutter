import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class EditCategories extends StatefulWidget {
  final List<ProductCategory> categories;
  final ListingType listingType;

  const EditCategories({
    Key key,
    @required this.categories,
    @required this.listingType,
  }) : super(key: key);

  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends BaseState<EditCategories> {
  ListingType _listingType;
  List<ProductCategory> _editedList;

  @override
  void initState() {
    super.initState();
    _listingType = widget.listingType;
    _editedList = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final listingTypeButtonMap = <ListingType, Widget>{
      ListingType.donation: PrimaryButton(
        text: string('shared_action_save'),
        onPressed: () {
          if (_editedList.isNotEmpty) navigation.pop(_editedList);
        },
      ),
      ListingType.donationRequest: AccentButton(
        text: string('shared_action_save'),
        onPressed: () {
          if (_editedList.isNotEmpty) navigation.pop(_editedList);
        },
      ),
    };

    return CustomScaffold(
      appBar: CustomAppBar(title: string('edit_categories_title')),
      body: ListView(
        children: [
          ListView(
            shrinkWrap: true,
            children: _buildList(),
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          Padding(
            padding: const EdgeInsets.all(Dimens.default_horizontal_margin),
            child: listingTypeButtonMap[_listingType],
          )
        ],
      ),
    );
  }

  List<Widget> _buildList() {
    final list = <Widget>[];

    for (ProductCategory item in _editedList) {
      list.add(EditCategoryTile(
        onDeletePressed: () {
          _removeCategoryById(item.id);
        },
        category: item,
      ));
    }

    final footer = (_editedList.length < Config.maxProductCategories)
        ? AddCategoryTile(
            onPressed: _addNewCategory,
            listingType: _listingType,
          )
        : MaxQuantityWarningTile();

    list.add(footer);

    return list;
  }

  void _removeCategoryById(int categoryId) {
    setState(() {
      _editedList.removeWhere((it) => it.id == categoryId);
    });
  }

  void _addNewCategory() async {
    final result = await navigation.push(Consumer<CategoriesBloc>(
      builder: (context, bloc, child) => Categories(
        bloc: bloc,
        showSearch: false,
        returnChoice: true,
        hideThese: _editedList.map((it) => it.id).toList(),
        fetchAll: true,
      ),
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

class EditCategoryTile extends StatelessWidget {
  final Function onDeletePressed;
  final ProductCategory category;

  const EditCategoryTile(
      {Key key, @required this.onDeletePressed, @required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimens.default_horizontal_margin,
      ),
      title: BodyText(category.canonicalName),
      trailing: DeleteButton(onPressed: onDeletePressed),
    );
  }
}

class AddCategoryTile extends StatelessWidget {
  final ListingType listingType;
  final Function onPressed;

  const AddCategoryTile({
    Key key,
    @required this.listingType,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = <ListingType, Color>{
      ListingType.donation: Theme.of(context).primaryColor,
      ListingType.donationRequest: Colors.black,
    }[listingType];

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimens.default_horizontal_margin,
      ),
      title: BodyText(
        GetLocalizedStringFunction(context)('edit_categories_add_text'),
        color: color,
      ),
      trailing: AddButton(
        onPressed: onPressed,
        color: color,
      ),
      onTap: onPressed,
    );
  }
}

class MaxQuantityWarningTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Body2Text(
          GetLocalizedStringFunction(context)(
              'edit_categories_add_limit_warning'),
          color: Colors.grey,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const AddButton({
    Key key,
    @required this.onPressed,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: color,
      ),
      onPressed: onPressed,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: onPressed,
    );
  }
}
