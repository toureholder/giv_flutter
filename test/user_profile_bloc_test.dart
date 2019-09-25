import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockProductRepository mockProductRepository;
  MockProductListPublishSubject mockProductListPublishSubject;
  MockProductListStreamSink mockProductListStreamSink;
  UserProfileBloc bloc;

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockProductListPublishSubject = MockProductListPublishSubject();
    mockProductListStreamSink = MockProductListStreamSink();

    bloc = UserProfileBloc(
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

  group('manages streams', () {
    test('exposes stream', () {
      expect(bloc.productsStream, isA<Stream<List<Product>>>());
    });

    test('closes streams', () async {
      await bloc.dispose();
      verify(mockProductListPublishSubject.close()).called(1);
    });
  });

  group('fethces products', () {
    test('fetches products from repository', () async {
      final userId = 1;
      await bloc.fetchUserProducts(userId);
      verify(mockProductRepository.getUserProducts(userId)).called(1);
    });

    test('adds data to sink if http status is ok', () async {
      final userId = 1;
      when(mockProductRepository.getUserProducts(userId))
          .thenAnswer((_) async => HttpResponse(
                status: HttpStatus.ok,
                data: Product.fakeList(),
              ));

      await bloc.fetchUserProducts(userId);
      verify(mockProductListStreamSink.add(any)).called(1);
      verifyNever(mockProductListStreamSink.addError(any));
    });

    test('adds error to sink if http status is not ok', () async {
      final userId = 1;
      when(mockProductRepository.getUserProducts(userId))
          .thenAnswer((_) async => HttpResponse(
                status: HttpStatus.notFound,
                data: null,
              ));

      await bloc.fetchUserProducts(userId);
      verify(mockProductListStreamSink.addError(any)).called(1);
      verifyNever(mockProductListStreamSink.add(any));
    });

    test('adds error to sink if exception is thrown', () async {
      bloc = UserProfileBloc(
        productRepository: null,
        productsPublishSubject: mockProductListPublishSubject,
      );

      final userId = 1;
      await bloc.fetchUserProducts(userId);
      verify(mockProductListStreamSink.addError(any)).called(1);
      verifyNever(mockProductListStreamSink.add(any));
    });
  });
}
