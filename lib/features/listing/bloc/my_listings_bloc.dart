import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class MyListingsBloc {
  MyListingsBloc({@required this.productRepository});

  final ProductRepository productRepository;

  final _productsPublishSubject = PublishSubject<List<Product>>();

  Observable<List<Product>> get productsStream =>
      _productsPublishSubject.stream;

  dispose() {
    _productsPublishSubject.close();
  }

  fetchMyProducts() async {
    try {
      final response = await productRepository.getMyProducts();

      if (response.status == HttpStatus.ok)
        _productsPublishSubject.sink.add(response.data);
      else
        _productsPublishSubject.sink.addError(response.message);
    } catch (error) {
      _productsPublishSubject.sink.addError(error);
    }
  }
}