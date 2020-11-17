import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

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
    return firebaseStorage
        .ref()
        .child(usersFolder)
        .child('${user.id}')
        .child(photosFolder)
        .child('$timeStamp.jpg');
  }

  @override
  StorageReference getListingPhotoRef() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return firebaseStorage
        .ref()
        .child(listingsFolder)
        .child('$timeStamp-${Uuid().v1()}.jpg');
  }

  @override
  StorageReference getGroupImageRef(int groupId) {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return firebaseStorage
        .ref()
        .child(groupsFolder)
        .child('$groupId')
        .child(photosFolder)
        .child('$timeStamp-${Uuid().v1()}.jpg');
  }

  static const listingsFolder = 'listings';
  static const usersFolder = 'users';
  static const photosFolder = 'photos';
  static const groupsFolder = 'groups';
  static const devFolder = 'dev';
}
