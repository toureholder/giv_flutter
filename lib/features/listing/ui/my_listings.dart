import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/create_listing_bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class MyListings extends StatefulWidget {
  final MyListingsBloc bloc;
  final bool isSelecting;
  final int groupId;

  const MyListings({
    Key key,
    @required this.bloc,
    this.isSelecting = false,
    this.groupId,
  }) : super(key: key);

  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends BaseState<MyListings> {
  MyListingsBloc _myListingsBloc;
  bool _isSelecting;
  int _groupId;
  final List<int> selectedListingsIds = [];

  @override
  void initState() {
    super.initState();
    _myListingsBloc = widget.bloc;
    _myListingsBloc.fetchMyProducts();
    _isSelecting = widget.isSelecting;
    _groupId = widget.groupId;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Widget> actions = _isSelecting
        ? [
            MediumFlatPrimaryButton(
              text: selectedListingsIds.isEmpty
                  ? string('my_listings_select_items')
                  : string('common_add'),
              onPressed:
                  selectedListingsIds.isEmpty ? null : _returnWithSelectedIds,
            ),
          ]
        : [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showContactListerBottomSheet(context);
              },
            ),
          ];

    return CustomScaffold(
      appBar: CustomAppBar(
        title: _isSelecting ? '' : string('me_listings'),
        actions: actions,
      ),
      body: ContentStreamBuilder(
        stream: _myListingsBloc.productsStream,
        onHasData: (List<Product> data) {
          if (_isSelecting && _groupId != null) {
            data.removeWhere((listing) =>
                (listing.groups.indexWhere((group) => group.id == _groupId) >
                    -1) ||
                listing.isActive == false);
          }

          return _buildSingleChildScrollView(context, data);
        },
      ),
    );
  }

  Widget _buildSingleChildScrollView(
    BuildContext context,
    List<Product> products,
  ) {
    return products.isNotEmpty
        ? MyListingsScrollView(
            products: products,
            isSelecting: _isSelecting,
            onItemSelected: _toggleSelectedListingId,
            selectedListingsIds: selectedListingsIds,
          )
        : MyListingsEmptyState(
            stringFunction: string,
            onPressed: () {
              _showContactListerBottomSheet(context);
            },
            isSelecting: _isSelecting,
          );
  }

  _goToPostPage(BuildContext context, ListingType type) {
    navigation.pushReplacement(NewListing(
      bloc: Provider.of<NewListingBloc>(context, listen: false),
      listingType: type,
    ));
  }

  void _showContactListerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateListingBottomSheet(
          onDonationButtonPressed: () {
            _goToPostPage(context, ListingType.donation);
          },
          onDonationRequestButtonPressed: () {
            _goToPostPage(context, ListingType.donationRequest);
          },
        );
      },
    );
  }

  _toggleSelectedListingId(int value) {
    setState(() {
      if (selectedListingsIds.contains(value)) {
        selectedListingsIds.remove(value);
      } else {
        selectedListingsIds.add(value);
      }
    });
  }

  _returnWithSelectedIds() {
    if (selectedListingsIds.isEmpty) {
      return;
    }

    navigation.pop(selectedListingsIds);
  }
}

class MyListingsScrollView extends StatelessWidget {
  final List<Product> products;
  final bool isSelecting;
  final Function onItemSelected;
  final List<int> selectedListingsIds;

  const MyListingsScrollView({
    Key key,
    @required this.products,
    @required this.isSelecting,
    @required this.onItemSelected,
    @required this.selectedListingsIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ProductGrid(
        products: products,
        isSelecting: isSelecting,
        onItemSelected: onItemSelected,
        selectedListingsIds: selectedListingsIds,
      ),
    );
  }
}

class MyListingsEmptyState extends StatelessWidget {
  final GetLocalizedStringFunction stringFunction;
  final VoidCallback onPressed;
  final bool isSelecting;

  const MyListingsEmptyState({
    Key key,
    @required this.stringFunction,
    @required this.onPressed,
    this.isSelecting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = isSelecting
        ? 'my_listings_empty_state_is_selecting'
        : 'my_listings_empty_state';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(32)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Body2Text(
            stringFunction(text),
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
          Spacing.vertical(Dimens.grid(20)),
          SvgPicture.asset(
            'images/undraw_empty_posts.svg',
            width: 150.0,
            fit: BoxFit.cover,
          ),
          Spacing.vertical(Dimens.grid(20)),
          if (!isSelecting)
            PrimaryButton(
              text: stringFunction('my_listings_empty_state_button'),
              onPressed: onPressed,
              fillWidth: false,
            )
        ],
      ),
    );
  }
}
