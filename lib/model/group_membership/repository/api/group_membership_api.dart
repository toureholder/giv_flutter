import 'dart:convert';

import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/group/repository/api/group_api.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class GroupMembershipApi extends BaseApi {
  GroupMembershipApi({@required HttpClientWrapper clientWrapper})
      : super(client: clientWrapper);

  Future<HttpResponse<GroupMembership>> joinGroup(
      JoinGroupRequest request) async {
    HttpStatus status;

    try {
      final response = await post(
          '$baseUrl/${GroupMembershipApi.MEMBERSHIPS_ENDPOINT}',
          request.toHttpRequestBody());

      status = HttpResponse.codeMap[response.statusCode];
      final data = GroupMembership.fromJson(jsonDecode(response.body));

      return HttpResponse<GroupMembership>(status: status, data: data);
    } catch (error) {
      return HttpResponse<GroupMembership>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<GroupMembership>>> getMyMemberships() async {
    HttpStatus status;

    try {
      final response =
          await get('$baseUrl/${GroupMembershipApi.MY_MEMBERSHIPS_ENDPOINT}');

      status = HttpResponse.codeMap[response.statusCode];
      final data = GroupMembership.parseList(response.body);

      return HttpResponse<List<GroupMembership>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<GroupMembership>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<GroupMembership>>> fetchGroupMemberships(
      {@required int groupId, int page}) async {
    HttpStatus status;

    try {
      final response = await get(
        '$baseUrl/${GroupApi.GROUPS_ENDPOINT}/$groupId/${GroupMembershipApi.GROUP_MEMBERSHIPS_PATH}',
        params: {
          'page': page,
          'per_page': Config.paginationDefaultPerPage,
        },
      );

      status = HttpResponse.codeMap[response.statusCode];
      final data = GroupMembership.parseList(response.body);

      return HttpResponse<List<GroupMembership>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<GroupMembership>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<GroupMembership>> leaveGroup({int membershipId}) async {
    HttpStatus status;

    try {
      final response = await delete(
        '$baseUrl/${GroupMembershipApi.MEMBERSHIPS_ENDPOINT}/$membershipId',
      );

      status = HttpResponse.codeMap[response.statusCode];
      final data = GroupMembership.fromJson(jsonDecode(response.body));

      return HttpResponse<GroupMembership>(status: status, data: data);
    } catch (error) {
      return HttpResponse<GroupMembership>(
          status: status, message: error.toString());
    }
  }

  static const String MEMBERSHIPS_ENDPOINT = 'group_memberships';
  static const String MY_MEMBERSHIPS_ENDPOINT = 'me/group_memberships';
  static const String GROUP_MEMBERSHIPS_PATH = 'memberships';
}
