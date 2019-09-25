import 'dart:async';

import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
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

  test('gets categories from repository', () async {
    await bloc.fetchCategories();

    verify(
      mockProductRepository.getSearchCategories(fetchAll: anyNamed('fetchAll')),
    ).called(1);
  });

  test(
    'adds categories to sink when repository response is success',
    () async {
      when(mockProductRepository.getSearchCategories(
              fetchAll: anyNamed('fetchAll')))
          .thenAnswer((_) async => HttpResponse<List<ProductCategory>>(
              status: HttpStatus.ok, data: ProductCategory.fakeListBrowsing()));

      await bloc.fetchCategories();

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
