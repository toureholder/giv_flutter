import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/phone_verification/bloc/phone_verification_bloc.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_bio.dart';
import 'package:giv_flutter/features/settings/ui/edit_name.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/edit_information_tile.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final SettingsBloc settingsBloc;

  const EditProfile({Key key, @required this.settingsBloc}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends BaseState<EditProfile> {
  SettingsBloc _settingsBloc;
  User _user;
  CustomImage.Image _currentImage;
  StorageUploadTask _uploadTask;
  bool _isSavingImage = false;

  @override
  void initState() {
    super.initState();
    _settingsBloc = widget.settingsBloc;

    _settingsBloc.userUpdateStream?.listen((HttpResponse<User> httpResponse) {
      if (httpResponse.isReady) _isSavingImage = false;
    });

    _user = _settingsBloc.getUser();
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
        body: _buildListView(context),
      ),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: _settingsBloc.userUpdateStream,
          builder: (context, snapshot) {
            var isLoading = snapshot?.data?.isLoading ?? false;
            return _avatar(isLoading);
          },
        ),
        EditProfileSectionTitle(string('settings_section_profile')),
        PhoneNumberTile(
          user: _user,
          onTap: () {
            _editPhoneNumber(context);
          },
        ),
        CustomDivider(),
        NameTile(value: _user.name, onTap: _editName),
        CustomDivider(),
        BioTile(value: _user.bio, onTap: _editBio),
        CustomDivider(),
      ],
    );
  }

  Widget _avatar(bool isSaving) {
    CustomImage.Image image = _currentImage;

    if (image == null && _user.avatarUrl != null)
      image = CustomImage.Image(url: _user.avatarUrl);

    final isUploading =
        isSaving ? true : _uploadTask != null && _uploadTask.isInProgress;

    final children = <Widget>[
      ProfileAvatar(image: image, isUploading: isUploading),
    ];

    final nextWidget = isUploading
        ? ProfileAvatarUploadingState()
        : ProfileAvatarAddImageFab(onPressed: _showAddImageModal);

    children.add(nextWidget);

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

  void _editBio() async {
    final result = await navigation.push(Consumer<SettingsBloc>(
      builder: (context, bloc, child) => EditBio(
        settingsBloc: bloc,
        user: _user,
      ),
    ));
    if (result != null) _reloadUser();
  }

  void _editName() async {
    final result = await navigation.push(Consumer<SettingsBloc>(
      builder: (context, bloc, child) => EditName(
        settingsBloc: bloc,
        user: _user,
      ),
    ));
    if (result != null) _reloadUser();
  }

  void _editPhoneNumber(BuildContext context) async {
    final result = await navigation.push(
      EditPhoneNumber(
        settingsBloc: Provider.of<SettingsBloc>(context),
        phoneVerificationBloc: Provider.of<PhoneVerificationBloc>(context),
        user: _user,
      ),
    );
    _reloadUser();
  }

  void _reloadUser() {
    setState(() {
      _user = _settingsBloc.getUser();
    });
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

    TiledBottomSheet.show(context,
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
      aspectRatio: CropAspectRatio(
        ratioX: Config.croppedProfileImageRatioX,
        ratioY: Config.croppedProfileImageRatioY,
      ),
      maxWidth: Config.croppedProfileImageMaxHeight,
      maxHeight: Config.croppedProfileImageMaxWidth,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: string('image_cropper_toolbar_title'),
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
      ),
    );

    if (croppedFile == null) return;

    setState(() {
      _currentImage = CustomImage.Image(file: croppedFile);
      _isSavingImage = true;
    });

    final ref = await _settingsBloc.getProfilePhotoRef();
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

class ProfileAvatar extends StatelessWidget {
  final CustomImage.Image image;
  final bool isUploading;

  const ProfileAvatar({
    Key key,
    @required this.image,
    @required this.isUploading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: AvatarImage(
        image: image,
        width: 154.0,
        height: 154.0,
        isLoading: isUploading,
      ),
    );
  }
}

class ProfileAvatarAddImageFab extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileAvatarAddImageFab({Key key, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      right: 24.0,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: onPressed,
        child: Icon(Icons.camera_alt),
        elevation: 2.0,
      ),
    );
  }
}

class ProfileAvatarUploadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: SizedBox(
        width: 154.0,
        height: 154.0,
        child: CircularProgressIndicator(
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}

class EditProfileSectionTitle extends StatelessWidget {
  final String text;

  const EditProfileSectionTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: Dimens.default_horizontal_margin,
            top: Dimens.default_vertical_margin,
            bottom: 8.0),
        child: Subtitle(
          text,
          weight: SyntheticFontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class PhoneNumberTile extends StatelessWidget {
  final User user;
  final GestureTapCallback onTap;

  const PhoneNumberTile({
    Key key,
    @required this.user,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return EditInformationTile(
      value: user.phoneNumber == null
          ? null
          : '+${user.countryCallingCode} ${user.phoneNumber}',
      caption: stringFunction('settings_phone_number'),
      emptyStateCaption: stringFunction('settings_phone_number_empty_state'),
      onTap: onTap,
    );
  }
}

class NameTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;

  const NameTile({
    Key key,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return EditInformationTile(
      value: value,
      caption: stringFunction('settings_name'),
      emptyStateCaption: stringFunction('settings_name_empty_state'),
      onTap: onTap,
    );
  }
}

class BioTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;

  const BioTile({
    Key key,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return EditInformationTile(
      value: value,
      caption: stringFunction('settings_bio'),
      emptyStateCaption: stringFunction('settings_bio_empty_state'),
      onTap: onTap,
    );
  }
}
