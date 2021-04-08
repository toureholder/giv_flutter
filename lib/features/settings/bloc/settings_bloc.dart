import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/authenticated_user_updated_action.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends BaseBloc {
  final PublishSubject<HttpResponse<User>> userUpdatePublishSubject;
  final UserRepository userRepository;
  final DiskStorageProvider diskStorage;
  final SessionProvider session;
  final FirebaseStorageUtilProvider firebaseStorageUtil;
  final Util util;
  final AuthUserUpdatedAction authUserUpdatedAction;
  final TargetPlatform platform;
  final ImagePicker imagePicker;

  SettingsBloc({
    @required this.userRepository,
    @required this.diskStorage,
    @required this.session,
    @required this.userUpdatePublishSubject,
    @required this.firebaseStorageUtil,
    @required this.util,
    @required this.authUserUpdatedAction,
    @required this.platform,
    @required this.imagePicker,
  }) : super(
          diskStorage: diskStorage,
          imagePicker: imagePicker,
        );

  Stream<HttpResponse<User>> get userUpdateStream =>
      userUpdatePublishSubject.stream;

  dispose() => userUpdatePublishSubject.close();

  getProfilePhotoRef() => firebaseStorageUtil.getProfilePhotoRef();

  openWhatsApp(number, message) => util.openWhatsApp(number, message);

  updateUser(Map<String, dynamic> userUpdate) async {
    try {
      userUpdatePublishSubject.sink.add(HttpResponse.loading());

      var response = await userRepository.updateMe(userUpdate);

      if (response.data != null) {
        await diskStorage.setUser(response.data);
        authUserUpdatedAction.notify();
      }

      userUpdatePublishSubject.sink.add(response);
    } catch (error) {
      userUpdatePublishSubject.sink.addError(error);
    }
  }

  Future<List<bool>> logout() async {
    return session.logUserOut();
  }
}
