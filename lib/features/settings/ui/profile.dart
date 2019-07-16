import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_bio.dart';
import 'package:giv_flutter/features/settings/ui/edit_name.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends BaseState<Profile> {
  SettingsBloc _settingsBloc;
  User _user;
  CustomImage.Image _currentImage;
  StorageUploadTask _uploadTask;
  bool _isSavingImage = false;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();

    _settingsBloc.userUpdateStream.listen((HttpResponse<User> httpResponse) {
      if (httpResponse.isReady) _isSavingImage = false;
    });

    _settingsBloc.loadUserFromPrefs();
  }

  @override
  void dispose() {
    _settingsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: string('profile_title'),
        ),
        body: ContentStreamBuilder(
          stream: _settingsBloc.userStream,
          onHasData: (StreamEvent<User> event) {
            _setCurrentUser(event.data);
            return _buildListView();
          },
        ),
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
            stream: _settingsBloc.userUpdateStream,
            builder: (context, snapshot) {
              var isLoading = snapshot?.data?.isLoading ?? false;
              return _avatar(isLoading);
            }),
        _sectionTitle(string('settings_section_profile')),
        _itemTile(
            value: _user.phoneNumber == null
                ? null
                : '+${_user.countryCallingCode} ${_user.phoneNumber}',
            caption: string('settings_phone_number'),
            emptyStateCaption: string('settings_phone_number_empty_state'),
            onTap: _editPhoneNumber),
        Divider(
          height: 1.0,
        ),
        _itemTile(
            value: _user.name,
            caption: string('settings_name'),
            emptyStateCaption: string('settings_name_empty_state'),
            onTap: _editName),
        Divider(
          height: 1.0,
        ),
        _itemTile(
            value: _user.bio,
            caption: string('settings_bio'),
            emptyStateCaption: string('settings_bio_empty_state'),
            onTap: _editBio),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Widget _itemTile(
      {String value,
      String caption,
      String emptyStateCaption,
      GestureTapCallback onTap}) {
    var finalValue = value ?? caption;
    var finalCaption = value == null ? emptyStateCaption : caption;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12.0, horizontal: Dimens.default_horizontal_margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BodyText(finalValue),
              Body2Text(finalCaption, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(bool isSaving) {
    CustomImage.Image image = _currentImage;

    if (image == null && _user.avatarUrl != null)
      image = CustomImage.Image(url: _user.avatarUrl);

    final isUploading =
        isSaving ? true : _uploadTask != null && _uploadTask.isInProgress;

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(28.0),
        child: AvatarImage(
          image: image,
          width: 154.0,
          height: 154.0,
          isLoading: isUploading,
        ),
      )
    ];

    if (isUploading) {
      children.add(Padding(
        padding: const EdgeInsets.all(28.0),
        child: SizedBox(
          width: 154.0,
          height: 154.0,
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
        ),
      ));
    } else {
      children.add(Positioned(
          bottom: 24.0,
          right: 24.0,
          child: FloatingActionButton(
            onPressed: _showAddImageModal,
            child: Icon(Icons.camera_alt),
            elevation: 2.0,
          )));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: children,
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: Dimens.default_horizontal_margin,
            top: Dimens.default_vertical_margin,
            bottom: 8.0),
        child: Subtitle(text,
            weight: SyntheticFontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _setCurrentUser(User user) {
    _user = user;
  }

  void _editBio() async {
    final result = await navigation.push(EditBio(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUserFromPrefs();
  }

  void _editName() async {
    final result = await navigation.push(EditName(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUserFromPrefs();
  }

  void _editPhoneNumber() async {
    final result = await navigation.push(EditPhoneNumber(
      user: _user,
    ));
    if (result != null) _settingsBloc.loadUserFromPrefs();
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
        tiles: tiles, title: string('profile_image_picker_modal_title'));
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
      ratioX: Config.croppedProfileImageRatioX,
      ratioY: Config.croppedProfileImageRatioY,
      maxWidth: Config.croppedProfileImageMaxHeight,
      maxHeight: Config.croppedProfileImageMaxWidth,
      toolbarTitle: string('image_cropper_toolbar_title'),
      toolbarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
    );

    if (croppedFile == null) return;

    setState(() {
      _currentImage = CustomImage.Image(file: croppedFile);
      _isSavingImage = true;
    });

    final ref = await FirebaseStorageUtil.getProfilePhotoRef();
    _uploadTask = ref.putFile(_currentImage.file);

    _uploadTask.events.listen((StorageTaskEvent event) {
      _updateUser(event, ref);
    });
  }

  _updateUser(StorageTaskEvent event, StorageReference ref) async {
    if (event.type == StorageTaskEventType.success) {
      final url = await ref.getDownloadURL();

      final update = {User.avatarUrlKey: url};

      _settingsBloc.updateUser(update);
    }
  }

  Future<bool> _onWillPop() async {
    if (_isSavingImage) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(string('profile_cancel_upload_confirmation_title')),
          content: Text(string('profile_cancel_upload_confirmation_message')),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(string('common_no')),
            ),
            FlatButton(
              onPressed: () {
                navigation.pop();
                _isSavingImage = false;
                navigation.pop();
              },
              child: Text(string('common_yes')),
            ),
          ],
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}
