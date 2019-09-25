import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _userPublishSubject = PublishSubject<StreamEvent<User>>();
  final _userUpdatePublishSubject = PublishSubject<HttpResponse<User>>();
  final UserRepository userRepository;
  final DiskStorageProvider diskStorage;
  final SessionProvider session;

  SettingsBloc({
    @required this.userRepository,
    @required this.diskStorage,
    @required this.session,
  });

  Observable<StreamEvent<User>> get userStream => _userPublishSubject.stream;
  Observable<HttpResponse<User>> get userUpdateStream =>
      _userUpdatePublishSubject.stream;

  dispose() {
    _userPublishSubject.close();
    _userUpdatePublishSubject.close();
  }

//  loadUserFromPrefs() {
//    try {
//      var user = diskStorage.getUser();
//      _userPublishSubject.sink.add(StreamEvent<User>(data: user));
//    } catch (error) {
//      _userPublishSubject.sink.addError(error);
//    }
//  }

  User getUser() => diskStorage.getUser();

  updateUser(Map<String, dynamic> userUpdate) async {
    try {
      _userUpdatePublishSubject.sink.add(HttpResponse.loading());

      var response = await userRepository.updateMe(userUpdate);

      if (response.data != null) await diskStorage.setUser(response.data);

      _userUpdatePublishSubject.sink.add(response);
    } catch (error) {
      _userUpdatePublishSubject.sink.addError(error);
    }
  }

  logout() => session.logUserOut();
}
