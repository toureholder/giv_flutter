import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:rxdart/rxdart.dart';

class MyListingsBloc {
  final _productRepository = ProductRepository();

  final _productsPublishSubject = PublishSubject<List<Product>>();

  Observable<List<Product>> get productsStream =>
      _productsPublishSubject.stream;

  dispose() {
    _productsPublishSubject.close();
  }

  fetchMyProducts() async {
    try {
      final List<Product> products = await _productRepository.getMyProducts();
      _productsPublishSubject.sink.add(products);
    } catch (error) {
      _productsPublishSubject.sink.add(error);
    }
  }
}