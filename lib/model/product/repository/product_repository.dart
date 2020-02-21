import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class ProductRepository {
  final ProductApi productApi;
  final ProductCacheProvider productCache;

  ProductRepository({@required this.productApi, @required this.productCache});

  Future<HttpResponse<List<ProductCategory>>> getFeaturedProductsCategories() =>
      productApi.getFeaturedProductsCategories();

  Future<HttpResponse<List<ProductCategory>>> getSearchCategories(
      {bool fetchAll}) async {
    List<ProductCategory> validCache = productCache.getCategories(fetchAll);

    if (validCache != null) {
      return HttpResponse<List<ProductCategory>>(
        status: HttpStatus.ok,
        data: validCache,
      );
    } else {
      final response = await productApi.getSearchCategories(fetchAll: fetchAll);
      final originalResponseBody = response.originalBody;
      if (originalResponseBody != null)
        productCache.saveCategories(originalResponseBody, fetchAll);
      return response;
    }
  }

  Future<HttpResponse<ProductSearchResult>> getProductsByCategory(
          {int categoryId, Location location, bool isHardFilter, int page}) =>
      productApi.getProductsByCategory(
        categoryId: categoryId,
        location: location,
        isHardFilter: isHardFilter,
        page: page,
      );

  Future<HttpResponse<ProductSearchResult>> getProductsBySearchQuery(
          {String q, Location location, bool isHardFilter, int page}) =>
      productApi.getProductsBySearchQuery(
        q: q,
        location: location,
        isHardFilter: isHardFilter,
        page: page,
      );

  Future<HttpResponse<List<ProductCategory>>> getSearchSuggestions(String q) =>
      productApi.getSearchSuggestions(q);

  Future<HttpResponse<List<Product>>> getMyProducts() =>
      productApi.getMyProducts();

  Future<HttpResponse<List<Product>>> getUserProducts(int userId) =>
      productApi.getUserProducts(userId);
}
