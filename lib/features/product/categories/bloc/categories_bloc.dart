import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class CategoriesBloc {
  CategoriesBloc({
    @required this.productRepository,
    @required this.categoriesSubject,
  });

  final ProductRepository productRepository;
  final BehaviorSubject<List<ProductCategory>> categoriesSubject;

  Observable<List<ProductCategory>> get categories =>
      categoriesSubject.stream;

  dispose() {
    categoriesSubject.close();
  }

  fetchCategories({bool fetchAll}) async {
    try {
      var response =
          await productRepository.getSearchCategories(fetchAll: fetchAll);

      final data = response.data;
      if (response.status == HttpStatus.ok && data != null)
        categoriesSubject.sink.add(data);
      else
        throw response.message;
    } catch (err) {
      categoriesSubject.sink.addError(err);
    }
  }
}
