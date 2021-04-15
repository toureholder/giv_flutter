import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/api/request/join_group_request.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class JoinGroupBloc extends BaseBloc {
  final GroupMembershipRepository groupMembershipRepository;
  final PublishSubject<HttpResponse<GroupMembership>> groupMembershipSubject;
  final DiskStorageProvider diskStorage;

  Stream<HttpResponse<GroupMembership>> get groupMembershipStream =>
      groupMembershipSubject.stream;

  JoinGroupBloc({
    @required this.groupMembershipRepository,
    @required this.groupMembershipSubject,
    @required this.diskStorage,
  }) : super(diskStorage: diskStorage);

  Future<void> joinGroup(JoinGroupRequest request) async {
    try {
      groupMembershipSubject.sink.add(HttpResponse.loading());

      final httpResponse = await groupMembershipRepository.joinGroup(request);

      groupMembershipSubject.sink.add(httpResponse);
    } catch (error) {
      groupMembershipSubject.sink.addError(error);
    }
  }
}
