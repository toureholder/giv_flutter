import 'dart:convert';

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

  Future<HttpResponse<ProductSearchResult>> getProductsByCategory(
      {int categoryId, Location location, bool isHardFilter}) async {
    HttpStatus status;
    try {
      final response =
          await get('$baseUrl/listings/categories/$categoryId', params: {
        'city_id': location?.city?.id,
        'state_id': location?.state?.id,
        'country_id': location?.country?.id,
        'is_hard_filter': isHardFilter
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductSearchResult.fromJson(jsonDecode(response.body));

      return HttpResponse<ProductSearchResult>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ProductSearchResult>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<ProductSearchResult>> getProductsBySearchQuery(
      {String q, Location location, bool isHardFilter = true}) async {
    await Future.delayed(Duration(seconds: 2));
    final data = ProductSearchResult.mock();
    return HttpResponse<ProductSearchResult>(status: HttpStatus.ok, data: data);
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
