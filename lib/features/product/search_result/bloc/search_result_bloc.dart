import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchResultBloc {
  final _productRepository = ProductRepository();

  final _productsPublishSubject = PublishSubject<List<Product>>();

  Observable<List<Product>> get products => _productsPublishSubject.stream;

  dispose() {
    _productsPublishSubject.close();
  }

  fetchProducts({int categoryId, String searchQuery}) async {
    try {
      if (categoryId == null && searchQuery == null)
        throw FormatException('Expected categoryId or searchQuery');

      var products = categoryId != null
          ? await _productRepository.getProductsByCategory(categoryId)
          : await _productRepository.getProductsBySearchQuery(searchQuery);

      _productsPublishSubject.sink.add(products);
    } catch (error) {
      _productsPublishSubject.addError(error);
    }
  }
}
