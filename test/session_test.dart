import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/service/session/session.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockDiskStorageProvider mockDiskStorageProvider;
  MockFirebaseAuth mockFirebaseAuth;
  MockFacebookLogin mockFacebookLogin;
  Session session;

  setUp(() {
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFacebookLogin = MockFacebookLogin();
    session = Session(
      mockDiskStorageProvider,
      mockFirebaseAuth,
      mockFacebookLogin,
    );
  });

  tearDown(() {
    reset(mockDiskStorageProvider);
  });

  test('sets user, server token and firebase token after login', () async {
    when(mockDiskStorageProvider.setUser(any)).thenAnswer((_) async => true);
    when(mockDiskStorageProvider.setServerToken(any))
        .thenAnswer((_) async => true);
    when(mockDiskStorageProvider.setFirebaseToken(any))
        .thenAnswer((_) async => true);
    await session.logUserIn(LogInResponse.fake());
    verify(mockDiskStorageProvider.setUser(any)).called(1);
    verify(mockDiskStorageProvider.setServerToken(any)).called(1);
    verify(mockDiskStorageProvider.setFirebaseToken(any)).called(1);
  });

  test('clears user, server token and firebase token after logout', () async {
    when(mockDiskStorageProvider.clearUser()).thenAnswer((_) async => true);
    when(mockDiskStorageProvider.clearServerToken())
        .thenAnswer((_) async => true);
    when(mockDiskStorageProvider.clearFirebaseToken())
        .thenAnswer((_) async => true);
    await session.logUserOut();
    verify(mockDiskStorageProvider.clearUser()).called(1);
    verify(mockDiskStorageProvider.clearServerToken()).called(1);
    verify(mockDiskStorageProvider.clearFirebaseToken()).called(1);
    verify(mockFirebaseAuth.signOut()).called(1);
    verify(mockFacebookLogin.logOut()).called(1);
  });
}
