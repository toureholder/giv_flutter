import 'dart:async';

import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

class MockProductSearchResultListStreamEventSubject extends Mock
    implements PublishSubject<StreamEvent<ProductSearchResult>> {}

class MockProductSearchResultListStreamEventStreamSink extends Mock
    implements StreamSink<StreamEvent<ProductSearchResult>> {}

main() {
  MockProductRepository mockProductRepository;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockProductSearchResultListStreamEventSubject mockResultSubject;
  MockProductSearchResultListStreamEventStreamSink mockResultStreamSink;
  SearchResultBloc bloc;

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockResultSubject = MockProductSearchResultListStreamEventSubject();
    mockResultStreamSink = MockProductSearchResultListStreamEventStreamSink();

    bloc = SearchResultBloc(
      productRepository: mockProductRepository,
      diskStorage: mockDiskStorageProvider,
      searchResultSubject: mockResultSubject,
    );

    when(mockResultSubject.stream).thenAnswer(
        (_) => PublishSubject<StreamEvent<ProductSearchResult>>().stream);

    when(mockResultSubject.sink).thenReturn(mockResultStreamSink);
    when(mockDiskStorageProvider.getLocation()).thenReturn(Location.fake());
  });

  tearDown(() {
    mockResultSubject.close();
  });

  test('exposes streams', () {
    expect(bloc.result, isA<Stream<StreamEvent<ProductSearchResult>>>());
  });

  test('closes streams', () async {
    await bloc.dispose();
    verify(mockResultSubject.close()).called(1);
  });

  group('gets search suggestions', () {
    test('gets search suggestions from repository', () async {
      final q = 'books';
      await bloc.getSearchSuggestions(q);
      verify(mockProductRepository.getSearchSuggestions(q)).called(1);
    });

    test('returns a list of categories', () async {
      final q = 'books';

      when(mockProductRepository.getSearchSuggestions(q)).thenAnswer(
          (_) async => HttpResponse<List<ProductCategory>>(
              status: HttpStatus.ok,
              data: ProductCategory.fakeList(quantity: 5)));

      expect(await bloc.getSearchSuggestions(q), isA<List<ProductCategory>>());
    });

    test('returns an empty list of categories', () async {
      final q = 'books';

      when(mockProductRepository.getSearchSuggestions(q)).thenAnswer(
          (_) async => HttpResponse<List<ProductCategory>>(
              status: HttpStatus.badRequest, data: null));

      expect(await bloc.getSearchSuggestions(q), isEmpty);
    });
  });

  group('fetches products', () {
    test(
      'gets products by category from repository if category id is supplied',
      () async {
        final categoryId = 1;
        final type = ListingType.donation;

        await bloc.fetchProducts(
          categoryId: categoryId,
          type: type,
        );

        verify(mockProductRepository.getProductsByCategory(
          categoryId: categoryId,
          location: anyNamed('location'),
          isHardFilter: false,
          page: 1,
          type: type,
        )).called(1);
      },
    );

    test(
      'gets products by query from repository if query is supplied',
      () async {
        final searchQuery = 'books';
        await bloc.fetchProducts(searchQuery: searchQuery);

        verify(mockProductRepository.getProductsBySearchQuery(
          q: searchQuery,
          location: anyNamed('location'),
          isHardFilter: false,
          page: 1,
        )).called(1);
      },
    );

    test(
      'gets all products if neither search query or category id are supplied',
      () async {
        final type = ListingType.donation;

        await bloc.fetchProducts(type: type);
        verify(mockProductRepository.getAllProducts(
          location: anyNamed('location'),
          isHardFilter: false,
          page: 1,
          type: type,
        )).called(1);
      },
    );

    test(
      'gets location filter from disk storage if location is not supplied',
      () async {
        final searchQuery = 'books';
        await bloc.fetchProducts(searchQuery: searchQuery);

        verify(mockDiskStorageProvider.getLocation()).called(1);
      },
    );

    test(
      'doesn\'t gets location filter from disk storage if location is supplied',
      () async {
        final searchQuery = 'books';
        await bloc.fetchProducts(
            searchQuery: searchQuery, locationFilter: Location.fake());

        verifyNever(mockDiskStorageProvider.getLocation());
      },
    );

    test('adds loading state and data to sink if repository call succeeds',
        () async {
      final searchQuery = 'books';

      when(mockProductRepository.getProductsBySearchQuery(
        q: searchQuery,
        location: anyNamed('location'),
        isHardFilter: false,
        page: anyNamed('page'),
      )).thenAnswer((_) async => HttpResponse<ProductSearchResult>(
            status: HttpStatus.ok,
            data: ProductSearchResult.fake(),
          ));

      await bloc.fetchProducts(searchQuery: searchQuery);

      verify(mockResultStreamSink.add(any)).called(2);
    });

    test('adds loading state and error to sink if repository call fails',
        () async {
      final searchQuery = 'books';
      final errorMessage = 'Server down. Try again later';

      when(mockProductRepository.getProductsBySearchQuery(
        q: searchQuery,
        location: anyNamed('location'),
        isHardFilter: false,
        page: anyNamed('page'),
      )).thenAnswer((_) async => HttpResponse<ProductSearchResult>(
          status: HttpStatus.internalServerError,
          data: null,
          message: errorMessage));

      await bloc.fetchProducts(searchQuery: searchQuery);

      verify(mockResultStreamSink.add(any)).called(1);
      verify(mockResultSubject.addError(errorMessage)).called(1);
    });
  });
}
