import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/i_want_it_dialog.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/settings.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
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
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final ProductDetailBloc bloc;

  const ProductDetail({
    Key key,
    @required this.bloc,
    @required this.product,
  }) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends BaseState<ProductDetail> {
  Product _product;
  ProductDetailBloc _productDetailBloc;
  bool _isMine;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _productDetailBloc = widget.bloc;
    _productDetailBloc.fetchLocationDetails(_product.location);
    _isMine = _productDetailBloc.isProductMine(_product.user.id);
    _listenToDeleteStream();
    _listenToUpdateStream();
  }

  void _listenToDeleteStream() {
    _productDetailBloc.deleteListingStream
        ?.listen((HttpResponse<ApiModelResponse> response) {
      if (response.isReady) _onDeleteListingResponse(response);
    });
  }

  void _listenToUpdateStream() {
    _productDetailBloc.updateListingStream
        ?.listen((HttpResponse<Product> response) {
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
              isLoading: state == StreamEventState.loading);
        });
  }

  Stack buildStack(BuildContext context, {bool isLoading}) {
    final children = <Widget>[_buildCustomScaffold(context)];

    if (isLoading) children.add(LoadingStateForeground());

    return Stack(children: children);
  }

  CustomScaffold _buildCustomScaffold(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        leading: BackIconButton(onPressed: () => navigation.pop(_product)),
        actions: _isMine ? _appBarActions() : null,
      ),
      body: _buildMainListView(context),
    );
  }

  ListView _buildMainListView(BuildContext context) {
    return ListView(children: <Widget>[
      _imageCarousel(context, _product.images),
      _textPadding(H6Text(_product.title)),
      _locationStreamBuilder(),
      _maybeIWantItButton(),
      _textPadding(Body2Text(_product.description)),
      _publishedAt(),
      Spacing.vertical(Dimens.grid(8)),
      Divider(),
      Spacing.vertical(Dimens.grid(8)),
      _userRow(),
      Spacing.vertical(Dimens.grid(16)),
    ]);
  }

  List<Widget> _appBarActions() =>
      [MoreIconButton(onPressed: _showActionsBottomSheet)];

  _showActionsBottomSheet() {
    final tiles = <Widget>[
      ToggleActivationBottomSheetTile(
          onTap: _confirmHideOrActivate, isActive: _product.isActive),
      EditBottomSheetTile(onTap: _editListing),
      DeleteBottomSheetTile(onTap: _confirmDelete),
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

  Widget _maybeIWantItButton() {
    return _isMine ? Container() : IWantItButton(onPressed: _handleIWantItTap);
  }

  _handleIWantItTap() {
    if (_product.user.phoneNumber != null)
      _showIWantItDialog(
        string(
          'whatsapp_message_interested',
          formatArg: _product.title,
        ),
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

    final carousel = _theCarouselItself(imageUrls, _pageController, images);

    return _product.isActive
        ? carousel
        : Stack(
            children: <Widget>[
              carousel,
              PositionedIsHiddenAlert(onTap: _confirmHideOrActivate),
            ],
          );
  }

  ImageCarousel _theCarouselItself(List<String> imageUrls,
      PageController _pageController, List<CustomImage.Image> images) {
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
    _productDetailBloc.updateActiveStatus(request);
  }

  _editListing() async {
    final result = await navigation.push(Consumer<NewListingBloc>(
      builder: (context, bloc, child) => NewListing(
        bloc: bloc,
        product: _product,
      ),
    ));

    if (result != null && result is Product) setState(() => _product = result);
  }

  _deleteListing() {
    Navigator.of(context).pop();
    _productDetailBloc.deleteListing(_product.id);
  }

  _goToUserProfile() {
    navigation.push(Consumer<UserProfileBloc>(
      builder: (context, bloc, child) => UserProfile(
        bloc: bloc,
        user: _product.user,
      ),
    ));
  }

  _showIWantItDialog(String message) {
    var isAuthenticated = _productDetailBloc.isAuthenticated();

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
            util: _productDetailBloc.util,
          );
        });
  }

  _onDeleteListingResponse(HttpResponse<ApiModelResponse> response) {
    switch (response.status) {
      case HttpStatus.ok:
        _goToMyListingsReloaded();
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

  void _goToMyListingsReloaded() {
    navigation.push(
      Base(),
      hasAnimation: false,
      clearStack: true,
    );
    navigation.push(
      Consumer<SettingsBloc>(
        builder: (context, bloc, child) => Settings(
          bloc: bloc,
        ),
      ),
      hasAnimation: false,
    );
    navigation.push(
        Consumer<MyListingsBloc>(
          builder: (context, bloc, child) => MyListings(
            bloc: bloc,
          ),
        ),
        hasAnimation: false);
  }
}

class IWantItButton extends StatelessWidget {
  final VoidCallback onPressed;

  const IWantItButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.default_horizontal_margin),
      child: PrimaryButton(
        text: GetLocalizedStringFunction(context)('i_want_it'),
        onPressed: onPressed,
      ),
    );
  }
}

class LoadingStateForeground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.inActiveForeground,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ToggleActivationBottomSheetTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final bool isActive;

  const ToggleActivationBottomSheetTile({
    Key key,
    @required this.onTap,
    @required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData activateTileIcon = Icons.visibility;
    String activateTileTextKey = 'product_detail_action_reactivate';

    if (isActive) {
      activateTileIcon = Icons.visibility_off;
      activateTileTextKey = 'product_detail_action_hide';
    }

    return BottomSheetTile(
      iconData: activateTileIcon,
      text: GetLocalizedStringFunction(context)(activateTileTextKey),
      onTap: onTap,
    );
  }
}

class EditBottomSheetTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const EditBottomSheetTile({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTile(
      iconData: Icons.edit,
      text: GetLocalizedStringFunction(context)('product_detail_action_edit'),
      onTap: onTap,
    );
  }
}

class DeleteBottomSheetTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const DeleteBottomSheetTile({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTile(
      iconData: Icons.delete,
      text: GetLocalizedStringFunction(context)('product_detail_action_delete'),
      onTap: onTap,
    );
  }
}

class PositionedIsHiddenAlert extends StatelessWidget {
  final GestureTapCallback onTap;

  const PositionedIsHiddenAlert({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(Dimens.default_horizontal_margin),
            color: Theme.of(context).primaryColor,
            child: Center(
                child: Body2Text(
              GetLocalizedStringFunction(context)(
                  'product_detail_inactive_listing_alert'),
              textAlign: TextAlign.center,
              color: Colors.white,
            )),
          ),
        ));
  }
}
