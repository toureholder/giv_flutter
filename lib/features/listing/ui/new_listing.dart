import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/edit_categories.dart';
import 'package:giv_flutter/features/listing/ui/edit_description.dart';
import 'package:giv_flutter/features/listing/ui/edit_title.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/colors.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewListing extends StatefulWidget {
  final Product product;
  final NewListingBloc bloc;

  const NewListing({Key key, @required this.bloc, this.product})
      : super(key: key);

  @override
  _NewListingState createState() => _NewListingState();
}

class _NewListingState extends BaseState<NewListing> {
  NewListingBloc _bloc;
  ScrollController _listViewController = ScrollController();
  Product _product;
  bool _isTitleError = false;
  bool _isDescriptionError = false;
  bool _isCategoryError = false;
  bool _isTelephoneError = false;
  bool _isLocationError = false;
  bool _isInformationValid = false;
  bool _areImagesValid = true;
  bool _userNeedsToAddPhoneNumber = false;
  User _user;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    _product = widget.product?.copy() ?? Product();
    _product.images = _product.images ?? <CustomImage.Image>[];
    _bloc = NewListingBloc.from(widget.bloc, _isEditing);
    _user = _bloc.getUser();
    _userNeedsToAddPhoneNumber = (_user?.hasPhoneNumber ?? false) == false;

