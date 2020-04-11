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
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:bubble/bubble.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
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
  Location _detailedLocation;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _productDetailBloc = widget.bloc;
    _listenToLocationStream();
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

  void _listenToLocationStream() {
    _productDetailBloc.locationStream?.listen((Location location) {
      _detailedLocation = location;
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
      ProductDetailImageCarousel(
        images: _product.images,
        isProductActive: _product.isActive,
        onTapIsHiddenAlert: _confirmHideOrActivate,
      ),
      DefualtVerticalSpacing(),
      ProductDetailTitle(
        title: _product.title,
      ),
      DefualtVerticalSpacing(),
      ProductDetailLocationStreamBuilder(
        stream: _productDetailBloc.locationStream,
      ),
      DefualtVerticalSpacing(),
      if (!_isMine) IWantItButton(onPressed: _handleIWantItTap),
      ProductDetailDescription(
        description: _product.description,
      ),
      ProductDetailNoShippingAlertStreamBuilder(
        stream: _productDetailBloc.locationStream,
      ),
      DefualtVerticalSpacingAndAHalf(),
      ProductDetailUserContainer(
        product: _product,
        onTap: _goToUserProfile,
      )
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

  _handleIWantItTap() {
    if (_product.user.phoneNumber != null)
      _showIWantItDialog(
        string(
          'whatsapp_message_interested',
          formatArg: _product.title,
        ),
        _detailedLocation,
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

  _showIWantItDialog(String message, Location location) {
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
            location: location,
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
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.default_horizontal_margin),
          child: PrimaryButton(
            text: GetLocalizedStringFunction(context)('i_want_it'),
            onPressed: onPressed,
          ),
        ),
        DefualtVerticalSpacing(),
      ],
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

class ProductDetailImageCarousel extends StatelessWidget {
  final List<CustomImage.Image> images;
  final GestureTapCallback onTapIsHiddenAlert;
  final bool isProductActive;

  const ProductDetailImageCarousel({
    Key key,
    @required this.images,
    @required this.onTapIsHiddenAlert,
    @required this.isProductActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController();

    final imageUrls = images.map((it) => it.url).toList();

    final carousel =
        _theCarouselItself(context, imageUrls, _pageController, images);

    return isProductActive
        ? carousel
        : Stack(
            children: <Widget>[
              carousel,
              PositionedIsHiddenAlert(onTap: onTapIsHiddenAlert),
            ],
          );
  }

  ImageCarousel _theCarouselItself(BuildContext context, List<String> imageUrls,
      PageController _pageController, List<CustomImage.Image> images) {
    return ImageCarousel(
      imageUrls: imageUrls,
      height: 300.0,
      pageController: _pageController,
      onTap: () {
        int index = _pageController.page.toInt();
        Navigation(context).push(PhotoViewPage(image: images[index]));
      },
      withIndicator: true,
      isFaded: !isProductActive,
    );
  }
}

class ProductDetailTitle extends StatelessWidget {
  final String title;

  const ProductDetailTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) => ProductDetailHorizontalPadding(
        child: H6Text(title),
      );
}

class ProductDetailLocation extends StatelessWidget {
  final Location location;

  const ProductDetailLocation({Key key, this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget locationWidget = location == null
        ? Padding(
            padding: EdgeInsets.only(
              left: Dimens.default_horizontal_margin,
              right: 200.0,
              top: 8.0,
              bottom: 4.0,
            ),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
              backgroundColor: Colors.grey[100],
            ))
        : ProductDetailHorizontalPadding(
            child: Subtitle(
              location?.mediumName ?? '',
              weight: SyntheticFontWeight.semiBold,
            ),
          );

    return locationWidget;
  }
}

class ProductDetailLocationStreamBuilder extends StatelessWidget {
  final Stream<Location> stream;

  const ProductDetailLocationStreamBuilder({Key key, @required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Location>(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          return ProductDetailLocation(
            location: snapshot.data,
          );
        });
  }
}

class ProductDetailDescription extends StatelessWidget {
  final String description;

  const ProductDetailDescription({Key key, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ProductDetailHorizontalPadding(
        child: Body2Text(
          description,
        ),
      );
}

class ProductDetailPublishedAt extends StatefulWidget {
  final DateTime date;

  const ProductDetailPublishedAt({Key key, @required this.date})
      : super(key: key);

  @override
  _ProductDetailPublishedAtState createState() =>
      _ProductDetailPublishedAtState();
}

class _ProductDetailPublishedAtState
    extends BaseState<ProductDetailPublishedAt> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProductDetailHorizontalPadding(
      child: Body2Text(
        string(
          'published_on_',
          formatArg: DateFormat.yMMMMd(localeString).format(
            widget.date,
          ),
        ),
      ),
    );
  }
}

class ProductDetailNoShippingAlertStreamBuilder extends StatelessWidget {
  final Stream<Location> stream;

  const ProductDetailNoShippingAlertStreamBuilder(
      {Key key, @required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Location>(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container()
              : ProductDetailNoShippingAlert(
                  location: snapshot.data,
                );
        });
  }
}

class ProductDetailNoShippingAlert extends StatelessWidget {
  final Location location;

  const ProductDetailNoShippingAlert({Key key, @required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return Column(children: [
      DefualtVerticalSpacing(),
      ProductDetailHorizontalPadding(
        child: Body2Text(
          stringFunction(
            'product_detail_no_shipping_alert',
            formatArg: location?.mediumName,
          ),
          weight: SyntheticFontWeight.semiBold,
        ),
      ),
    ]);
  }
}

class ProductDetailUser extends StatelessWidget {
  final User user;
  final GestureTapCallback onTap;

  const ProductDetailUser({
    Key key,
    @required this.user,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AvatarImage(image: CustomImage.Image(url: user.avatarUrl)),
            Spacing.horizontal(Dimens.grid(6)),
            Flexible(
              child: Bubble(
                nip: BubbleNip.leftTop,
                shadowColor: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stringFunction(
                        'product_detail_user_introduction',
                        formatArg: user.name,
                      ),
                    ),
                    Spacing.vertical(5.0),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                          text: stringFunction('product_detail_user_see_all_donations_part_1'),
                          style: new TextStyle(color: CustomColors.textLinkColor),
                        ),
                        TextSpan(
                          text: stringFunction('product_detail_user_see_all_donations_part_2'),
                          style: new TextStyle(color: Colors.black),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailHorizontalPadding extends StatelessWidget {
  final Widget child;

  const ProductDetailHorizontalPadding({Key key, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.default_horizontal_margin,
        ),
        child: child,
      );
}

class ProductDetailUserContainer extends StatelessWidget {
  final Product product;
  final GestureTapCallback onTap;

  const ProductDetailUserContainer({
    Key key,
    @required this.product,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefualtVerticalSpacing(),
          ProductDetailUser(
            user: product.user,
            onTap: onTap,
          ),
          DefualtVerticalSpacing(),
          DefualtVerticalSpacing(),
        ],
      ),
    );
  }
}
