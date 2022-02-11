import 'dart:async';

import 'package:giv_flutter/features/product/filters/bloc/location_filter_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockCityListStreamEventSubject extends Mock
    implements PublishSubject<StreamEvent<List<City>>> {}

class MockCityListStreamEventStreamSink extends Mock
    implements StreamSink<StreamEvent<List<City>>> {}

class MockStateListStreamEventSubject extends Mock
    implements PublishSubject<StreamEvent<List<State>>> {}

class MockStateListStreamEventStreamSink extends Mock
    implements StreamSink<StreamEvent<List<State>>> {}

class MockLocationListSubject extends Mock
    implements BehaviorSubject<LocationList> {}

class MockLocationListStreamSink extends Mock
    implements StreamSink<LocationList> {}

main() {
  MockLocationRepository mockLocationRepository;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockLocationListSubject mockLocationListSubject;
  MockLocationListStreamSink mockLocationListStreamSink;
  MockStateListStreamEventSubject mockStatesSubject;
  MockStateListStreamEventStreamSink mockStateListStreamEventStreamSink;
  MockCityListStreamEventSubject mockCitiesSubject;
  MockCityListStreamEventStreamSink mockCityListStreamEventStreamSink;
  LocationFilterBloc bloc;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockLocationListSubject = MockLocationListSubject();
    mockLocationListStreamSink = MockLocationListStreamSink();
    mockStatesSubject = MockStateListStreamEventSubject();
    mockStateListStreamEventStreamSink = MockStateListStreamEventStreamSink();
    mockCitiesSubject = MockCityListStreamEventSubject();
    mockCityListStreamEventStreamSink = MockCityListStreamEventStreamSink();

    bloc = LocationFilterBloc(
      locationRepository: mockLocationRepository,
      diskStorage: mockDiskStorageProvider,
      listSubject: mockLocationListSubject,
      statesSubject: mockStatesSubject,
      citiesSubject: mockCitiesSubject,
    );

    when(mockLocationListSubject.stream)
        .thenAnswer((_) => BehaviorSubject<LocationList>().stream);
    when(mockStatesSubject.stream)
        .thenAnswer((_) => PublishSubject<StreamEvent<List<State>>>().stream);
    when(mockCitiesSubject.stream)
        .thenAnswer((_) => PublishSubject<StreamEvent<List<City>>>().stream);

    when(mockLocationListSubject.sink).thenReturn(mockLocationListStreamSink);
    when(mockStatesSubject.sink).thenReturn(mockStateListStreamEventStreamSink);
    when(mockCitiesSubject.sink).thenReturn(mockCityListStreamEventStreamSink);
  });

  group('fetches location list', () {
    test('fetches location list from repository', () async {
      await bloc.fetchLocationLists(Location.fake());
      verify(mockLocationRepository.getLocationList(any)).called(1);
    });

    test('adds data to sink if repository call succeeds', () async {
      when(mockLocationRepository.getLocationList(any)).thenAnswer(
        (_) async => HttpResponse<LocationList>(
          status: HttpStatus.ok,
          data: LocationList.fakeOnlyCountries(),
        ),
      );

      await bloc.fetchLocationLists(Location.fake());
      verify(mockLocationListStreamSink.add(any)).called(1);
      verifyNever(mockLocationListStreamSink.addError(any));
    });

    test('adds error to sink if repository call fails', () async {
      when(mockLocationRepository.getLocationList(any)).thenAnswer(
        (_) async => HttpResponse<LocationList>(
          status: HttpStatus.notFound,
          data: null,
        ),
      );

      await bloc.fetchLocationLists(Location.fake());
      verify(mockLocationListStreamSink.addError(any)).called(1);
      verifyNever(mockLocationListStreamSink.add(any));
    });

    test('adds error to sink if fetchLocationLists throws an exception',
        () async {
      bloc = LocationFilterBloc(
        locationRepository: null,
        diskStorage: mockDiskStorageProvider,
        listSubject: mockLocationListSubject,
        statesSubject: mockStatesSubject,
        citiesSubject: mockCitiesSubject,
      );

      await bloc.fetchLocationLists(Location.fake());
      verify(mockLocationListStreamSink.addError(any)).called(1);
      verifyNever(mockLocationListStreamSink.add(any));
    });
  });

  group('fetches states', () {
    final countryId = '123';

    test('fetches states list from repository', () async {
      await bloc.fetchStates(countryId);
      verify(mockLocationRepository.getStates(countryId)).called(1);
    });

    test('adds event to clear cities cities sink', () async {
      await bloc.fetchStates(countryId);
      verify(mockCityListStreamEventStreamSink.add(any)).called(1);
    });

    test(
        'adds empty, loading and data event to sink if repository call succeeds',
        () async {
      when(mockLocationRepository.getStates(any)).thenAnswer(
        (_) async => HttpResponse<List<State>>(
          status: HttpStatus.ok,
          data: [State.fake()],
        ),
      );

      await bloc.fetchStates(countryId);
      verify(mockStateListStreamEventStreamSink.add(any)).called(3);
      verifyNever(mockStateListStreamEventStreamSink.addError(any));
    });

    test('adds empty, loading and error event to sink if repository call fails',
        () async {
      when(mockLocationRepository.getStates(any)).thenAnswer(
        (_) async => HttpResponse<List<State>>(
          status: HttpStatus.badRequest,
          data: null,
        ),
      );

      await bloc.fetchStates(countryId);
      verify(mockStateListStreamEventStreamSink.add(any)).called(2);
      verify(mockStateListStreamEventStreamSink.addError(any)).called(1);
    });

    test(
        'adds empty, loading and error event to sink if fetch states throws an exception',
        () async {
      bloc = LocationFilterBloc(
        locationRepository: null,
        diskStorage: mockDiskStorageProvider,
        listSubject: mockLocationListSubject,
        statesSubject: mockStatesSubject,
        citiesSubject: mockCitiesSubject,
      );

      await bloc.fetchStates(countryId);
      verify(mockStateListStreamEventStreamSink.add(any)).called(2);
      verify(mockStateListStreamEventStreamSink.addError(any)).called(1);
    });
  });

  group('fetches cities', () {
    final countryId = '123';
    final stateId = '456';

    test('fetches cities list from repository', () async {
      await bloc.fetchCities(countryId, stateId);
      verify(mockLocationRepository.getCities(countryId, stateId)).called(1);
    });

    test(
        'adds empty, loading and data event to sink if repository get cities call succeeds',
        () async {
      when(mockLocationRepository.getCities(any, any)).thenAnswer(
        (_) async => HttpResponse<List<City>>(
          status: HttpStatus.ok,
          data: [City.fake()],
        ),
      );

      await bloc.fetchCities(countryId, stateId);
      verify(mockCityListStreamEventStreamSink.add(any)).called(3);
      verifyNever(mockCityListStreamEventStreamSink.addError(any));
    });

    test(
        'adds empty, loading and error event to sink if repository get cities call fails',
        () async {
      when(mockLocationRepository.getCities(any, any)).thenAnswer(
        (_) async => HttpResponse<List<City>>(
          status: HttpStatus.badRequest,
          data: null,
        ),
      );

      await bloc.fetchCities(countryId, stateId);
      verify(mockCityListStreamEventStreamSink.add(any)).called(2);
      verify(mockCityListStreamEventStreamSink.addError(any)).called(1);
    });

    test(
        'adds empty, loading and error event to sink if fetch states throws an exception',
        () async {
      bloc = LocationFilterBloc(
        locationRepository: null,
        diskStorage: mockDiskStorageProvider,
        listSubject: mockLocationListSubject,
        statesSubject: mockStatesSubject,
        citiesSubject: mockCitiesSubject,
      );

      await bloc.fetchCities(countryId, stateId);
      verify(mockCityListStreamEventStreamSink.add(any)).called(2);
      verify(mockCityListStreamEventStreamSink.addError(any)).called(1);
    });
  });

  test('saves location to disk storage', () async {
    await bloc.setLocation(Location.fake());
    verify(mockDiskStorageProvider.setLocation(any)).called(1);
  });

  test('closes streams', () async {
    await bloc.dispose();
    verify(mockLocationListSubject.close()).called(1);
    verify(mockStatesSubject.close()).called(1);
    verify(mockCitiesSubject.close()).called(1);
  });

  test('exposes streams', () async {
    expect(bloc.listStream, isA<Stream<LocationList>>());
    expect(bloc.statesStream, isA<Stream<StreamEvent<List<State>>>>());
    expect(bloc.citiesStream, isA<Stream<StreamEvent<List<City>>>>());
  });
}
