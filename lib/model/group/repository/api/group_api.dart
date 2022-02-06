import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class GroupApi extends BaseApi {
  GroupApi({@required HttpClientWrapper clientWrapper})
      : super(client: clientWrapper);

  Future<HttpResponse<Group>> createGroup(CreateGroupRequest request) async {
    HttpStatus status;

    try {
      final response = await post(
        '$baseUrl/${GroupApi.GROUPS_ENDPOINT}',
        request.toHttpRequestBody(),
      );

      status = HttpResponse.codeMap[response.statusCode];
      final data = Group.fromJson(jsonDecode(response.body));

      return HttpResponse<Group>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Group>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<Group>> editGroup(
      int groupId, Map<String, dynamic> request) async {
    HttpStatus status;

    try {
      final response = await patch(
        '$baseUrl/${GroupApi.GROUPS_ENDPOINT}/$groupId',
        request,
      );

      status = HttpResponse.codeMap[response.statusCode];
      final data = Group.fromJson(jsonDecode(response.body));

      return HttpResponse<Group>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Group>(status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<Product>>> fetchGroupListings(
      {@required int groupId, int page}) async {
    HttpStatus status;

    try {
      final response = await get(
        '$baseUrl/${GroupApi.GROUPS_ENDPOINT}/$groupId/${GroupApi.LISTINGS_PATH}',
        params: {
          'page': page,
          'per_page': Config.paginationDefaultPerPage,
        },
      );

      status = HttpResponse.codeMap[response.statusCode];
      final data = Product.parseList(response.body);

      return HttpResponse<List<Product>>(
        data: data,
        status: status,
      );
    } catch (error) {
      return HttpResponse<List<Product>>(
        status: status,
        message: error.toString(),
      );
    }
  }

  Future<HttpResponse<void>> addManyListingsToGroup(
      AddManyListingsToGroupRequest request) async {
    HttpStatus status;

    try {
      final response = await post(
        '$baseUrl/${GroupApi.GROUPS_ENDPOINT}/${request.groupId}/${GroupApi.LISTINGS_PATH}/${GroupApi.MANY_PATH}',
        request.toHttpRequestBody(),
      );

      status = HttpResponse.codeMap[response.statusCode];

      return HttpResponse<void>(status: status);
    } catch (error) {
      return HttpResponse<List<Product>>(
        status: status,
        message: error.toString(),
      );
    }
  }

  static const String GROUPS_ENDPOINT = 'groups';
  static const String LISTINGS_PATH = 'listings';
  static const String MANY_PATH = 'many';
}
