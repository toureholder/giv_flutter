import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
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

class MyListings extends StatefulWidget {
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends BaseState<MyListings> {
  MyListingsBloc _myListingsBloc;

  @override
  void initState() {
    super.initState();
    _myListingsBloc = MyListingsBloc();
    _myListingsBloc.fetchMyProducts();
  }

  @override
  void dispose() {
    _myListingsBloc.dispose();
    super.dispose();
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
        ? SingleChildScrollView(
            child: ProductGrid(
              products: products,
              isMine: true,
            ),
          )
        : _buildEmptyState();
  }

  Container _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.grid(32)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Body2Text(
            string('my_listings_empty_state'),
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          PrimaryButton(
            text: string('shared_action_create_ad'),
            onPressed: _createNewListing,
            fillWidth: false,
          )
        ],
      ),
    );
  }

  _createNewListing() {
    navigation.pushReplacement(NewListing());
  }
}
