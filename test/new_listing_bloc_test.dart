import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockLocationPublishSubject extends Mock
    implements PublishSubject<Location> {}

class MockLocationStreamSink extends Mock implements StreamSink<Location> {}

class MockDoubleStreamEventPublishSubject extends Mock
    implements PublishSubject<StreamEvent<double>> {}

class MockDoubleStreamEventStreamSink extends Mock
    implements StreamSink<StreamEvent<double>> {}

class MockProductPublishSubject extends Mock
    implements PublishSubject<Product> {}

class MockProductStreamSink extends Mock implements StreamSink<Product> {}

main() {
  MockLocationPublishSubject mockLocationPublishSubject;
  MockLocationStreamSink mockLocationStreamSink;
  MockDoubleStreamEventPublishSubject mockUploadStatusPublishSubject;
  MockDoubleStreamEventStreamSink mockUploadStatusStreamSink;
  MockProductPublishSubject mockProductPublishSubject;
  MockProductStreamSink mockProductStreamSink;
  MockLocationRepository mockLocationRepository;
  MockListingRepository mockListingRepository;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockFirebaseStorageUtilProvider mockFirebaseStorageUtilProvider;
  NewListingBloc newListingBloc;
  MockStorageReference mockStorageReference;
  MockStorageUploadTask mockStorageUploadTask;
  MockTaskSnapshotStream mockTaskSnapshotStream;
  MockTaskSnapshot mockTaskSnapshot;
  MockStorageTaskSnapshot mockStorageTaskSnapshot;
  MockImagePicker mockImagePicker;

  setUp(() {
    mockLocationPublishSubject = MockLocationPublishSubject();
    mockLocationStreamSink = MockLocationStreamSink();
    mockUploadStatusPublishSubject = MockDoubleStreamEventPublishSubject();
    mockUploadStatusStreamSink = MockDoubleStreamEventStreamSink();
    mockProductPublishSubject = MockProductPublishSubject();
    mockProductStreamSink = MockProductStreamSink();
    mockFirebaseStorageUtilProvider = MockFirebaseStorageUtilProvider();
    mockListingRepository = MockListingRepository();
    mockLocationRepository = MockLocationRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockStorageReference = MockStorageReference();
    mockStorageUploadTask = MockStorageUploadTask();
    mockTaskSnapshotStream = MockTaskSnapshotStream();
    mockTaskSnapshot = MockTaskSnapshot();
    mockStorageTaskSnapshot = MockStorageTaskSnapshot();
    mockImagePicker = MockImagePicker();

    newListingBloc = NewListingBloc(
      uploadStatusPublishSubject: mockUploadStatusPublishSubject,
      locationPublishSubject: mockLocationPublishSubject,
      savedProductPublishSubject: mockProductPublishSubject,
      listingRepository: mockListingRepository,
      locationRepository: mockLocationRepository,
      firebaseStorageUtil: mockFirebaseStorageUtilProvider,
      diskStorage: mockDiskStorageProvider,
      imagePicker: mockImagePicker,
    );

    when(mockLocationPublishSubject.sink).thenReturn(mockLocationStreamSink);
    final locationStream = PublishSubject<Location>().stream;
    when(mockLocationPublishSubject.stream).thenAnswer((_) => locationStream);

    when(mockUploadStatusPublishSubject.sink)
        .thenReturn(mockUploadStatusStreamSink);
    final uploadStatusStream = PublishSubject<StreamEvent<double>>().stream;
    when(mockUploadStatusPublishSubject.stream)
        .thenAnswer((_) => uploadStatusStream);

    when(mockProductPublishSubject.sink).thenReturn(mockProductStreamSink);
    final productStream = PublishSubject<Product>().stream;
    when(mockProductPublishSubject.stream).thenAnswer((_) => productStream);
  });

  tearDown(() {
    mockLocationPublishSubject.close();
    mockUploadStatusPublishSubject.close();
    mockProductPublishSubject.close();
  });

  test('gets user from disk storage', () {
    newListingBloc.getUser();
    verify(mockDiskStorageProvider.getUser()).called(1);
  });

  test('gets location from disk storage when it is null', () {
    newListingBloc.loadCompleteLocation(null);
    verify(mockDiskStorageProvider.getLocation()).called(1);
    verifyNever(mockLocationRepository.getLocationDetails(any));
  });

  test('gets location details from repository when it is not null', () {
    newListingBloc.loadCompleteLocation(Location.fake());
    verifyNever(mockDiskStorageProvider.getLocation());
    verify(mockLocationRepository.getLocationDetails(any)).called(1);
  });

  test('adds location data to sink', () {
    newListingBloc.loadCompleteLocation(null);
    verify(mockLocationStreamSink.add(any)).called(1);
  });

  test('adds error to sink when loading location throws an exception', () {
    newListingBloc = NewListingBloc(
      uploadStatusPublishSubject: mockUploadStatusPublishSubject,
      locationPublishSubject: mockLocationPublishSubject,
      savedProductPublishSubject: mockProductPublishSubject,
      listingRepository: mockListingRepository,
      locationRepository: mockLocationRepository,
      firebaseStorageUtil: mockFirebaseStorageUtilProvider,
      imagePicker: mockImagePicker,
      diskStorage: null,
    );

    newListingBloc.loadCompleteLocation(null);
    verify(mockLocationStreamSink.addError(any));
  });

  test('calls listingRepository.create when saving a new listing', () async {
    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockListingRepository.create(any)).called(1);
  });

  test('calls listingRepository.update when editing listing', () async {
    final isEditing = true;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockListingRepository.update(any)).called(1);
  });

  test(
      'adds upload status update to sink 2 times when saving a new listing with only image urls',
      () async {
    when(mockListingRepository.create(any))
        .thenAnswer((_) async => HttpResponse<Product>(
              status: HttpStatus.created,
              data: Product.fakeWithImageUrls(1),
            ));

    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockUploadStatusStreamSink.add(any)).called(2);
  });

  test(
      'adds upload status update to sink 2 times when editing a listing with only image urls',
      () async {
    when(mockListingRepository.update(any))
        .thenAnswer((_) async => HttpResponse<Product>(
              status: HttpStatus.ok,
              data: Product.fakeWithImageUrls(1),
            ));

    final isEditing = true;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockUploadStatusStreamSink.add(any)).called(2);
  });

  test('adds saved product to sink when saving a new listing', () async {
    when(mockListingRepository.create(any))
        .thenAnswer((_) async => HttpResponse<Product>(
              status: HttpStatus.created,
              data: Product.fakeWithImageUrls(1),
            ));

    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockProductStreamSink.add(any)).called(1);
  });

  test('adds saved product to sink when editing listing', () async {
    when(mockListingRepository.update(any))
        .thenAnswer((_) async => HttpResponse<Product>(
              status: HttpStatus.ok,
              data: Product.fakeWithImageUrls(1),
            ));

    final isEditing = true;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockProductStreamSink.add(any)).called(1);
  });

  test(
      'throws an exception and adds error to sink if repository fails to create or update listing',
      () async {
    when(mockListingRepository.create(any))
        .thenAnswer((_) async => HttpResponse<Product>(
              status: HttpStatus.badRequest,
              data: Product.fakeWithImageUrls(1),
            ));

    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    await newListingBloc.saveProduct(Product.fakeWithImageUrls(1));

    verify(mockProductStreamSink.addError(any)).called(1);
  });

  test('gets firebase storage reference for each image file', () async {
    when(mockFirebaseStorageUtilProvider.getListingPhotoRef())
        .thenReturn(mockStorageReference);
    when(mockStorageReference.putFile(any))
        .thenAnswer((_) => mockStorageUploadTask);
    when(mockStorageUploadTask.snapshotEvents)
        .thenAnswer((_) => mockTaskSnapshotStream);

    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    final howManyImages = 5;
    await newListingBloc.saveProduct(
        Product.fakeWithImageFiles(1, howManyImages: howManyImages));

    verify(mockFirebaseStorageUtilProvider.getListingPhotoRef())
        .called(howManyImages);
  });

  test('calls firebase storage reference putFile for each image file',
      () async {
    when(mockFirebaseStorageUtilProvider.getListingPhotoRef())
        .thenReturn(mockStorageReference);
    when(mockStorageReference.putFile(any))
        .thenAnswer((_) => mockStorageUploadTask);
    when(mockStorageUploadTask.snapshotEvents)
        .thenAnswer((_) => mockTaskSnapshotStream);

    final isEditing = false;
    newListingBloc = NewListingBloc.from(newListingBloc, isEditing);

    final howManyImages = 5;
    await newListingBloc.saveProduct(
        Product.fakeWithImageFiles(1, howManyImages: howManyImages));

    verify(mockStorageReference.putFile(any)).called(howManyImages);
  });

  test('WIP: updates ui when a storage event task is heard', () async {
    when(mockFirebaseStorageUtilProvider.getListingPhotoRef())
        .thenReturn(mockStorageReference);
    when(mockStorageReference.putFile(any))
        .thenAnswer((_) => mockStorageUploadTask);
    when(mockStorageTaskSnapshot.bytesTransferred).thenReturn(100);
    when(mockStorageTaskSnapshot.totalBytes).thenReturn(1000);

    final controller = StreamController<TaskSnapshot>.broadcast();
    when(mockStorageUploadTask.snapshotEvents)
        .thenAnswer((_) => controller.stream);

    controller.sink.add(mockTaskSnapshot);

    final howManyImages = 5;
    await newListingBloc.saveProduct(
        Product.fakeWithImageFiles(1, howManyImages: howManyImages));

    verify(mockUploadStatusStreamSink.add(any));

    await controller.close();
  });

  test('gets contoller streams', () async {
    expect(newListingBloc.locationStream, isA<Stream<Location>>());
    expect(newListingBloc.savedProductStream, isA<Stream<Product>>());
    expect(
        newListingBloc.uploadStatusStream, isA<Stream<StreamEvent<double>>>());
  });

  test('closes streams', () async {
    await newListingBloc.dispose();
    verify(mockProductPublishSubject.close()).called(1);
    verify(mockLocationPublishSubject.close()).called(1);
    verify(mockUploadStatusPublishSubject.close()).called(1);
  });
}
