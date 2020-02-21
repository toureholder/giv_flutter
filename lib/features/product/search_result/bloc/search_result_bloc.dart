import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SearchResultBloc {
  SearchResultBloc({
    @required this.productRepository,
    @required this.diskStorage,
    @required this.searchResultSubject,
  });

  final ProductRepository productRepository;
  final DiskStorageProvider diskStorage;

  final PublishSubject<StreamEvent<ProductSearchResult>> searchResultSubject;

  Observable<StreamEvent<ProductSearchResult>> get result =>
      searchResultSubject.stream;

  dispose() => searchResultSubject.close();


  Future<List<ProductCategory>> getSearchSuggestions(String q) async {
    try {
      HttpResponse<List<ProductCategory>> response =
          await productRepository.getSearchSuggestions(q);

      if (response.status == HttpStatus.ok) return response.data;

      throw 'Something went wrong.';
    } catch (error) {
      return [];
    }
  }

  fetchProducts({
    int categoryId,
    String searchQuery,
    Location locationFilter,
    bool isHardFilter = false,
    int page = 1,
  }) async {
    try {
      if (categoryId == null && searchQuery == null)
        throw FormatException('Expected categoryId or searchQuery');

      searchResultSubject.sink.add(StreamEvent.loading());

      locationFilter = locationFilter ?? diskStorage.getLocation();

      var response = categoryId != null
          ? await productRepository.getProductsByCategory(
              categoryId: categoryId,
              location: locationFilter,
              isHardFilter: isHardFilter,
              page: page,
            )
          : await productRepository.getProductsBySearchQuery(
              q: searchQuery,
              location: locationFilter,
              isHardFilter: isHardFilter,
              page: page,
            );

      if (response.status == HttpStatus.ok)
        searchResultSubject.sink
            .add(StreamEvent<ProductSearchResult>(data: response.data));
      else
        searchResultSubject.addError(response.message);
    } catch (error) {
      searchResultSubject.addError(error);
    }
  }
}
