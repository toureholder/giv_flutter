import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class GroupInformationBloc extends BaseBloc {
  final GroupMembershipRepository memberhipsRepository;
  final PublishSubject<List<GroupMembership>> loadMembershipsSubject;
  final DiskStorageProvider diskStorage;
  final Util util;

  GroupInformationBloc({
    @required this.memberhipsRepository,
    @required this.loadMembershipsSubject,
    @required this.diskStorage,
    @required this.util,
  }) : super(diskStorage: diskStorage);

  Stream<List<GroupMembership>> get loadMembershipsStream =>
      loadMembershipsSubject.stream;

  Future getGroupMemberships({int groupId, int page}) async {
    try {
      final httpResponse = await memberhipsRepository.getGroupMemberships(
        groupId: groupId,
        page: page,
      );

      final data = httpResponse.data;
      if (data != null) {
        loadMembershipsSubject.sink.add(data);
      } else {
        loadMembershipsSubject.sink.addError(httpResponse.message);
      }
    } catch (error) {
      loadMembershipsSubject.sink.addError(error);
    }
  }

  GroupMembership getMembershipById(int id) {
    return memberhipsRepository.getMembershipById(id);
  }

  Future<void> shareGroup(BuildContext context, Group group) =>
      util.shareGroup(context, group);
}
