import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class BaseBloc {
  final DiskStorageProvider diskStorage;
  final ImagePicker imagePicker;

  BaseBloc({
    @required this.diskStorage,
    this.imagePicker,
  });

  User getUser() => diskStorage.getUser();

  Location getLocation() => diskStorage.getLocation();

  bool hasSeenCreateGroupIntroduction() =>
      diskStorage.hasSeenCreateGroupIntroduction();

  Future<bool> setHasSeenCreateGroupIntroduction() =>
      diskStorage.setHasSeenCreateGroupIntroduction();

  bool hasSeenJoinGroupIntroduction() =>
      diskStorage.hasSeenJoinGroupIntroduction();

  Future<bool> setHasSeenJoinGroupIntroduction() =>
      diskStorage.setHasSeenJoinGroupIntroduction();

  bool hasSeenDonationIntroduction() =>
      diskStorage.hasSeenDonationIntroduction();

  Future<bool> setHasSeenDonationIntroduction() =>
      diskStorage.setHasSeenDonationIntroduction();

  bool hasSeenDonationRequestIntroduction() =>
      diskStorage.hasSeenDonationRequestIntroduction();

  Future<bool> setHasSeenDonationRequestIntroduction() =>
      diskStorage.setHasSeenDonationRequestIntroduction();

  Future<XFile> getCameraImage() =>
      imagePicker.pickImage(source: ImageSource.camera);

  Future<XFile> getGalleryImage() =>
      imagePicker.pickImage(source: ImageSource.gallery);

  Future<File> cropImage({
    @required sourcePath,
    @required ratioX,
    @required ratioY,
    @required maxWidth,
    @required maxHeight,
    @required toolbarTitle,
  }) =>
      ImageCropper.cropImage(
        sourcePath: sourcePath,
        aspectRatio: CropAspectRatio(
          ratioX: ratioX,
          ratioY: ratioY,
        ),
        maxWidth: maxHeight,
        maxHeight: maxWidth,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: toolbarTitle,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
      );
}
