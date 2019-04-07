import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageUtil {
  static Future<StorageReference> getProfilePhotoRef() async {
    final user = await Prefs.getUser();
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return FirebaseStorage.instance
        .ref()
        .child(usersFolder)
        .child('${user.id}')
        .child(photosFolder)
        .child('$timeStamp.jpg');
  }

  static StorageReference getListingPhotoRef() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return FirebaseStorage.instance
        .ref()
        .child(listingsFolder)
        .child('$timeStamp-${Uuid().v1()}.jpg');
  }

  static const listingsFolder = 'listings';
  static const usersFolder = 'users';
  static const photosFolder = 'photos';
  static const devFolder = 'dev';
}
