import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  BaseBloc bloc;
  MockDiskStorageProvider mockDiskStorage;
  MockImagePicker mockImagePicker;

  setUp(() {
    mockDiskStorage = MockDiskStorageProvider();
    mockImagePicker = MockImagePicker();
    bloc = BaseBloc(
      diskStorage: mockDiskStorage,
      imagePicker: mockImagePicker,
    );
  });

  group('BaseBloc', () {
    group('#getUser', () {
      test('gets user from disk storage', () {
        // Given
        final fakeUser = User.fake();
        when(mockDiskStorage.getUser()).thenReturn(fakeUser);

        // When
        final authenticatedUser = bloc.getUser();

        // Then
        expect(authenticatedUser.id, fakeUser.id);
      });
    });

    group('#getCameraImage', () {
      test('gets image from camera image source', () async {
        // When
        await bloc.getCameraImage();

        // Then
        verify(mockImagePicker.pickImage(source: ImageSource.camera));
      });
    });

    group('#getGalleryImage', () {
      test('gets image from gallery image source', () async {
        // When
        await bloc.getGalleryImage();

        // Then
        verify(mockImagePicker.pickImage(source: ImageSource.gallery));
      });
    });
  });
}
