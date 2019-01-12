import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class SearchResultBloc {
  final _productRepository = ProductRepository();

  final _searchResultPublishSubject = PublishSubject<StreamEvent<ProductSearchResult>>();

  Observable<StreamEvent<ProductSearchResult>> get result =>
      _searchResultPublishSubject.stream;

  dispose() {
    _searchResultPublishSubject.close();
  }

  fetchProducts(
      {int categoryId,
      String searchQuery,
      Location locationFilter}) async {
    try {
      if (categoryId == null && searchQuery == null)
        throw FormatException('Expected categoryId or searchQuery');

      _searchResultPublishSubject.sink.add(StreamEvent.loading());

      bool isHardFilter = true;

      if (locationFilter == null) {
        locationFilter = await Prefs.getLocation();
        isHardFilter = false;
      }

      var result = categoryId != null
          ? await _productRepository.getProductsByCategory(
              categoryId: categoryId,
              location: locationFilter,
              isHardFilter: isHardFilter)
          : await _productRepository.getProductsBySearchQuery(
              q: searchQuery,
              location: locationFilter,
              isHardFilter: isHardFilter);

      _searchResultPublishSubject.sink.add(StreamEvent<ProductSearchResult>(
        data: result
      ));
    } catch (error) {
      _searchResultPublishSubject.addError(error);
    }
  }
}
