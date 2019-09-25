import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageUtilProvider {
  Future<StorageReference> getProfilePhotoRef();
  StorageReference getListingPhotoRef();
}
