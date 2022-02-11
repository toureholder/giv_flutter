import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/repository/location_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  LocationRepository locationRepository;
  MockLocationApi mockLocationApi;
  MockLocationCache mockLocationCache;

  setUp(() {
    mockLocationApi = MockLocationApi();
    mockLocationCache = MockLocationCache();
    locationRepository = LocationRepository(
      locationApi: mockLocationApi,
      locationCache: mockLocationCache,
    );
  });

  tearDown(() {
    reset(mockLocationApi);
    reset(mockLocationCache);
  });

  test('gets countries from api', () async {
    await locationRepository.getCountries();
    verify(mockLocationApi.getCountries()).called(1);
  });

  test('gets states from api', () async {
    final countryId = '1';
    await locationRepository.getStates(countryId);
    verify(mockLocationApi.getStates(countryId)).called(1);
  });

  test('gets cities from api', () async {
    final countryId = '1';
    final stateId = '2';
    await locationRepository.getCities(countryId, stateId);
    verify(mockLocationApi.getCities(countryId, stateId)).called(1);
  });

  test('gets my location from api', () async {
    final coordinates = Coordinates.fake();
    await locationRepository.getMyLocation(coordinates);
    verify(mockLocationApi.getMyLocation(coordinates)).called(1);
  });

  test('gets location from cache if location is in cache', () async {
    final location = Location.fake();
    when(mockLocationCache.getLocationDetails(any)).thenReturn(location);
    final response = await locationRepository.getLocationDetails(location);
    // Calls cache
    verify(mockLocationCache.getLocationDetails(any)).called(1);
    // Doesn't call API if cache returns a Location
    verifyZeroInteractions(mockLocationApi);
    // Returns a Location
    expect(response.data, isA<Location>());
  });

  test(
      'gets location from API if location is not in cache and then saves result to cache',
      () async {
    final location = Location.fake();
    when(mockLocationCache.getLocationDetails(any)).thenReturn(null);
    when(mockLocationApi.getLocationDetails(any))
        .thenAnswer((_) async => HttpResponse<Location>(data: location));
    final response = await locationRepository.getLocationDetails(location);
    // Calls cache
    verify(mockLocationCache.getLocationDetails(any)).called(1);
    // Calls API when cache returns null
    verify(mockLocationApi.getLocationDetails(any)).called(1);
    // Saves API result to cache
    verify(mockLocationCache.saveLocationDetails(any)).called(1);
    // Returns a Location
    expect(response.data, isA<Location>());
  });

  test('gets location list from api', () async {
    await locationRepository.getLocationList(Location.fake());
    verify(mockLocationApi.getLocationList(any)).called(1);
  });
}
