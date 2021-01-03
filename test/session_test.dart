import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/service/session/session.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockDiskStorageProvider mockDiskStorageProvider;
  MockFirebaseAuth mockFirebaseAuth;
  MockFacebookLogin mockFacebookLogin;
  MockAuthUserUpdatedAction mockAuthUserUpdatedAction;
  Session session;

  setUp(() {
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFacebookLogin = MockFacebookLogin();
    mockAuthUserUpdatedAction = MockAuthUserUpdatedAction();
    session = Session(
      mockDiskStorageProvider,
      mockFirebaseAuth,
      mockFacebookLogin,
      mockAuthUserUpdatedAction,
    );
  });

  tearDown(() {
    reset(mockDiskStorageProvider);
  });

  test(
      'sets user, server token and firebase token, and notifies auth user change notifier after login',
      () async {
    // Given
    when(mockDiskStorageProvider.setUser(any)).thenAnswer((_) async => true);
    when(mockDiskStorageProvider.setServerToken(any))
        .thenAnswer((_) async => true);
    when(mockDiskStorageProvider.setFirebaseToken(any))
        .thenAnswer((_) async => true);

    // When
    await session.logUserIn(LogInResponse.fake());

    // Then
    verify(mockDiskStorageProvider.setUser(any)).called(1);
    verify(mockDiskStorageProvider.setServerToken(any)).called(1);
    verify(mockDiskStorageProvider.setFirebaseToken(any)).called(1);
    verify(mockAuthUserUpdatedAction.notify()).called(1);
  });

  test(
      'clears user, server token and firebase token, and notifies auth user change notifier after logout',
      () async {
    // Given
    when(mockDiskStorageProvider.clearUser()).thenAnswer((_) async => true);
    when(mockDiskStorageProvider.clearServerToken())
        .thenAnswer((_) async => true);
    when(mockDiskStorageProvider.clearFirebaseToken())
        .thenAnswer((_) async => true);

    // When
    await session.logUserOut();

    // Then
    verify(mockDiskStorageProvider.clearUser()).called(1);
    verify(mockDiskStorageProvider.clearServerToken()).called(1);
    verify(mockDiskStorageProvider.clearFirebaseToken()).called(1);
    verify(mockFirebaseAuth.signOut()).called(1);
    verify(mockFacebookLogin.logOut()).called(1);
    verify(mockAuthUserUpdatedAction.notify()).called(1);
  });
}
