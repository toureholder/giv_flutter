import 'dart:async';

import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockCategoryListSubject extends Mock
    implements BehaviorSubject<List<ProductCategory>> {}

class MockCategoryListStreamSink extends Mock
    implements StreamSink<List<ProductCategory>> {}

main() {
  MockProductRepository mockProductRepository;
  MockCategoryListSubject mockCategoryListSubject;
  MockCategoryListStreamSink mockCategoryListStreamSink;
  CategoriesBloc bloc;

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockCategoryListSubject = MockCategoryListSubject();
    mockCategoryListStreamSink = MockCategoryListStreamSink();

    bloc = CategoriesBloc(
      productRepository: mockProductRepository,
      categoriesSubject: mockCategoryListSubject,
    );

    when(mockCategoryListSubject.sink).thenReturn(mockCategoryListStreamSink);

    final stream = BehaviorSubject<List<ProductCategory>>().stream;

    when(mockCategoryListSubject.stream).thenAnswer((_) => stream);
  });

  tearDown(() {
    mockCategoryListSubject.close();
  });

  group('gets categories from repository', () {
    test('when fetchAll is null', () async {
      await bloc.fetchCategories();

      verify(
        mockProductRepository.getSearchCategories(fetchAll: null),
      ).called(1);
    });

    test('when fetchAll is false', () async {
      await bloc.fetchCategories(fetchAll: false);

      verify(
        mockProductRepository.getSearchCategories(fetchAll: false),
      ).called(1);
    });

    test('when fetchAll is true', () async {
      await bloc.fetchCategories(fetchAll: true);

      verify(
        mockProductRepository.getSearchCategories(fetchAll: true),
      ).called(1);
    });

    test('when type is null', () async {
      await bloc.fetchCategories();

      verify(
        mockProductRepository.getSearchCategories(type: null),
      ).called(1);
    });

    test('when type is donation', () async {
      await bloc.fetchCategories(type: ListingType.donation);

      verify(
        mockProductRepository.getSearchCategories(type: ListingType.donation),
      ).called(1);
    });

    test('when type is donation request', () async {
      await bloc.fetchCategories(type: ListingType.donationRequest);

      verify(
        mockProductRepository.getSearchCategories(
            type: ListingType.donationRequest),
      ).called(1);
    });
  });

  test(
    'adds categories to sink when repository response is success',
    () async {
      when(mockProductRepository.getSearchCategories(
              fetchAll: anyNamed('fetchAll')))
          .thenAnswer((_) async => HttpResponse<List<ProductCategory>>(
              status: HttpStatus.ok, data: ProductCategory.fakeListBrowsing()));

      await bloc.fetchCategories();

      verify(mockCategoryListStreamSink.add(null)).called(1);

      verify(mockCategoryListStreamSink.add(any)).called(1);
    },
  );

  test(
    'adds error to sink when repository response is not success',
    () async {
      when(mockProductRepository.getSearchCategories(
              fetchAll: anyNamed('fetchAll')))
          .thenAnswer((_) async => HttpResponse<List<ProductCategory>>(
              status: HttpStatus.internalServerError, data: null));

      await bloc.fetchCategories();

      verify(mockCategoryListStreamSink.addError(any)).called(1);
    },
  );

  test('gets contoller stream', () async {
    expect(bloc.categories, isA<Stream<List<ProductCategory>>>());
  });

  test('closes subject', () async {
    await bloc.dispose();
    verify(mockCategoryListSubject.close());
  });
}
