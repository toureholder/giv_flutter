import 'package:flutter/foundation.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/create_group_request.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class CreateGroupBloc extends BaseBloc {
  final GroupRepository groupRepository;
  final PublishSubject<HttpResponse<Group>> groupSubject;
  final DiskStorageProvider diskStorage;

  Stream<HttpResponse<Group>> get groupStream => groupSubject.stream;

  CreateGroupBloc({
    @required this.groupRepository,
    @required this.groupSubject,
    @required this.diskStorage,
  }) : super(diskStorage: diskStorage);

  Future<void> createGroup(CreateGroupRequest request) async {
    try {
      groupSubject.sink.add(HttpResponse.loading());
      final httpResponse = await groupRepository.createGroup(request);
      groupSubject.sink.add(httpResponse);
    } catch (error) {
      groupSubject.sink.addError(error);
    }
  }
}
