import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' as Foundation;

class FirebaseStorageUtil implements FirebaseStorageUtilProvider {
  final DiskStorageProvider diskStorage;
  final FirebaseStorage firebaseStorage;

  FirebaseStorageUtil({
    @required this.diskStorage,
    @required this.firebaseStorage,
  });

  @override
  Future<StorageReference> getProfilePhotoRef() async {
    final user = diskStorage.getUser();
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return _getBaseFolderRef()
        .child(usersFolder)
        .child('${user.id}')
        .child(photosFolder)
        .child('$timeStamp.jpg');
  }

  @override
  StorageReference getListingPhotoRef() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return _getBaseFolderRef()
        .child(listingsFolder)
        .child('$timeStamp-${Uuid().v1()}.jpg');
  }

  @override
  StorageReference getGroupImageRef(int groupId) {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return _getBaseFolderRef()
        .child(groupsFolder)
        .child('$groupId')
        .child(photosFolder)
        .child('$timeStamp-${Uuid().v1()}.jpg');
  }

  StorageReference _getBaseFolderRef() {
    return Foundation.kReleaseMode
        ? firebaseStorage.ref()
        : firebaseStorage.ref().child(devFolder);
  }

  static const listingsFolder = 'listings';
  static const usersFolder = 'users';
  static const photosFolder = 'photos';
  static const groupsFolder = 'groups';
  static const devFolder = 'dev';
}
