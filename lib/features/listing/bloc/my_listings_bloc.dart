import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class MyListingsBloc {
  MyListingsBloc({
    @required this.productRepository,
    @required this.productsPublishSubject,
  });

  final ProductRepository productRepository;

  final PublishSubject<List<Product>> productsPublishSubject;

  Stream<List<Product>> get productsStream => productsPublishSubject.stream;

  dispose() {
    productsPublishSubject.close();
  }

  fetchMyProducts() async {
    try {
      final response = await productRepository.getMyProducts();

      if (response.status == HttpStatus.ok)
        productsPublishSubject.sink.add(response.data);
      else
        productsPublishSubject.sink.addError(response.message);
    } catch (error) {
      productsPublishSubject.sink.addError(error);
    }
  }
}
