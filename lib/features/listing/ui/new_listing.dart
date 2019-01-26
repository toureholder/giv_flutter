import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/edit_categories.dart';
import 'package:giv_flutter/features/listing/ui/edit_description.dart';
import 'package:giv_flutter/features/listing/ui/edit_title.dart';
import 'package:giv_flutter/features/listing/ui/my_listings.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/features/product/filters/ui/location_filter.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/photo_view_page.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewListing extends StatefulWidget {
  final Product product;

  const NewListing({Key key, this.product}) : super(key: key);

  @override
  _NewListingState createState() => _NewListingState();
}

class _NewListingState extends BaseState<NewListing> {
  NewListingBloc _newListingBloc;
  ScrollController _listViewController = ScrollController();
  Product _product;
  bool _isTitleError = false;
  bool _isDescriptionError = false;
  bool _isCategoryError = false;
  bool _isTelephoneError = false;
  bool _isLocationError = false;
  bool _isInformationValid = false;
  bool _areImagesValid = true;
  User _user;

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? Product();
    _product.images = _product.images ?? <CustomImage.Image>[];
    _newListingBloc = NewListingBloc();
    _newListingBloc.loadUser();
    _newListingBloc.loadLocation();
    _newListingBloc.uploadStatusStream.listen((StreamEvent<double> event) {
      if (event.isReady) _onUploadSuccess();
    });
  }

  @override
  void dispose() {
    _newListingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: string('new_listing_title'),
        ),
        body: _uploadStatusStreamBuilder(),
      ),
    );
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
      stream: _newListingBloc.uploadStatusStream,
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
        _sectionTitle(string('new_listing_section_title_photos')),
        _emptyImagesErrorMessage(),
        _buildImageList(context),
        _sectionTitle(string('new_listing_section_title_about')),
        _detailsItemTile(
            value: _product.title,
            caption: string('new_listing_tile_name'),
            emptyStateCaption: string('new_listing_tile_name_empty_state'),
            onTap: _editTitle,
            isError: _isTitleError),
        _detailsItemTile(
            value: _product.description,
            caption: string('new_listing_tile_description'),
            emptyStateCaption:
                string('new_listing_tile_description_empty_state'),
            onTap: _editDescription,
            isError: _isDescriptionError),
        _categoriesTile(_product.categories),
        _phoneNumberStreamBuilder(),
        _locationStreamBuilder(),
        Spacing.vertical(Dimens.bottom_action_button_container_height +
            Dimens.default_vertical_margin),
      ],
    );
  }

  Widget _locationTile(Location location) {
    final value = location == null || location.equals(Location())
        ? null
        : location.shortName;

    return _detailsItemTile(
        value: value,
        caption: string('new_listing_tile_location'),
        emptyStateCaption: string('new_listing_tile_location_empty_state'),
        onTap: () {
          _editLocation(location);
        },
        isError: _isLocationError);
  }

  Widget _emptyImagesErrorMessage() {
    return _areImagesValid
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.default_horizontal_margin),
            child: Body2Text(
              string('new_listing_images_hint'),
              color: Colors.red,
            ),
          );
  }

  Widget _categoriesTile(List<ProductCategory> categories) {
    final value = categories?.isEmpty ?? true
        ? null
        : ProductCategory.getCategoryListTitles(categories);

    final onTap =
        categories?.isEmpty ?? true ? _addFirstCategory : _editCategories;

    return _detailsItemTile(
        value: value,
        caption: string('new_listing_tile_category'),
        emptyStateCaption: string('new_listing_tile_category_empty_state'),
        onTap: onTap,
        isError: _isCategoryError);
  }

  StreamBuilder<NewListingBlocUser> _phoneNumberStreamBuilder() {
    return StreamBuilder(
      stream: _newListingBloc.userStream,
      builder: (context, snapshot) {
        _user = snapshot?.data?.user;
        return (_user?.phoneNumber == null ||
                (snapshot?.data?.forceShow ?? false))
            ? _phoneNumberItemTile(_user)
            : Container();
      },
    );
  }

  StreamBuilder<Location> _locationStreamBuilder() {
    return StreamBuilder(
      stream: _newListingBloc.locationStream,
      builder: (context, snapshot) {
        _product.location = _product.location ?? snapshot.data;
        return _locationTile(_product.location);
      },
    );
  }

  Widget _phoneNumberItemTile(User user) {
    return _detailsItemTile(
        value: user?.phoneNumber == null
            ? null
            : '+${user.countryCallingCode} ${user.phoneNumber}',
        caption: string('settings_phone_number'),
        emptyStateCaption: string('new_listing_tile_phone_number_empty_state'),
        onTap: () {
          _editPhoneNumber(user);
        },
        isError: _isTelephoneError);
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
        : _buildPrimaryButton();

    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            height: 1.0,
          ),
          Container(
            color: Colors.white,
            height: Dimens.bottom_action_button_container_height,
            alignment: Alignment.center,
            child: child,
          )
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double value) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.default_horizontal_margin),
      child: Stack(
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
                string('new_listing_uploading'),
                weight: SyntheticFontWeight.semiBold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.default_horizontal_margin),
      child: PrimaryButton(
          text: string('new_listing_action_create'), onPressed: _submitForm),
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
                ? _newPhotoButton(context)
                : _productPhoto(images[i]);
          },
        ),
      ),
    );
  }

  Widget _productPhoto(CustomImage.Image image) {
    final widget = image.hasUrl
        ? CachedNetworkImage(
            placeholder: RoundedCorners(
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

    return GestureDetector(
      onTap: () {
        _viewPhoto(image);
      },
      child: Container(
        padding: EdgeInsets.only(left: Dimens.default_horizontal_margin),
        child: RoundedCorners(
          child: widget,
        ),
      ),
    );
  }

  Widget _newPhotoButton(BuildContext context) {
    if (_product.images.length >= Config.maxProductImages) return Container();

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
              onTap: _showAddImageModal,
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

  Widget _detailsItemTile(
      {String value,
      String caption,
      String emptyStateCaption,
      GestureTapCallback onTap,
      bool isError}) {
    final isEmpty = value == null;

    var finalValue = value ?? caption;

    var finalCaption = isEmpty ? emptyStateCaption : caption;
    final fontWeight =
        isEmpty ? SyntheticFontWeight.regular : SyntheticFontWeight.semiBold;
    final valueColor = isEmpty ? Colors.grey[700] : CustomTypography.baseColor;

    final captionColor = isError ? Colors.red : Colors.grey;

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

  void _scrollToTop() {
    _listViewController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _scrollToBottom() {
    _listViewController.animateTo(_listViewController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _editPhoneNumber(User user) async {
    final result = await navigation.push(EditPhoneNumber(user: user));
    if (result != null) {
      _isTelephoneError = false;
      _newListingBloc.loadUser(forceShow: true);
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
    final result = await navigation.push(LocationFilter(
      location: location,
      requireFullLocation: true,
    ));

    if (result != null) {
      setState(() {
        _product.location = result;
        _isLocationError = false;
      });
    }
  }

  void _editCategories() async {
    final result =
        await navigation.push(EditCategories(categories: _product.categories));

    if (result != null) {
      setState(() {
        _product.categories = result;
        _isCategoryError = false;
      });
    }
  }

  void _addFirstCategory() async {
    final result = await navigation.push(Categories(
      showSearch: false,
      returnChoice: true,
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
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            navigation.pop(actionDelete);
          },
        )
      ],
    ));

    if (result as String == actionDelete) {
      setState(() {
        _product.images.removeWhere((it) => it.file?.path == image.file?.path);
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
    if (_validateForm()) {
      print('Send to server');
      _newListingBloc.upload(_product);
    }
  }

  _onUploadSuccess() {
    navigation.pushReplacement(MyListings());
  }

  Future<bool> _onWillPop() {
    return _product.isNotEmpty
        ? showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title:
                        Text(string('new_listing_cancel_confirmation_title')),
                    content:
                        Text(string('new_listing_cancel_confirmation_message')),
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

  static const actionDelete = 'ACTION_DELETE';
}
