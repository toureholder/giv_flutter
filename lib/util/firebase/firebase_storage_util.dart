import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageUtil {
  // TODO: Inject an instance as a dependency and depend on disk storage

  static Future<StorageReference> getProfilePhotoRef() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesStorage(sharedPreferences);

    final user = storage.getUser();
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
