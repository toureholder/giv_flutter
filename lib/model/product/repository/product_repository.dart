import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class ProductRepository {
  final productApi = ProductApi();

  Future<HttpResponse<List<ProductCategory>>> getFeaturedProductsCategories() =>
      productApi.getFeaturedProductsCategories();

  Future<HttpResponse<List<ProductCategory>>> getSearchCategories(
      {bool fetchAll}) async {
    List<ProductCategory> validCache =
        await ProductCache.getCategories(fetchAll);

    return validCache != null
        ? HttpResponse<List<ProductCategory>>(
            status: HttpStatus.ok, data: validCache)
        : productApi.getSearchCategories(fetchAll: fetchAll);
  }

  Future<HttpResponse<ProductSearchResult>> getProductsByCategory(
          {int categoryId, Location location, bool isHardFilter}) =>
      productApi.getProductsByCategory(
          categoryId: categoryId,
          location: location,
          isHardFilter: isHardFilter);

  Future<HttpResponse<ProductSearchResult>> getProductsBySearchQuery(
          {String q, Location location, bool isHardFilter}) =>
      productApi.getProductsBySearchQuery(
          q: q, location: location, isHardFilter: isHardFilter);

  Future<HttpResponse<List<ProductCategory>>> getSearchSuggestions(String q) =>
      productApi.getSearchSuggestions(q);

  Future<HttpResponse<List<Product>>> getMyProducts() =>
      productApi.getMyProducts();

  Future<HttpResponse<List<Product>>> getUserProducts(int userId) =>
      productApi.getUserProducts(userId);
}
