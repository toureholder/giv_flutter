import 'dart:async';

import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockHomeContentPublishSubject extends Mock
    implements PublishSubject<HomeContent> {}

class MockHomeContentSteamSink extends Mock implements StreamSink<HomeContent> {
}

main() {
  MockHomeContentPublishSubject mockHomeContentPublishSubject;
  MockHomeContentSteamSink mockHomeContentSteamSink;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockProductRepository mockProductRepository;
  MockCarouselRepository mockCarouselRepository;
  HomeBloc homeBloc;

  setUp(() {
    mockHomeContentPublishSubject = MockHomeContentPublishSubject();
    mockHomeContentSteamSink = MockHomeContentSteamSink();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockProductRepository = MockProductRepository();
    mockCarouselRepository = MockCarouselRepository();
    homeBloc = HomeBloc(
      diskStorage: mockDiskStorageProvider,
      carouselRepository: mockCarouselRepository,
      productRepository: mockProductRepository,
      contentPublishSubject: mockHomeContentPublishSubject,
    );

    when(mockHomeContentPublishSubject.sink)
        .thenReturn(mockHomeContentSteamSink);
    final stream = PublishSubject<HomeContent>().stream;
    when(mockHomeContentPublishSubject.stream).thenAnswer((_) => stream);
  });

  tearDown(() {
    mockHomeContentPublishSubject.close();
  });

  test('gets user from disk storage', () {
    homeBloc.getUser();
    verify(mockDiskStorageProvider.getUser()).called(1);
  });

  test('gets carousel items from carousel repository', () async {
    await homeBloc.fetchContent();
    verify(mockCarouselRepository.getHomeCarouselItems()).called(1);
  });

  test('gets features categories from product repository', () async {
    await homeBloc.fetchContent();
    verify(mockProductRepository.getFeaturedProductsCategories()).called(1);
  });

  test('adds data to sink if http status are ok', () async {
    when(mockProductRepository.getFeaturedProductsCategories())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.ok,
              data: ProductCategory.fakeListHomeContent(),
            ));

    when(mockCarouselRepository.getHomeCarouselItems())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.ok,
              data: CarouselItem.fakeList(),
            ));

    await homeBloc.fetchContent();
    verify(mockHomeContentSteamSink.add(any)).called(1);
    verifyNever(mockHomeContentSteamSink.addError(any));
  });

  test('adds error to sink if http status are not ok', () async {
    when(mockProductRepository.getFeaturedProductsCategories())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.internalServerError,
              data: null,
            ));

    when(mockCarouselRepository.getHomeCarouselItems())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.internalServerError,
              data: null,
            ));

    await homeBloc.fetchContent();
    verify(mockHomeContentSteamSink.addError(any)).called(1);
    verifyNever(mockHomeContentSteamSink.add(any));
  });

  test('adds error to sink if an exception is thrown when fetching contect',
      () async {
    when(mockProductRepository.getFeaturedProductsCategories())
        .thenAnswer((_) async => null);

    when(mockCarouselRepository.getHomeCarouselItems())
        .thenAnswer((_) async => null);

    await homeBloc.fetchContent();
    verify(mockHomeContentSteamSink.addError(any)).called(1);
    verifyNever(mockHomeContentSteamSink.add(any));
  });

  test('gets contoller stream', () async {
    expect(homeBloc.content, isA<Stream<HomeContent>>());
  });

  test('closes stream', () async {
    await homeBloc.dispose();
    verify(mockHomeContentPublishSubject.close()).called(1);
  });
}
