import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/firebase/firebase_storage_util_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final PublishSubject<HttpResponse<User>> userUpdatePublishSubject;
  final UserRepository userRepository;
  final DiskStorageProvider diskStorage;
  final SessionProvider session;
  final FirebaseStorageUtilProvider firebaseStorageUtil;
  final Util util;

  SettingsBloc({
    @required this.userRepository,
    @required this.diskStorage,
    @required this.session,
    @required this.userUpdatePublishSubject,
    @required this.firebaseStorageUtil,
    @required this.util,
  });

  Observable<HttpResponse<User>> get userUpdateStream =>
      userUpdatePublishSubject.stream;

  dispose() => userUpdatePublishSubject.close();

  User getUser() => diskStorage.getUser();

  getProfilePhotoRef() => firebaseStorageUtil.getProfilePhotoRef();

  openWhatsApp(number, message) => util.openWhatsApp(number, message);

  updateUser(Map<String, dynamic> userUpdate) async {
    try {
      userUpdatePublishSubject.sink.add(HttpResponse.loading());

      var response = await userRepository.updateMe(userUpdate);

      if (response.data != null) await diskStorage.setUser(response.data);

      userUpdatePublishSubject.sink.add(response);
    } catch (error) {
      userUpdatePublishSubject.sink.addError(error);
    }
  }

  logout() => session.logUserOut();
}
