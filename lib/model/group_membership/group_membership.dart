import 'package:giv_flutter/config/hive/constants.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'dart:convert';

import 'package:hive/hive.dart';

part 'group_membership.g.dart';

@HiveType(typeId: HiveConstants.groupMembershipsTypeId)
class GroupMembership extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final bool isAdmin;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final Group group;

  @HiveField(4)
  final User user;

  GroupMembership(
      {this.id, this.isAdmin, this.createdAt, this.group, this.user});

  static final String idKey = 'id';
  static final String isAdminKey = 'is_admin';
  static final String groupKey = 'group';
  static final String userKey = 'user';
  static final String createdAtlKey = 'created_at';

  GroupMembership.fromOther(
    GroupMembership other, {
    int id,
    bool isAdmin,
    DateTime createdAt,
    Group group,
    User user,
  })  : id = id ?? other.id,
        isAdmin = isAdmin ?? other.isAdmin,
        group = group ?? other.group,
        user = user ?? other.user,
        createdAt = createdAt ?? other.createdAt;

  GroupMembership.fromJson(Map<String, dynamic> json)
      : id = json[idKey],
        isAdmin = json[isAdminKey],
        group = Group.fromJson(json[groupKey]),
        user = User.fromJson(json[userKey]),
        createdAt = (json[createdAtlKey] == null)
            ? null
            : DateTime.parse(json[createdAtlKey]);

  static List<GroupMembership> fromDynamicList(List jsonList) {
    return jsonList
        .map<GroupMembership>((json) => GroupMembership.fromJson(json))
        .toList();
  }

  static List<GroupMembership> parseList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return fromDynamicList(parsed);
  }

  GroupMembership.fake({int id, int userId, bool isAdmin, Group group})
      : id = id ?? 1,
        isAdmin = isAdmin ?? false,
        group = group ?? Group.fake(),
        user = userId == null ? User.fake() : User.fake(id: userId),
        createdAt = DateTime.now();

  static List<GroupMembership> fakeList({
    List<int> containingUsersWithIds,
    List<int> containingAdminUsersWithIds,
    List<int> containingGroupsWithIds,
  }) {
    final list = [
      GroupMembership.fake(id: 1),
      GroupMembership.fake(id: 2),
    ];

    containingUsersWithIds?.forEach((userId) {
      list.add(GroupMembership.fake(userId: userId));
    });

    containingAdminUsersWithIds?.forEach((userId) {
      list.add(GroupMembership.fake(userId: userId, isAdmin: true));
    });

    containingGroupsWithIds?.forEach((groupId) {
      list.add(GroupMembership.fake(group: Group.fake(id: groupId)));
    });

    return list;
  }

  static Map<int, GroupMembership> listToMap(
      List<GroupMembership> memberships) {
    final map = <int, GroupMembership>{};

    memberships.forEach((memberhsip) {
      map.addAll(
        {memberhsip.id: memberhsip},
      );
    });

    return map;
  }
}
