import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockDiskStorageProvider mockDiskStorage;
  MockFirebaseStorage mockFirebaseStorage;
  MockStorageReference mockStorageReference;
  FirebaseStorageUtilProvider firebaseStorageUtil;

  setUp(() {
    mockFirebaseStorage = MockFirebaseStorage();
    mockDiskStorage = MockDiskStorageProvider();
    mockStorageReference = MockStorageReference();
    firebaseStorageUtil = FirebaseStorageUtil(
      diskStorage: mockDiskStorage,
      firebaseStorage: mockFirebaseStorage,
    );
    when(mockFirebaseStorage.ref()).thenReturn(mockStorageReference);
    when(mockStorageReference.child(any)).thenReturn(mockStorageReference);
  });

  test('gets profile photo reference from firebase instance', () async {
    when(mockDiskStorage.getUser()).thenReturn(User.fake());
    await firebaseStorageUtil.getProfilePhotoRef();
    verify(mockDiskStorage.getUser()).called(1);
    verify(mockFirebaseStorage.ref()).called(1);
  });

  test('gets listings photo reference from firebase instance', () {
    firebaseStorageUtil.getListingPhotoRef();
    verifyZeroInteractions(mockDiskStorage);
    verify(mockFirebaseStorage.ref()).called(1);
  });

  test('gets group image reference from firebase instance', () {
    firebaseStorageUtil.getGroupImageRef(1);
    verifyZeroInteractions(mockDiskStorage);
    verify(mockFirebaseStorage.ref()).called(1);
  });
}
