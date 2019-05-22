import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/i_want_it_dialog.dart';
import 'package:giv_flutter/features/user_profile/ui/user_profile.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final bool isMine;

  const ProductDetail({Key key, this.product, this.isMine = false})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BaseState<ProductDetail> {
  Product _product;
  ProductDetailBloc _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _productDetailBloc = ProductDetailBloc();
    _productDetailBloc.fetchLocationDetails(_product.location);
    _listenToDeleteStream();
    _listenToUpdateStream();
  }

  void _listenToDeleteStream() {
    _productDetailBloc.deleteListingStream
        .listen((HttpResponse<ApiModelResponse> response) {
      if (response.isReady) _onDeleteListingResponse(response);
    });
  }

  void _listenToUpdateStream() {
    _productDetailBloc.updateListingStream
        .listen((HttpResponse<Product> response) {
      if (response.isReady) _onUpdateListingResponse(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<StreamEventState>(
        stream: _productDetailBloc.loadingStream,
        builder: (context, AsyncSnapshot<StreamEventState> snapshot) {
          final state = snapshot.data;
          return buildStack(context,
              isDeleting: state == StreamEventState.loading);
        });
  }

  Stack buildStack(BuildContext context, {bool isDeleting}) {
    final children = <Widget>[
      _buildCustomScaffold(context),
    ];

    if (isDeleting) children.add(_buildDeletingLoadingState());

    return Stack(
      children: children,
    );
  }

  Widget _buildDeletingLoadingState() {
    return Material(
      color: CustomColors.inActiveForeground,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  CustomScaffold _buildCustomScaffold(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        leading: IconButton(
            icon: BackButtonIcon(), onPressed: () => navigation.pop(_product)),
        actions: widget.isMine ? _appBarActions() : null,
      ),
      body: _buildMainListView(context),
    );
  }

  ListView _buildMainListView(BuildContext context) {
    return ListView(children: <Widget>[
      _imageCarousel(context, _product.images),
      _textPadding(H6Text(_product.title)),
      _locationStreamBuilder(),
      _iWantItButton(context),
      _textPadding(Body2Text(_product.description)),
      _publishedAt(),
      Spacing.vertical(Dimens.grid(8)),
      Divider(),
      Spacing.vertical(Dimens.grid(8)),
      _userRow(),
      Spacing.vertical(Dimens.grid(16)),
    ]);
  }

  List<Widget> _appBarActions() {
    return [
      IconButton(
          icon: Icon(Icons.more_vert), onPressed: _showActionsBottomSheet)
    ];
  }

  _showActionsBottomSheet() {
    IconData activateTileIcon = Icons.visibility;
    String activateTileTextKey = 'product_detail_action_reactivate';

    if (_product.isActive) {
      activateTileIcon = Icons.visibility_off;
      activateTileTextKey = 'product_detail_action_hide';
    }

    final tiles = <BottomSheetTile>[
      BottomSheetTile(
          iconData: activateTileIcon,
          text: string(activateTileTextKey),
          onTap: _confirmHideOrActivate),
      BottomSheetTile(
          iconData: Icons.edit,
          text: string('product_detail_action_edit'),
          onTap: _editListing),
      BottomSheetTile(
          iconData: Icons.delete,
          text: string('product_detail_action_delete'),
          onTap: _confirmDelete),
    ];

    CustomBottomSheet.show(context,
        tiles: tiles, title: string('shared_title_options'));
  }

  Padding _publishedAt() {
    return _textPadding(Body2Text(string('published_on_',
        formatArg:
            DateFormat.yMMMMd(localeString).format(_product.updatedAt))));
  }

  Widget _locationStreamBuilder() {
    return StreamBuilder<Location>(
        stream: _productDetailBloc.locationStream,
        builder: (context, AsyncSnapshot snapshot) {
          return _locationWidget(snapshot.data);
        });
  }

  Widget _locationWidget(Location location) {
    if (location?.isOk ?? false) _product?.location = location;

    Widget locationWidget = location == null
        ? Padding(
            padding: EdgeInsets.only(
              left: Dimens.default_horizontal_margin,
              right: 200.0,
              top: 29.0,
              bottom: 4.0,
            ),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
              backgroundColor: Colors.grey[100],
            ))
        : _textPadding(Subtitle(
            location?.mediumName ?? '',
            weight: SyntheticFontWeight.semiBold,
          ));

    return locationWidget;
  }

  Widget _iWantItButton(BuildContext context) {
    if (widget.isMine) return Container();

    final user = _product.user;
    final message =
        string('whatsapp_message_interested', formatArg: _product.title);

    return Padding(
      padding: EdgeInsets.all(Dimens.default_horizontal_margin),
      child: PrimaryButton(
          text: string('i_want_it'),
          onPressed: () {
            if (user.phoneNumber != null) _showIWantItDialog(message);
          }),
    );
  }

  Padding _userRow() {
    final user = _product.user;
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: GestureDetector(
        onTap: _goToUserProfile,
        child: Row(
          children: <Widget>[
            AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
            Spacing.horizontal(Dimens.grid(6)),
            Body2Text(user.name)
          ],
        ),
      ),
    );
  }

  Padding _textPadding(Widget widget) {
    return Padding(
      padding: EdgeInsets.only(
          top: Dimens.default_vertical_margin,
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: widget,
    );
  }

  Widget _imageCarousel(BuildContext context, List<CustomImage.Image> images) {
    final _pageController = PageController();

    final imageUrls = images.map((it) => it.url).toList();

    return ImageCarousel(
      imageUrls: imageUrls,
      height: 300.0,
      pageController: _pageController,
      onTap: () {
        int index = _pageController.page.toInt();
        navigation.push(PhotoViewPage(image: images[index]));
      },
      withIndicator: true,
      isFaded: !_product.isActive,
    );
  }

  void _confirmDelete() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string('delete_listing_confirmation_title')),
            content: Text(string('delete_listing_confirmation_content')),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('shared_action_cancel')),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: Text(
                    string('delete_listing_accept_button'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: _deleteListing)
            ],
          );
        });
  }

  void _confirmHideOrActivate() {
    String dialogTitleTextKey = 'reactivate_listing_confirmation_title';
    String dialogContentTextKey = 'reactivate_listing_confirmation_content';
    String dialogAcceptButtonTextKey = 'reactivate_listing_accept_button';
    bool shouldActivate = true;

    if (_product.isActive) {
      dialogTitleTextKey = 'hide_listing_confirmation_title';
      dialogContentTextKey = 'hide_listing_confirmation_content';
      dialogAcceptButtonTextKey = 'hide_listing_accept_button';
      shouldActivate = false;
    }

    final request =
        UpdateListingActiveStatusRequest(_product.id, shouldActivate);

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(string(dialogTitleTextKey)),
            content: Text(string(dialogContentTextKey)),
            actions: <Widget>[
              FlatButton(
                  child: Text(string('shared_action_cancel')),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: Text(string(dialogAcceptButtonTextKey)),
                  onPressed: () => _updateStatus(request))
            ],
          );
        });
  }

  _updateStatus(UpdateListingActiveStatusRequest request) {
    Navigator.of(context).pop();
    _productDetailBloc.updateListing(request);
  }

  _editListing() async {
    final result = await navigation.push(NewListing(
      product: _product,
    ));

    if (result != null && result is Product) setState(() => _product = result);
  }

  _deleteListing() {
    Navigator.of(context).pop();
    _productDetailBloc.deleteListing(_product.id);
  }

  _goToUserProfile() {
    navigation.push(UserProfile(
      user: _product.user,
    ));
  }

  _showIWantItDialog(String message) async {
    var isAuthenticated = await Prefs.isAuthenticated();

    final fullPhoneNumber =
        '${_product?.user?.countryCallingCode}${_product?.user?.phoneNumber}';

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return IWantItDialog(
            phoneNumber: fullPhoneNumber,
            message: message,
            isAuthenticated: isAuthenticated,
          );
        });
  }

  _onDeleteListingResponse(HttpResponse<ApiModelResponse> response) {
    switch (response.status) {
      case HttpStatus.ok:
        goToMyListingsReloaded();
        break;
      default:
        showGenericErrorDialog();
    }
  }

  _onUpdateListingResponse(HttpResponse<Product> response) {
    switch (response.status) {
      case HttpStatus.ok:
        setState(() => _product = response.data);
        break;
      default:
        showGenericErrorDialog();
    }
  }
}
