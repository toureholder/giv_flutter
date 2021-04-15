import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class EditGroupBloc extends BaseBloc {
  final GroupRepository groupRepository;
  final PublishSubject<HttpResponse<Group>> groupSubject;
  final DiskStorageProvider diskStorage;
  final FirebaseStorageUtilProvider firebaseStorageUtil;
  final Util util;
  final GroupUpdatedAction groupUpdatedAction;
  final ImagePicker imagePicker;

  Stream<HttpResponse<Group>> get groupStream => groupSubject.stream;

  EditGroupBloc({
    @required this.groupRepository,
    @required this.groupSubject,
    @required this.diskStorage,
    @required this.util,
    @required this.firebaseStorageUtil,
    @required this.groupUpdatedAction,
    @required this.imagePicker,
  }) : super(
          diskStorage: diskStorage,
          imagePicker: imagePicker,
        );

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

    uploadTask.then((res) async {
      final url = await res.ref.getDownloadURL();

      final request = {Group.imageUrlKey: url};

      editGroup(groupId, request);
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
