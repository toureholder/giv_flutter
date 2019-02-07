import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
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
      var response = await _productRepository.getSearchCategories();

      final data = response.data;
      if (response.status == HttpStatus.ok && data != null)
        _categoriesPublishSubject.sink.add(data);
      else
        throw response.message;
    } catch (err) {
      _categoriesPublishSubject.sink.addError(err);
    }
  }
}