    _resolveLocation();
    _listenToSavedProductStream();
  }

  void _listenToSavedProductStream() {
    _bloc.savedProductStream
        ?.listen(_onSaveSuccess, onError: _handleUploadError);
  }

  void _resolveLocation() {
    if (_product.location == null) {
      _product.location = _bloc.getPreferredLocation();
      return;
    }

    if (_product.isLocationComplete == false) {
      _bloc.loadCompleteLocation(_product.location);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final title = _isEditing ? 'edit_listing_title' : 'new_listing_title';

    final page = _user != null
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: CustomScaffold(
              appBar: CustomAppBar(
                title: string(title),
              ),
              body: _uploadStatusStreamBuilder(),
            ),
          )
        : Consumer<LogInBloc>(
            builder: (context, bloc, child) => SignIn(
              bloc: bloc,
              redirect: NewListing(bloc: widget.bloc),
            ),
          );

    return page;
  }

  Stack _buildStack(StreamEvent<double> uploadStatus) {
    return Stack(
      children: <Widget>[
        _buildMainListView(context),
        _buildProgressPositioned(uploadStatus: uploadStatus),
        _buildActionPositioned(uploadStatus: uploadStatus),
      ],
    );
  }

  StreamBuilder<StreamEvent<double>> _uploadStatusStreamBuilder() {
    return StreamBuilder(
      stream: _bloc.uploadStatusStream,
      builder: (context, snapshot) {
        return _buildStack(snapshot.data);
      },
    );
  }

  Widget _buildProgressPositioned({StreamEvent<double> uploadStatus}) {
    return uploadStatus != null && uploadStatus.isLoading
        ? Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              color: Color(0xCCFFFFFF),
            ))
        : Container();
  }

  ListView _buildMainListView(BuildContext context) {
    return ListView(
      controller: _listViewController,
      children: <Widget>[
        _activeTile(),
        _sectionTitle(string('new_listing_section_title_photos')),
        _emptyImagesErrorMessage(),
        _buildImageList(context),
        _sectionTitle(string('new_listing_section_title_about')),
        ListingTitleListTile(
          value: _product.title,
          onTap: _editTitle,
          isError: _isTitleError,
        ),
        ListingDescriptionListTile(
            value: _product.description,
            onTap: _editDescription,
            isError: _isDescriptionError),
        _categoriesTile(_product.categories),
        _phoneNumberTile(),
        _locationComponent(),
        Spacing.vertical(Dimens.bottom_action_button_container_height),
      ],
    );
  }

  Widget _activeTile() {
    if (!_isEditing) return Container();

    final isActive = _product.isActive;
    final title =
        isActive ? 'edit_listing_is_active' : 'edit_listing_is_inactive';
    final subtitle = isActive
        ? 'edit_listing_is_active_hint'
        : 'edit_listing_is_inactive_hint';

    return Column(
      children: <Widget>[
        SwitchListTile(
          value: _product.isActive,
          onChanged: (bool value) {
            setState(() {
              _product.isActive = value;
            });
          },
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: BodyText(
              string(title),
              weight: SyntheticFontWeight.semiBold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Body2Text(
              string(subtitle),
              color: Colors.grey,
            ),
          ),
        ),
        CustomDivider(),
      ],
    );
  }

  Widget _locationTile(Location location) {
    final value = location == null || location.equals(Location())
        ? null
        : location.shortName;

    return ListingLocationListTile(
      value: value,
      onTap: () {
        _editLocation(location);
      },
      isError: _isLocationError,
    );
  }

  Widget _emptyImagesErrorMessage() {
    return _areImagesValid
        ? Container()
        : EmptyImagesErrorMessage(stringFunction: string);
  }

  Widget _categoriesTile(List<ProductCategory> categories) {
    final value = categories?.isEmpty ?? true
        ? null
        : ProductCategory.getCategoryListTitles(categories);

    final onTap =
        categories?.isEmpty ?? true ? _addFirstCategory : _editCategories;

    return ListingCategoryListTile(
      value: value,
      onTap: onTap,
      isError: _isCategoryError,
    );
  }

  Widget _phoneNumberTile() {
    return (_user == null || _userNeedsToAddPhoneNumber == false)
        ? Container()
        : PhoneNumberListTile(
            user: _user,
            onTap: () {
              _editPhoneNumber(_user);
            },
            isError: _isTelephoneError,
          );
  }

  Widget _locationComponent() {
    if (_product.isLocationComplete) {
      return _locationTile(_product.location);
    }

    return ListingLocationStreamBuilder(
      stream: _bloc.locationStream,
      builder: (context, snapshot) {
        _product.location = snapshot.data;
        return _locationTile(_product.location);
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.default_horizontal_margin,
          right: Dimens.default_horizontal_margin,
          top: 32.0,
          bottom: 8.0),
      child: Subtitle(text,
          weight: SyntheticFontWeight.bold,
          color: Theme.of(context).primaryColor),
    );
  }

  Positioned _buildActionPositioned({StreamEvent<double> uploadStatus}) {
    final child = (uploadStatus != null && uploadStatus.isLoading)
        ? _buildProgressIndicator(uploadStatus.data)
        : NewListingSubmitButton(
            isEditing: _isEditing,
            stringFunction: string,
            onPressed: _submitForm,
          );

    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomDivider(),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.default_horizontal_margin, vertical: 12.0),
              alignment: Alignment.center,
              child: child,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double value) {
    final text =
        _isEditing ? 'edit_listing_uploading' : 'new_listing_uploading';

    return Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.button_border_radius),
            child: SizedBox(
              height: Dimens.button_flat_height,
              child: LinearProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]),
                backgroundColor: Colors.grey[200],
              ),
            )),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: Body2Text(
              string(text),
              weight: SyntheticFontWeight.semiBold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildImageList(BuildContext context) {
    final images = _product.images ?? [];

    return Padding(
      padding: EdgeInsets.only(top: Dimens.grid(4), bottom: Dimens.grid(4)),
      child: SizedBox(
        height: Dimens.home_product_image_dimension,
        child: ListView.builder(
          padding: EdgeInsets.only(right: Dimens.default_horizontal_margin),
          scrollDirection: Axis.horizontal,
          itemCount: images.length + 1,
          itemBuilder: (context, i) {
            return i == images.length
                ? _newPhotoButton()
                : _productPhoto(images[i]);
          },
        ),
      ),
    );
  }

  Widget _productPhoto(CustomImage.Image image) {
    final widget = image.hasUrl
        ? CachedNetworkImage(
            placeholder: (context, url) => RoundedCorners(
              child: Container(
                height: Dimens.home_product_image_dimension,
                width: Dimens.home_product_image_dimension,
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
            ),
            fit: BoxFit.cover,
            width: Dimens.home_product_image_dimension,
            imageUrl: image.url,
          )
        : Image.file(
            image.file,
            height: Dimens.home_product_image_dimension,
            width: Dimens.home_product_image_dimension,
            fit: BoxFit.cover,
          );

    return NewListingImageContainer(
      child: widget,
      onTap: () {
        _viewPhoto(image);
      },
    );
  }

  Widget _newPhotoButton() => _product.images.length >= Config.maxProductImages
      ? Container()
      : NewListingNewPhotoButton(onTap: _showAddImageModal);

  void _scrollToTop() {
    _listViewController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _scrollToBottom() {
    _listViewController.animateTo(_listViewController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _editPhoneNumber(User user) async {
    final result = await navigation.push(EditPhoneNumber(
      settingsBloc: Provider.of<SettingsBloc>(context),
      user: user,
    ));
    if (result != null) {
      _isTelephoneError = false;
      _user = _bloc.getUser();
    }
  }

  void _editTitle() async {
    final result = await navigation.push(EditTitle(
      title: _product.title,
    ));

    if (result != null) {
      setState(() {
        _product.title = result;
        _isTitleError = false;
      });
    }
  }

  void _editDescription() async {
    final result = await navigation.push(EditDescription(
      description: _product.description,
    ));

    if (result != null) {
      setState(() {
        _product.description = result;
        _isDescriptionError = false;
      });
    }
  }

  void _editLocation(Location location) async {
    final result = await navigation.push(Consumer<LocationFilterBloc>(
      builder: (context, bloc, child) => LocationFilter(
        bloc: bloc,
        location: location,
        showSaveButton: true,
      ),
    ));

    if (result != null) {
      setState(() {
        _isLocationError = false;
        _product.location = result;
      });
    }
  }

  void _editCategories() async {
    final editedList = <ProductCategory>[];
    editedList.addAll(_product.categories);

    final result =
        await navigation.push(EditCategories(categories: editedList));

    if (result != null) {
      setState(() {
        _product.categories = result;
        _isCategoryError = false;
      });
    }
  }

  void _addFirstCategory() async {
    final result = await navigation.push(Categories(
      bloc: Provider.of<CategoriesBloc>(context),
      showSearch: false,
      returnChoice: true,
      fetchAll: true,
    ));

    if (result != null) {
      setState(() {
        _addCategory(result);
        _isCategoryError = false;
      });
    }
  }

  void _addCategory(ProductCategory category) {
    _product.categories = _product.categories ?? [];

    final found = _product.categories.where((it) => it.id == category.id);
    if (found.isNotEmpty) return;

    _product.categories.add(category);
  }

  void _showAddImageModal() {
    final tiles = <BottomSheetTile>[
      BottomSheetTile(
          iconData: Icons.photo_camera,
          text: string('image_picker_modal_camera'),
          onTap: _openCamera),
      BottomSheetTile(
          iconData: Icons.image,
          text: string('image_picker_modal_gallery'),
          onTap: _openGallery),
    ];

    CustomBottomSheet.show(context,
        tiles: tiles, title: string('image_picker_modal_title'));
  }

  Future _openCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(imageFile);
  }

  Future _openGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(imageFile);
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: Config.croppedProductImageRatioX,
      ratioY: Config.croppedProductImageRatioY,
      maxWidth: Config.croppedProductImageMaxHeight,
      maxHeight: Config.croppedProductImageMaxWidth,
      toolbarTitle: string('image_cropper_toolbar_title'),
      toolbarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
    );

    if (croppedFile == null) return;

    final newImage = CustomImage.Image(file: croppedFile);

    setState(() {
      _product.images.add(newImage);
      _areImagesValid = true;
    });
  }

  _viewPhoto(CustomImage.Image image) async {
    final result = await navigation.push(PhotoViewPage(
      image: image,
      actions: <Widget>[
        MediumFlatDangerButton(
          text: string('common_remove'),
          onPressed: () {
            navigation.pop(actionDelete);
          },
        ),
      ],
    ));

    if (result as String == actionDelete) {
      setState(() {
        _product.images.removeWhere((it) =>
            ((it.file?.path != null && it.file?.path == image.file?.path) ||
                (it.url != null && it.url == image.url)));
      });
    }
  }

  bool _validateForm() {
    setState(() {
      _isTitleError = _product.title == null || _product.title.isEmpty;
      _isDescriptionError =
          _product.description == null || _product.description.isEmpty;
      _isCategoryError =
          _product.categories == null || _product.categories.isEmpty;
      _isTelephoneError =
          _user.phoneNumber == null || _user.phoneNumber.isEmpty;
      _isLocationError =
          _product.location == null || _product.location.equals(Location());

      _isInformationValid = !_isTitleError &&
          !_isDescriptionError &&
          !_isCategoryError &&
          !_isTelephoneError &&
          !_isLocationError;

      _areImagesValid = _product.images?.isNotEmpty ?? false;
    });

    if (!_isInformationValid) {
      _scrollToBottom();
    } else if (!_areImagesValid) {
      _scrollToTop();
    }

    return _isInformationValid && _areImagesValid;
  }

  _submitForm() {
    if (_validateForm()) _bloc.saveProduct(_product);
  }

  _onSaveSuccess(Product product) {
    if (_isEditing)
      navigation.pop(product);
    else
      navigation.pushReplacement(Consumer<MyListingsBloc>(
        builder: (context, bloc, child) => MyListings(
          bloc: bloc,
        ),
      ));
  }

  Future<bool> _onWillPop() {
    final message = _isEditing
        ? 'edit_listing_cancel_confirmation_message'
        : 'new_listing_cancel_confirmation_message';

    return _product.isNotEmpty
        ? showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(string('new_listing_cancel_confirmation_title')),
                content: Text(string(message)),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(string('common_no')),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(string('common_yes')),
                  ),
                ],
              ),
            ) ??
            false
        : Future<bool>.value(true);
  }

  _handleUploadError(error) {
    showGenericErrorDialog(
        message: GetLocalizedStringFunction(context)(
            'error_upload_listing_report_message'));
  }

  static const actionDelete = 'ACTION_DELETE';
}

