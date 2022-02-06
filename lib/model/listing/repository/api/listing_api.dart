import 'dart:convert';
import 'dart:async';

import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:meta/meta.dart';

class ListingApi extends BaseApi {
  ListingApi({
    @required HttpClientWrapper client,
  }) : super(client: client);

  Future<HttpResponse<Product>> create(CreateListingRequest request) async {
    HttpStatus status;
    try {
      final response =
          await post('$baseUrl/listings', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.fromJson(jsonDecode(response.body));

      return HttpResponse<Product>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Product>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<Product>> update(CreateListingRequest request) async {
    HttpStatus status;
    try {
      final response = await put(
          '$baseUrl/listings/${request.id}', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.fromJson(jsonDecode(response.body));

      return HttpResponse<Product>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Product>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<Product>> updateActiveStatus(
      UpdateListingActiveStatusRequest request) async {
    HttpStatus status;
    try {
      final response = await put(
          '$baseUrl/listings/${request.id}', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.fromJson(jsonDecode(response.body));

      return HttpResponse<Product>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Product>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<ApiModelResponse>> destroy(int id) async {
    HttpStatus status;
    try {
      final response = await delete('$baseUrl/listings/$id');

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiModelResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiModelResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiModelResponse>(
          status: status, message: error.toString());
    }
  }
}
