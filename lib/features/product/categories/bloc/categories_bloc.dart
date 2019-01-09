import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoriesBloc {
  final _productRepository = ProductRepository();

  final _categoriesPublishSubject = PublishSubject<List<ProductCategory>>();

  Observable<List<ProductCategory>> get categories =>
      _categoriesPublishSubject.stream;

  dispose() {
    _categoriesPublishSubject.close();
  }

  fetchCategories() async {
    try {
      var categories = await _productRepository.getSearchCategories();
      _categoriesPublishSubject.sink.add(categories);
    } catch (err) {
      _categoriesPublishSubject.sink.addError(err);
    }
  }
}
