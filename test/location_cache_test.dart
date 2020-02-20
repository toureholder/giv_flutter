import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/cache/location_cache.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  MockDiskStorageProvider mockDiskStorageProvider;
  LocationCache locationCache;
  Location fakeLocation = Location.fake();

  setUp(() {
    mockDiskStorageProvider = MockDiskStorageProvider();
    locationCache = LocationCache(diskStorage: mockDiskStorageProvider);
  });

  tearDown(() {
    reset(mockDiskStorageProvider);
  });

  test('returns correct location from cache', () {
    when(mockDiskStorageProvider.getLocationCacheItem(any))
        .thenReturn(fakeLocation);
    final location = locationCache.getLocationDetails(fakeLocation);
    expect(location.country.id, fakeLocation.country.id);
  });

  test('saves location details to disk storage', () {
    locationCache.saveLocationDetails(fakeLocation);
    verify(mockDiskStorageProvider.setLocationCacheItem(any, fakeLocation));
  });
}
