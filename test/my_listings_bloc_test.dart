import 'dart:async';

import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockProductListPublishSubject mockProductListPublishSubject;
  MockProductListStreamSink mockProductListStreamSink;
  MockProductRepository mockProductRepository;
  MyListingsBloc myListingsBloc;

  setUp(() {
    mockProductListPublishSubject = MockProductListPublishSubject();
    mockProductListStreamSink = MockProductListStreamSink();
    mockProductRepository = MockProductRepository();

    myListingsBloc = MyListingsBloc(
      productRepository: mockProductRepository,
      productsPublishSubject: mockProductListPublishSubject,
    );

    when(mockProductListPublishSubject.stream)
        .thenAnswer((_) => PublishSubject<List<Product>>().stream);

    when(mockProductListPublishSubject.sink)
        .thenReturn(mockProductListStreamSink);
  });

  tearDown(() {
    mockProductListPublishSubject.close();
  });

  test('fetches products from repository', () async {
    await myListingsBloc.fetchMyProducts();
    verify(mockProductRepository.getMyProducts()).called(1);
  });

  test('adds data to sink if http status is ok', () async {
    when(mockProductRepository.getMyProducts())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.ok,
              data: Product.fakeList(),
            ));

    await myListingsBloc.fetchMyProducts();
    verify(mockProductListStreamSink.add(any)).called(1);
    verifyNever(mockProductListStreamSink.addError(any));
  });

  test('adds error to sink if http status are not ok', () async {
    when(mockProductRepository.getMyProducts())
        .thenAnswer((_) async => HttpResponse(
              status: HttpStatus.notFound,
              data: null,
            ));

    await myListingsBloc.fetchMyProducts();
    verify(mockProductListStreamSink.addError(any)).called(1);
    verifyNever(mockProductListStreamSink.add(any));
  });

  test(
    'adds error to sink if an exception is thrown when fetching products',
    () async {
      when(mockProductRepository.getMyProducts()).thenAnswer((_) async => null);

      await myListingsBloc.fetchMyProducts();
      verify(mockProductListStreamSink.addError(any)).called(1);
      verifyNever(mockProductListStreamSink.add(any));
    },
  );

  test('gets contoller stream', () async {
    expect(myListingsBloc.productsStream, isA<Stream<List<Product>>>());
  });

  test('closes stream', () async {
    await myListingsBloc.dispose();
    verify(mockProductListPublishSubject.close()).called(1);
  });
}
