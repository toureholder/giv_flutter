import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:giv_flutter/base/base_bloc_with_auth.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class EditGroupBloc extends BaseBlocWithAuth {
  final GroupRepository groupRepository;
  final PublishSubject<HttpResponse<Group>> groupSubject;
  final DiskStorageProvider diskStorage;
  final FirebaseStorageUtilProvider firebaseStorageUtil;
  final Util util;
  final GroupUpdatedAction groupUpdatedAction;

  Observable<HttpResponse<Group>> get groupStream => groupSubject.stream;

  EditGroupBloc({
    @required this.groupRepository,
    @required this.groupSubject,
    @required this.diskStorage,
    @required this.util,
    @required this.firebaseStorageUtil,
    @required this.groupUpdatedAction,
  }) : super(diskStorage: diskStorage);

  Group getGroupById(int id) => groupRepository.getGroupById(id);

  Future<void> editGroup(
    int groupId,
    Map<String, dynamic> request,
  ) async {
    try {
      groupSubject.sink.add(HttpResponse.loading());
      final httpResponse = await groupRepository.editGroup(groupId, request);

      final group = httpResponse.data;
      _addRandomImage(group);
      _updateState(group);

      groupSubject.sink.add(httpResponse);
    } catch (error) {
      groupSubject.sink.addError(error);
    }
  }

  Future<void> uploadImage(
    int groupId,
    File file,
  ) async {
    groupSubject.sink.add(HttpResponse.loading());

    final ref = firebaseStorageUtil.getGroupImageRef(groupId);

    final uploadTask = ref.putFile(file);

    uploadTask.events.listen((StorageTaskEvent event) async {
      if (event.type == StorageTaskEventType.success) {
        final url = await ref.getDownloadURL();

        final request = {Group.imageUrlKey: url};

        editGroup(groupId, request);
      }
    });
  }

  _addRandomImage(Group group) {
    if (group != null) {
      group.randomImageUrl = util.getRandomBackgroundImageUrl(group.id);
    }
  }

  _updateState(Group group) {
    if (group != null) {
      groupUpdatedAction.setGroup(group);
    }
  }
}
