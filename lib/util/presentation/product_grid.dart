import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/product_detail.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool addLinkToUserProfile;
  final bool isSelecting;
  final Function onItemSelected;
  final List<int> selectedListingsIds;

  const ProductGrid({
    Key key,
    @required this.products,
    this.onItemSelected,
    this.addLinkToUserProfile = true,
    this.isSelecting = false,
    this.selectedListingsIds,
  }) : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends BaseState<ProductGrid> {
  List<Product> _products;
  bool _addLinkToUserProfile;
  bool _isSelecting;
  Function _onItemSelected;
  List<int> _selectedListingsIds;

  @override
  void initState() {
    super.initState();
    _products = widget.products;
    _addLinkToUserProfile = widget.addLinkToUserProfile;
    _isSelecting = widget.isSelecting;
    _onItemSelected = widget.onItemSelected;
    _selectedListingsIds = widget.selectedListingsIds ?? [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: _buildCustomGrid(_products),
    );
  }

  List<Row> _buildCustomGrid(List<Product> products) {
    const GRID_COLUMNS = 2;
    var grid = <Row>[];
    var i = 0;
    products.forEach((product) {
      if (grid.isEmpty || grid.last.children.length == GRID_COLUMNS) {
        var isLastItem = (i == products.length - 1) ? true : false;
        grid.add(_newGridRow(product, isLastItem: isLastItem));
      } else {
        grid.last.children.add(
          _newGridCell(product),
        );
      }
      i++;
    });
    return grid;
  }

  Row _newGridRow(Product product, {bool isLastItem = false}) {
    var row = new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _newGridCell(product),
      ],
    );

    if (isLastItem) {
      row.children.add(_emptyGridCell());
    }

    return row;
  }

  Expanded _newGridCell(Product product) {
    final isSelected = _selectedListingsIds.contains(product.id);
    return Expanded(
      child: _buildGridCell(product: product, isSelected: isSelected),
    );
  }

  Expanded _emptyGridCell() {
    return Expanded(
      child: SizedBox(),
    );
  }

  Widget _buildGridCell({Product product, bool isSelected}) {
    final foregroundDecoration = product.isActive
        ? null
        : BoxDecoration(color: CustomColors.inActiveForeground);

    final stack = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _productImage(product: product, isSelected: isSelected),
          _productTitle(product),
        ],
      ),
    ];

    if (_isSelecting) {
      final icon = isSelected ? Icons.check_circle : Icons.radio_button_off;

      stack.add(
        ProductGridSelectionRadio(icon: icon),
      );
    }

    if (product.isDonationRequest) {
      stack.add(ProductGrodDonationRequestBadge());
    }

    final onTap = _isSelecting
        ? () {
            _onItemSelected.call(product.id);
          }
        : () {
            _goToProductDetail(product);
          };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.grid(6)),
        foregroundDecoration: foregroundDecoration,
        child: Stack(
          children: stack,
        ),
      ),
    );
  }

  Widget _productTitle(Product product) {
    return Container(
      padding: EdgeInsets.only(top: Dimens.grid(4)),
      child: Body2Text(
        product.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _productImage({Product product, bool isSelected}) {
    final color = !_isSelecting
        ? null
        : isSelected
            ? Colors.black.withOpacity(0.33)
            : Colors.black.withOpacity(0.165);

    return RoundedCorners(
      child: CachedNetworkImage(
        placeholder: (context, url) => RoundedCorners(
          child: Container(
            height: Dimens.home_product_image_dimension,
            width: Dimens.home_product_image_dimension,
            decoration: BoxDecoration(color: Colors.grey[200]),
          ),
        ),
        fit: BoxFit.cover,
        height: Dimens.search_result_image_height,
        imageUrl: product.images.first.url,
        color: color,
        colorBlendMode: BlendMode.darken,
      ),
    );
  }

  _goToProductDetail(Product product) async {
    final result = await navigation.push(Consumer<ProductDetailBloc>(
      builder: (context, bloc, child) => ProductDetail(
        product: product,
        bloc: bloc,
        addLinkToUserProfile: _addLinkToUserProfile,
      ),
    ));

    if (result != null && result is Product) {
      final productIndex = _products.indexWhere((it) => it.id == product.id);
      setState(() {
        _products[productIndex] = result;
      });
    }
  }
}

class ProductGridSelectionRadio extends StatelessWidget {
  const ProductGridSelectionRadio({
    Key key,
    @required this.icon,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Icon(
        icon,
        color: Colors.white,
        size: 36.0,
      ),
      top: Dimens.grid(4),
      left: Dimens.grid(4),
    );
  }
}

class ProductGrodDonationRequestBadge extends StatelessWidget {
  const ProductGrodDonationRequestBadge({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.default_chip_border_radius),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Body2Text(
          GetLocalizedStringFunction(context)('common_donation_request'),
          color: CustomColors.accentColorText,
          weight: SyntheticFontWeight.semiBold,
        ),
      ),
      top: Dimens.search_result_image_height - Dimens.grid(19),
      left: Dimens.grid(6),
    );
  }
}
