import 'package:flutter/foundation.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/group_api.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:hive/hive.dart';

class GroupRepository {
  final GroupApi api;
  final Box<Group> box;
  final Box<GroupMembership> membershipsBox;

  GroupRepository({
    @required this.api,
    @required this.box,
    @required this.membershipsBox,
  });

  Future<HttpResponse<Group>> createGroup(CreateGroupRequest request) {
    return api.createGroup(request);
  }

  Future<HttpResponse<Group>> editGroup(
      int groupId, Map<String, dynamic> request) async {
    final response = await api.editGroup(groupId, request);

    final group = response.data;

    if (group != null) {
      // Update group
      box.put(group.id, group);

      // Update memberships with this group
      final filteredMemberships =
          membershipsBox.values.where((it) => it.group.id == group.id).toList();

      final listOfUpdatedMemberships = <GroupMembership>[];

      filteredMemberships.forEach((membership) {
        listOfUpdatedMemberships.add(GroupMembership.fromOther(
          membership,
          group: group,
        ));
      });

      final membershipEntries =
          GroupMembership.listToMap(listOfUpdatedMemberships);

      membershipsBox.putAll(membershipEntries);
    }

    return response;
  }

  Future<HttpResponse<List<Product>>> getGroupListings({
    @required int groupId,
    @required int page,
  }) {
    return api.fetchGroupListings(
      groupId: groupId,
      page: page,
    );
  }

  Group getGroupById(int id) {
    return box.get(id);
  }

  Future<HttpResponse<void>> addManyListingsToGroup(
      AddManyListingsToGroupRequest request) {
    return api.addManyListingsToGroup(request);
  }
}
