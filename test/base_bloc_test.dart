import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  BaseBloc bloc;
  MockDiskStorageProvider mockDiskStorage;

  setUp(() {
    mockDiskStorage = MockDiskStorageProvider();
    bloc = BaseBloc(diskStorage: mockDiskStorage);
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
  });
}
