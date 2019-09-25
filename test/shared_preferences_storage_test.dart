import 'package:giv_flutter/service/preferences/shared_preferences_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockSharedPreferences mockSharedPreferences;
  SharedPreferencesStorage sharedPreferencesStorage;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    sharedPreferencesStorage = SharedPreferencesStorage(mockSharedPreferences);
  });

  tearDown(() {
    reset(mockSharedPreferences);
  });

  test('clears shared preferences', () async {
    await sharedPreferencesStorage.clearAll();
    verify(mockSharedPreferences.clear()).called(1);
  });

  test('removes firebase token from shared preferences', () async {
    await sharedPreferencesStorage.clearFirebaseToken();
    verify(mockSharedPreferences.remove(firebaseTokenKey)).called(1);
  });

  test('removes server token from shared preferences', () async {
    await sharedPreferencesStorage.clearServerToken();
    verify(mockSharedPreferences.remove(serverTokenKey)).called(1);
  });

  test('removes user from shared preferences', () async {
    await sharedPreferencesStorage.clearUser();
    verify(mockSharedPreferences.remove(userKey)).called(1);
  });

  test('gets cache payload item from shared preferences', () {
    when(mockSharedPreferences.getString(any)).thenReturn(
        '{"dateTime":"2017-10-01T06:32:56.148573","ttl":"180","data":[{"id":33,"simple_name":"Livros","canonical_name":"Livros","display_order":0,"children":[{"id":25,"simple_name":"Universitários e profissionais","canonical_name":"Livros universitários e profissionais","display_order":null,"children":[]}]}]}');
    final key = 'cache_product_categories';
    sharedPreferencesStorage.getCachePayloadItem(key);
    verify(mockSharedPreferences.getString(key)).called(1);
  });
}
