import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageUtilProvider {
  Future<Reference> getProfilePhotoRef();
  Reference getListingPhotoRef();
  Reference getGroupImageRef(int groupId);
}
