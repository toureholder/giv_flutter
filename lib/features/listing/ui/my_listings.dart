import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class MyListings extends StatefulWidget {
  final MyListingsBloc bloc;

  const MyListings({Key key, @required this.bloc}) : super(key: key);

  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends BaseState<MyListings> {
  MyListingsBloc _myListingsBloc;

  @override
  void initState() {
    super.initState();
    _myListingsBloc = widget.bloc;
    _myListingsBloc.fetchMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('me_listings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createNewListing,
          )
        ],
      ),
      body: ContentStreamBuilder(
        stream: _myListingsBloc.productsStream,
        onHasData: (data) {
          return _buildSingleChildScrollView(data);
        },
      ),
    );
  }

  Widget _buildSingleChildScrollView(List<Product> products) {
    return products.isNotEmpty
        ? MyListingsScrollView(
            products: products,
          )
        : MyListingsEmptyState(
            stringFunction: string,
            onPressed: _createNewListing,
          );
  }

  _createNewListing() {
    navigation.pushReplacement(Consumer<NewListingBloc>(
      builder: (context, bloc, child) => NewListing(
        bloc: bloc,
      ),
    ));
  }
}

class MyListingsScrollView extends StatelessWidget {
  final List<Product> products;

  const MyListingsScrollView({Key key, @required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ProductGrid(products: products),
    );
  }
}

class MyListingsEmptyState extends StatelessWidget {
  final GetLocalizedStringFunction stringFunction;
  final VoidCallback onPressed;

  const MyListingsEmptyState({
    Key key,
    @required this.stringFunction,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(32)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Body2Text(
            stringFunction('my_listings_empty_state'),
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
