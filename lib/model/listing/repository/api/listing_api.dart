import 'dart:io';
import 'dart:convert';

import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class ListingApi extends BaseApi {
  Future<HttpResponse<ApiModelResponse>> create(
      CreateListingRequest request) async {
    HttpStatus status;
    try {
      final response = await post('$baseUrl/listings', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiModelResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiModelResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiModelResponse>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<ApiModelResponse>> update(
      CreateListingRequest request) async {
    HttpStatus status;
    try {
      final response = await put('$baseUrl/listings/${request.id}', request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = ApiModelResponse.fromJson(jsonDecode(response.body));

      return HttpResponse<ApiModelResponse>(status: status, data: data);
    } catch (error) {
      return HttpResponse<ApiModelResponse>(
          status: status, message: error.toString());
    }
  }
}
