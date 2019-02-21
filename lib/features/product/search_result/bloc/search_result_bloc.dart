import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class SearchResultBloc {
  final _productRepository = ProductRepository();

  final _searchResultPublishSubject =
      PublishSubject<StreamEvent<ProductSearchResult>>();

  Observable<StreamEvent<ProductSearchResult>> get result =>
      _searchResultPublishSubject.stream;

  dispose() {
    _searchResultPublishSubject.close();
  }

  Future<List<ProductCategory>> getSearchSuggestions(String q) async {
    try {
      HttpResponse<List<ProductCategory>> response =
          await _productRepository.getSearchSuggestions(q);

      if (response.status == HttpStatus.ok) return response.data;

      throw 'Something went wrong.';
    } catch (error) {
      return [];
    }
  }

  fetchProducts(
      {int categoryId,
      String searchQuery,
      Location locationFilter,
      bool isHardFilter = false}) async {
    try {
      if (categoryId == null && searchQuery == null)
        throw FormatException('Expected categoryId or searchQuery');

      _searchResultPublishSubject.sink.add(StreamEvent.loading());

      locationFilter = locationFilter ?? await Prefs.getLocation();

      var response = categoryId != null
          ? await _productRepository.getProductsByCategory(
              categoryId: categoryId,
              location: locationFilter,
              isHardFilter: isHardFilter)
          : await _productRepository.getProductsBySearchQuery(
              q: searchQuery,
              location: locationFilter,
              isHardFilter: isHardFilter);

      if (response.status == HttpStatus.ok)
        _searchResultPublishSubject.sink
            .add(StreamEvent<ProductSearchResult>(data: response.data));
      else
        _searchResultPublishSubject.addError(response.message);
    } catch (error) {
      _searchResultPublishSubject.addError(error);
    }
  }
}
