import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/config/preferences/prefs.dart';

class FirebaseStorageUtil {
  static Future<StorageReference> getProfilePhotoRef() async {
    final user = await Prefs.getUser();
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return FirebaseStorage.instance
        .ref()
        .child(usersFolder)
        .child('${user.id}')
        .child(photosFolder)
        .child('${user.id}-$timeStamp.jpg');
  }

  static const usersFolder = 'users';
  static const photosFolder = 'photos';
}
