import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockLocationRepository mockLocationRepository;
  MockListingRepository mockListingRepository;
  MockSessionProvider mockSessionProvider;
  MockUtil mockUtil;
  MockLocationSubject mockLocationSubject;
  MockLocationStreamSink mockLocationStreamSink;
  MockApiModelHttpResponseSubject mockDeleteListingSubject;
  MockApiModelHttpResponseStreamSink mockDeleteListingStreamSink;
  MockProductHttpResponseSubject mockUpdateListingSubject;
  MockProductHttpResponseStreamSink mockUpdateListingStreamSink;
  MockStreamEventStateSubject mockLoadingSubject;
  MockStreamEventStateStreamSink mockLoadingStreamSink;
  MockDiskStorageProvider mockDiskStorageProvider;
  ProductDetailBloc bloc;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    mockListingRepository = MockListingRepository();
    mockSessionProvider = MockSessionProvider();
    mockUtil = MockUtil();
    mockLocationSubject = MockLocationSubject();
    mockLocationStreamSink = MockLocationStreamSink();
    mockDeleteListingSubject = MockApiModelHttpResponseSubject();
    mockDeleteListingStreamSink = MockApiModelHttpResponseStreamSink();
    mockUpdateListingSubject = MockProductHttpResponseSubject();
    mockUpdateListingStreamSink = MockProductHttpResponseStreamSink();
    mockLoadingSubject = MockStreamEventStateSubject();
    mockLoadingStreamSink = MockStreamEventStateStreamSink();
    mockDiskStorageProvider = MockDiskStorageProvider();

    bloc = ProductDetailBloc(
      locationRepository: mockLocationRepository,
      listingRepository: mockListingRepository,
      session: mockSessionProvider,
      locationPublishSubject: mockLocationSubject,
      deleteListingPublishSubject: mockDeleteListingSubject,
      updateListingPublishSubject: mockUpdateListingSubject,
      loadingPublishSubject: mockLoadingSubject,
      util: mockUtil,
      diskStorage: mockDiskStorageProvider,
    );

    when(mockLocationSubject.stream)
        .thenAnswer((_) => PublishSubject<Location>().stream);

    when(mockLocationSubject.sink).thenReturn(mockLocationStreamSink);

    when(mockDeleteListingSubject.stream).thenAnswer(
        (_) => PublishSubject<HttpResponse<ApiModelResponse>>().stream);

    when(mockDeleteListingSubject.sink).thenReturn(mockDeleteListingStreamSink);

    when(mockUpdateListingSubject.stream)
        .thenAnswer((_) => PublishSubject<HttpResponse<Product>>().stream);

    when(mockUpdateListingSubject.sink).thenReturn(mockUpdateListingStreamSink);

    when(mockLoadingSubject.stream)
        .thenAnswer((_) => PublishSubject<StreamEventState>().stream);

    when(mockLoadingSubject.sink).thenReturn(mockLoadingStreamSink);

    when(mockDiskStorageProvider.getLocation()).thenReturn(Location.fake());
  });

  tearDown(() {
    mockLocationSubject.close();
    mockDeleteListingSubject.close();
    mockUpdateListingSubject.close();
    mockLoadingSubject.close();
  });

  group('handles logged in user', () {
    test('gets auth status fom session', () {
      final isAuthenticated = true;
      when(mockSessionProvider.isAuthenticated()).thenReturn(isAuthenticated);
      expect(bloc.isAuthenticated(), isAuthenticated);
    });

    test('isProductMine returns true if product belongs to logged in user', () {
      final authenticatedUser = User.fake(withPhoneNumber: true);
      final productUserId = authenticatedUser.id;

      when(mockSessionProvider.isAuthenticated()).thenReturn(true);
      when(mockSessionProvider.getUser()).thenReturn(authenticatedUser);

      expect(bloc.isProductMine(productUserId), true);
    });

    test(
        'isProductMine returns false if product doesn\'t belong to logged in user',
        () {
      final authenticatedUser = User.fake(withPhoneNumber: true);
      final productUserId = authenticatedUser.id + 1;

      when(mockSessionProvider.isAuthenticated()).thenReturn(true);
      when(mockSessionProvider.getUser()).thenReturn(authenticatedUser);

      expect(bloc.isProductMine(productUserId), false);
    });

    test('isProductMine returns false if user is not logged in', () {
      final authenticatedUser = User.fake(withPhoneNumber: true);
      final productUserId = authenticatedUser.id;

      when(mockSessionProvider.isAuthenticated()).thenReturn(false);
      when(mockSessionProvider.getUser()).thenReturn(authenticatedUser);

      expect(bloc.isProductMine(productUserId), false);
    });
  });

  group('fetches location details', () {
    test('fetches location details fom location repository', () async {
      await bloc.fetchLocationDetails(Location.fakeMissingNames());
      verify(mockLocationRepository.getLocationDetails(any)).called(1);
    });

    test('adds data to sink if location repository returns success', () async {
      when(mockLocationRepository.getLocationDetails(any)).thenAnswer(
          (_) async => HttpResponse<Location>(
              status: HttpStatus.ok, data: Location.fake()));

      await bloc.fetchLocationDetails(Location.fakeMissingNames());

      verify(mockLocationStreamSink.add(any)).called(1);
      verifyNever(mockLocationStreamSink.addError(any));
    });

    test('adds error to sink if location repository returns failure', () async {
      when(mockLocationRepository.getLocationDetails(any)).thenAnswer(
          (_) async =>
              HttpResponse<Location>(status: HttpStatus.notFound, data: null));

      await bloc.fetchLocationDetails(Location.fakeMissingNames());

      verify(mockLocationStreamSink.addError(any)).called(1);
      verifyNever(mockLocationStreamSink.add(any));
    });

    test('adds error to sink if exception is thrown when fetching', () async {
      bloc = ProductDetailBloc(
        locationRepository: null,
        listingRepository: mockListingRepository,
        session: mockSessionProvider,
        locationPublishSubject: mockLocationSubject,
        deleteListingPublishSubject: mockDeleteListingSubject,
        updateListingPublishSubject: mockUpdateListingSubject,
        loadingPublishSubject: mockLoadingSubject,
        util: mockUtil,
        diskStorage: mockDiskStorageProvider,
      );

      await bloc.fetchLocationDetails(Location.fakeMissingNames());

      verify(mockLocationStreamSink.addError(any)).called(1);
      verifyNever(mockLocationStreamSink.add(any));
    });
  });

  group('deletes listing', () {
    final id = 1;

    test('asks listing repository to delete listing by id', () async {
      await bloc.deleteListing(id);
      verify(mockListingRepository.destroy(id)).called(1);
    });

    test('adds loading statuses to stream when deleting', () async {
      when(mockListingRepository.destroy(any)).thenAnswer((_) async =>
          HttpResponse<ApiModelResponse>(
              status: HttpStatus.ok, data: ApiModelResponse.fake()));

      await bloc.deleteListing(id);
      verify(mockLoadingStreamSink.add(any)).called(2);
    });

    test('adds data to stream', () async {
      when(mockListingRepository.destroy(any)).thenAnswer((_) async =>
          HttpResponse<ApiModelResponse>(
              status: HttpStatus.ok, data: ApiModelResponse.fake()));

      await bloc.deleteListing(id);
      verify(mockDeleteListingStreamSink.add(any)).called(1);
    });

    test('adds error to sink if exception is thrown when deleting', () async {
      bloc = ProductDetailBloc(
        locationRepository: mockLocationRepository,
        listingRepository: null,
        session: mockSessionProvider,
        locationPublishSubject: mockLocationSubject,
        deleteListingPublishSubject: mockDeleteListingSubject,
        updateListingPublishSubject: mockUpdateListingSubject,
        loadingPublishSubject: mockLoadingSubject,
        util: mockUtil,
        diskStorage: mockDiskStorageProvider,
      );

      await bloc.deleteListing(id);
      verify(mockDeleteListingStreamSink.addError(any)).called(1);
    });
  });

  group('updates listing', () {
    test('asks listing repository to updated listing ', () async {
      await bloc.updateActiveStatus(UpdateListingActiveStatusRequest.fake());
      verify(mockListingRepository.updateActiveStatus(any)).called(1);
    });

    test('adds loading statuses to stream when updating', () async {
      when(mockListingRepository.updateActiveStatus(any)).thenAnswer(
          (_) async => HttpResponse<Product>(
              status: HttpStatus.ok, data: Product.fakeWithImageUrls(1)));

      await bloc.updateActiveStatus(UpdateListingActiveStatusRequest.fake());
      verify(mockLoadingStreamSink.add(any)).called(2);
    });

    test('adds data to stream after updating', () async {
      when(mockListingRepository.updateActiveStatus(any)).thenAnswer(
          (_) async => HttpResponse<Product>(
              status: HttpStatus.ok, data: Product.fakeWithImageUrls(1)));

      await bloc.updateActiveStatus(UpdateListingActiveStatusRequest.fake());
      verify(mockUpdateListingStreamSink.add(any)).called(1);
    });

    test('adds error to sink if exception is thrown when updating', () async {
      bloc = ProductDetailBloc(
        locationRepository: mockLocationRepository,
        listingRepository: null,
        session: mockSessionProvider,
        locationPublishSubject: mockLocationSubject,
        deleteListingPublishSubject: mockDeleteListingSubject,
        updateListingPublishSubject: mockUpdateListingSubject,
        loadingPublishSubject: mockLoadingSubject,
        util: mockUtil,
        diskStorage: mockDiskStorageProvider,
      );

      await bloc.updateActiveStatus(UpdateListingActiveStatusRequest.fake());
      verify(mockUpdateListingStreamSink.addError(any)).called(1);
    });
  });

  test('gets contoller stream', () async {
    expect(bloc.loadingStream, isA<Stream<StreamEventState>>());
    expect(bloc.updateListingStream, isA<Stream<HttpResponse<Product>>>());
    expect(bloc.deleteListingStream,
        isA<Stream<HttpResponse<ApiModelResponse>>>());
    expect(bloc.locationStream, isA<Stream<Location>>());
  });

  test('closes stream contollers', () async {
    await bloc.dispose();

    verify(mockLocationSubject.close());
    verify(mockDeleteListingSubject.close());
    verify(mockUpdateListingSubject.close());
    verify(mockLoadingSubject.close());
  });
}
