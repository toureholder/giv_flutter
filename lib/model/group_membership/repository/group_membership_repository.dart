import 'package:flutter/foundation.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/group_membership_api.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:hive/hive.dart';

class GroupMembershipRepository {
  final GroupMembershipApi api;
  final Box<GroupMembership> box;
  final Box<Group> groupsBox;

  GroupMembershipRepository({
    @required this.api,
    @required this.box,
    @required this.groupsBox,
  });

  Future<HttpResponse<GroupMembership>> joinGroup(JoinGroupRequest request) {
    return api.joinGroup(request);
  }

  Future<HttpResponse<List<GroupMembership>>> getMyMemberships(
      {bool tryCache = true}) async {
    // If `tryCache`is true, try getting data from box first
    final dataInBox = box.values.toList();
    if (tryCache == true && dataInBox.isNotEmpty) {
      dataInBox.sort((a, b) => b.id.compareTo(a.id));
      return HttpResponse<List<GroupMembership>>(
        data: dataInBox,
        status: HttpStatus.ok,
      );
    }

    // Otherwise, get data from api
    final response = await api.getMyMemberships();
    final memberships = response?.data;

    if (memberships != null) {
      // Put memberships in to box
      final membershipEntries = GroupMembership.listToMap(memberships);
      await box.clear();
      box.putAll(membershipEntries);

      // Put groups (from memberships) in to box
      final groups = memberships.map((it) => it.group).toList();
      final groupEntries = Group.listToMap(groups);
      groupsBox.putAll(groupEntries);
    }

    return response;
  }

  Future<HttpResponse<List<GroupMembership>>> getGroupMemberships(
      {@required int groupId, int page}) {
    return api.fetchGroupMemberships(groupId: groupId, page: page);
  }

  Future<HttpResponse<GroupMembership>> leaveGroup({int membershipId}) {
    return api.leaveGroup(membershipId: membershipId);
  }

  GroupMembership getMembershipById(int id) {
    return box.get(id);
  }
}