class NewListingImageContainer extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;

  const NewListingImageContainer({
    Key key,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: Dimens.default_horizontal_margin),
        child: RoundedCorners(
          child: child,
        ),
      ),
    );
  }
}

class NewListingNewPhotoButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const NewListingNewPhotoButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimens.default_horizontal_margin),
      child: RoundedCorners(
        child: Container(
          height: Dimens.home_product_image_dimension,
          width: Dimens.home_product_image_dimension,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyImagesErrorMessage extends StatelessWidget {
  final GetLocalizedStringFunction stringFunction;

  const EmptyImagesErrorMessage({Key key, this.stringFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.default_horizontal_margin),
        child: Body2Text(
          stringFunction('new_listing_images_hint'),
          color: Colors.red,
        ),
      );
}

class NewListingSubmitButton extends StatelessWidget {
  final GetLocalizedStringFunction stringFunction;
  final VoidCallback onPressed;
  final bool isEditing;

  const NewListingSubmitButton({
    Key key,
    @required this.isEditing,
    @required this.onPressed,
    @required this.stringFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        isEditing ? 'edit_listing_action_save' : 'new_listing_action_create';

    return PrimaryButton(text: stringFunction(text), onPressed: onPressed);
  }
}

class NewListingDetailTile extends StatelessWidget {
  final String value;
  final String caption;
  final String emptyStateCaption;
  final GestureTapCallback onTap;
  final bool isError;

  const NewListingDetailTile({
    Key key,
    this.value,
    this.caption,
    this.emptyStateCaption,
    this.onTap,
    this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null;

    var finalValue = value ?? caption;

    var finalCaption = isEmpty ? emptyStateCaption : caption;
    final fontWeight =
        isEmpty ? SyntheticFontWeight.regular : SyntheticFontWeight.semiBold;
    final valueColor = isEmpty ? Colors.grey[700] : CustomTypography.baseColor;

    final captionColor = isError ? CustomColors.errorColor : Colors.grey;

    final captionRowChildren = <Widget>[
      Body2Text(finalCaption, color: captionColor, weight: fontWeight),
    ];

    if (!isEmpty) {
      captionRowChildren.addAll(<Widget>[
        Spacing.horizontal(4.0),
        Icon(
          Icons.check,
          size: 16.0,
          color: Colors.green,
        )
      ]);
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16.0, horizontal: Dimens.default_horizontal_margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BodyText(
                finalValue,
                weight: fontWeight,
                color: valueColor,
              ),
              Row(
                children: captionRowChildren,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberListTile extends StatelessWidget {
  final User user;
  final GestureTapCallback onTap;
  final bool isError;

  const PhoneNumberListTile({
    Key key,
    @required this.user,
    @required this.onTap,
    @required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return NewListingDetailTile(
      value: user?.phoneNumber == null
          ? null
          : '+${user.countryCallingCode} ${user.phoneNumber}',
      caption: stringFunction('settings_phone_number'),
      emptyStateCaption:
          stringFunction('new_listing_tile_phone_number_empty_state'),
      onTap: onTap,
      isError: isError,
    );
  }
}

class ListingTitleListTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;
  final bool isError;

  const ListingTitleListTile({
    Key key,
    @required this.onTap,
    @required this.isError,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return NewListingDetailTile(
      value: value,
      caption: stringFunction('new_listing_tile_name'),
      emptyStateCaption: stringFunction('new_listing_tile_name_empty_state'),
      onTap: onTap,
      isError: isError,
    );
  }
}

class ListingDescriptionListTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;
  final bool isError;

  const ListingDescriptionListTile({
    Key key,
    @required this.onTap,
    @required this.isError,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return NewListingDetailTile(
      value: value,
      caption: stringFunction('new_listing_tile_description'),
      emptyStateCaption:
          stringFunction('new_listing_tile_description_empty_state'),
      onTap: onTap,
      isError: isError,
    );
  }
}

class ListingCategoryListTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;
  final bool isError;

  const ListingCategoryListTile({
    Key key,
    @required this.onTap,
    @required this.isError,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return NewListingDetailTile(
      value: value,
      caption: stringFunction('new_listing_tile_category'),
      emptyStateCaption:
          stringFunction('new_listing_tile_category_empty_state'),
      onTap: onTap,
      isError: isError,
    );
  }
}

class ListingLocationListTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;
  final bool isError;

  const ListingLocationListTile({
    Key key,
    @required this.onTap,
    @required this.isError,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return NewListingDetailTile(
      value: value,
      caption: stringFunction('new_listing_tile_location'),
      emptyStateCaption:
          stringFunction('new_listing_tile_location_empty_state'),
      onTap: onTap,
      isError: isError,
    );
  }
}

class ListingLocationStreamBuilder extends StatelessWidget {
  final Stream stream;
  final AsyncWidgetBuilder builder;

  const ListingLocationStreamBuilder({Key key, this.stream, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: builder,
    );
  }
}
