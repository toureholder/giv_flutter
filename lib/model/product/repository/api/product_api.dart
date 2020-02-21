import 'dart:convert';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:meta/meta.dart';

class ProductApi extends BaseApi {
  ProductApi({
    @required HttpClientWrapper client,
  }) : super(client: client);

  Future<HttpResponse<List<ProductCategory>>> getFeaturedProductsCategories(
      {Location location}) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/home/categories/featured', params: {
        'city_id': location?.city?.id,
        'state_id': location?.state?.id,
        'country_id': location?.country?.id
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductCategory.parseList(response.body);

      return HttpResponse<List<ProductCategory>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<ProductCategory>>(
        status: status,
        message: error.toString(),
      );
    }
  }

  Future<HttpResponse<List<ProductCategory>>> getSearchCategories(
      {bool fetchAll = false}) async {
    HttpStatus status;
    try {
      final response =
          await get('$baseUrl/categories', params: {'has_listings': !fetchAll});

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductCategory.parseList(response.body);
      return HttpResponse<List<ProductCategory>>(
        status: status,
        data: data,
        originalBody: response.body,
      );
    } catch (error) {
      return HttpResponse<List<ProductCategory>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<ProductCategory>>> getSearchSuggestions(
      String q) async {
    HttpStatus status;
    try {
      final response =
          await get('$baseUrl/categories/search', params: {'q': q});

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductCategory.parseList(response.body);

      return HttpResponse<List<ProductCategory>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<ProductCategory>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<ProductSearchResult>> getProductsByCategory(
      {int categoryId, Location location, bool isHardFilter, int page}) async {
    HttpStatus status;
    try {
      final response =
          await get('$baseUrl/listings/categories/$categoryId', params: {
        'city_id': location?.city?.id,
        'state_id': location?.state?.id,
        'country_id': location?.country?.id,
        'is_hard_filter': isHardFilter,
        'page': page,
        'per_page': Config.paginationDefaultPerPage,
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
      {String q, Location location, bool isHardFilter, int page}) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/listings/search', params: {
        'q': q,
        'city_id': location?.city?.id,
        'state_id': location?.state?.id,
        'country_id': location?.country?.id,
        'is_hard_filter': isHardFilter,
        'page': page,
        'per_page': Config.paginationDefaultPerPage,
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = ProductSearchResult.fromJson(jsonDecode(response.body));

      return HttpResponse<ProductSearchResult>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ProductSearchResult>(
          status: status, message: error.toString());
    }
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

  Future<HttpResponse<List<Product>>> getUserProducts(int userId) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/users/$userId/listings');

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.parseList(response.body);

      return HttpResponse<List<Product>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<Product>>(
          status: status, message: error.toString());
    }
  }
}
