import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/category_list_tile.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/search_teaser_app_bar.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  final bool showSearch;
  final bool returnChoice;
  final List<int> hideThese;
  final bool fetchAll;
  final CategoriesBloc bloc;

  const Categories({
    Key key,
    @required this.bloc,
    this.showSearch = true,
    this.returnChoice = false,
    this.hideThese,
    this.fetchAll = false,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends BaseState<Categories> {
  CategoriesBloc _categoriesBloc;
  ListingType _listingType;
  bool _fetchAll;

  @override
  void initState() {
    super.initState();
    // TODO: We have problem here. Since where aren't instantiating a new bloc,
    // instances of this widget will display the result loaded by other
    // instances build after it. Flutter onResume() ?

    _listingType = ListingType.donation;
    _fetchAll = widget.fetchAll;
    _categoriesBloc = widget.bloc;
    _loadCategories();
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
          return data == null
              ? Center(
                  child: SharedLoadingState(),
                )
              : CategoryListView(
                  categories: data,
                  returnChoice: widget.returnChoice,
                  hideThese: widget.hideThese,
                  selectedType: _listingType,
                  onTypeSelected: _setListingType,
                );
        },
      ),
    );
  }

  void _setListingType(ListingType type) {
    setState(() {
      _listingType = type;
      _loadCategories();
    });
  }

  void _loadCategories() {
    _categoriesBloc.fetchCategories(
      fetchAll: _fetchAll,
      type: _listingType,
    );
  }
}

class CategoryListView extends StatelessWidget {
  final List<ProductCategory> categories;
  final bool returnChoice;
  final List<int> hideThese;
  final Function(ListingType) onTypeSelected;
  final ListingType selectedType;

  const CategoryListView({
    Key key,
    @required this.categories,
    @required this.returnChoice,
    @required this.hideThese,
    @required this.onTypeSelected,
    @required this.selectedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideThese != null)
      categories.removeWhere((it) => hideThese.contains(it.id));

    final headersCount = 2;

    return ListView.builder(
        itemCount: categories.length + headersCount + 3,
        itemBuilder: (context, i) {
          int index;
          index = returnChoice == true ? i + headersCount : i;
          return (index == 0)
              ? TypeTabs(
                  selectedType: selectedType,
                  onDonationsSelected: (bool selected) {
                    onTypeSelected.call(ListingType.donation);
                  },
                  onRequestsSelected: (bool selected) {
                    onTypeSelected.call(ListingType.donationRequest);
                  },
                )
              : (index == 1)
                  ? AllListingsListTile(
                      selectedType: selectedType,
                    )
                  : (index < categories.length + headersCount)
                      ? CategoryListTile(
                          category: categories[index - headersCount],
                          returnChoice: returnChoice,
                          hideThese: hideThese,
                          listingType: selectedType,
                        )
                      : Spacing.vertical(Dimens.default_vertical_margin);
        });
  }
}

class TypeTabs extends StatelessWidget {
  final ListingType selectedType;
  final Function(bool) onDonationsSelected;
  final Function(bool) onRequestsSelected;

  const TypeTabs({
    Key key,
    @required this.selectedType,
    @required this.onDonationsSelected,
    @required this.onRequestsSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFuncion = GetLocalizedStringFunction(context);

    Color unselectedColor = Colors.grey;
    Color selectedTextColor = Colors.white;

    Color donationsChipTextColor = selectedTextColor;
    Color donationsChipColor = Theme.of(context).primaryColor;
    Color requestsChipTextColor = unselectedColor;
    Color requestsChipColor = Colors.transparent;

    if (selectedType == ListingType.donationRequest) {
      donationsChipTextColor = unselectedColor;
      donationsChipColor = Colors.transparent;
      requestsChipTextColor = CustomColors.accentColorText;
      requestsChipColor = Theme.of(context).colorScheme.secondary;
    }

    return Column(
      children: [
        Spacing.vertical(8.0),
        Wrap(
          children: [
            CategoriesChoiceChip(
              textColor: donationsChipTextColor,
              color: donationsChipColor,
              selected: selectedType == ListingType.donation,
              onSelected: onDonationsSelected,
              text: stringFuncion('categories_type_donations'),
              horizontalPaddingSize: 39.0,
            ),
            CategoriesChoiceChip(
              textColor: requestsChipTextColor,
              color: requestsChipColor,
              selected: selectedType == ListingType.donationRequest,
              onSelected: onRequestsSelected,
              text: stringFuncion('categories_type_donation_requests'),
            ),
          ],
        ),
        Spacing.vertical(8.0),
        CustomDivider(),
      ],
    );
  }
}

class CategoriesChoiceChip extends StatelessWidget {
  const CategoriesChoiceChip({
    Key key,
    @required this.textColor,
    @required this.color,
    @required this.selected,
    @required this.onSelected,
    @required this.text,
    this.horizontalPaddingSize,
  }) : super(key: key);

  final Color textColor;
  final Color color;
  final bool selected;
  final Function(bool p1) onSelected;
  final String text;
  final double horizontalPaddingSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: horizontalPaddingSize ?? 4.0),
        label: Text(
          GetLocalizedStringFunction(context)(text),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        selectedColor: color,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.default_chip_border_radius),
          ),
        ),
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}

class AllListingsListTile extends StatelessWidget {
  final ListingType selectedType;

  const AllListingsListTile({
    Key key,
    @required this.selectedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = selectedType == ListingType.donation
        ? 'categories_all_donations_list_item_title'
        : 'categories_all_donations_requests_list_item_title';

    final categoryName = GetLocalizedStringFunction(context)(text);

    return CategoryListTileUI(
      categoryName: categoryName,
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigation(context).push(Consumer<SearchResultBloc>(
          builder: (context, bloc, child) => SearchResult(
            forcedName: categoryName,
            listingType: selectedType,
            bloc: bloc,
          ),
        ));
      },
    );
  }
}
