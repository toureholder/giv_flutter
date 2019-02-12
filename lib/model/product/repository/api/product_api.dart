import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class ProductApi extends BaseApi {
  Future<List<ProductCategory>> getFeaturedProductsCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return ProductCategory.homeMock();
  }

  Future<HttpResponse<List<ProductCategory>>> getSearchCategories() async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/categories');

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductCategory.parseList(response.body);

      return HttpResponse<List<ProductCategory>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<ProductCategory>>(
          status: status, message: error.toString());
    }
  }

  Future<ProductSearchResult> getProductsByCategory(
      {int categoryId, Location location, bool isHardFilter = true}) async {
    await Future.delayed(Duration(seconds: 2));
    return ProductSearchResult.mock();
  }

  Future<ProductSearchResult> getProductsBySearchQuery(
      {String q, Location location, bool isHardFilter = true}) async {
    await Future.delayed(Duration(seconds: 2));
    return ProductSearchResult.mock();
  }

  Future<HttpResponse<List<Product>>> getMyProducts() async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/me/listings');

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.parseList(response.body);

      return HttpResponse<List<Product>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<Product>>(
          status: status, message: error.toString());
    }
  }
}
