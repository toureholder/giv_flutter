import 'package:flutter/foundation.dart';
import 'package:giv_flutter/base/base_bloc_with_auth.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class MyGroupsBloc extends BaseBlocWithAuth {
  final GroupMembershipRepository repository;
  final PublishSubject<List<GroupMembership>> subject;
  final DiskStorageProvider diskStorage;
  final Util util;

  MyGroupsBloc({
    @required this.repository,
    @required this.subject,
    @required this.diskStorage,
    @required this.util,
  }) : super(diskStorage: diskStorage);

  Observable<List<GroupMembership>> get stream => subject.stream;

  Future getMyMemberships() async {
    try {
      final httpResponse = await repository.getMyMemberships(tryCache: false);

      final data = httpResponse.data;
      if (data != null) {
        _addRandomImageUrls(data);
        subject.sink.add(data);
      } else {
        subject.sink.addError(httpResponse.message);
      }
    } catch (error) {
      subject.sink.addError(error);
    }
  }

  void _addRandomImageUrls(List<GroupMembership> memberships) {
    memberships.forEach((membership) {
      final group = membership.group;
      group.randomImageUrl = util.getRandomBackgroundImageUrl(group.id);
    });
  }
}
