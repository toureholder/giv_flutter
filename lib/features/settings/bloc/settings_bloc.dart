import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _userPublishSubject = PublishSubject<StreamEvent<User>>();
  final _userUpdatePublishSubject = PublishSubject<HttpResponse<User>>();
  final _userRepository = UserRepository();

  Observable<StreamEvent<User>> get userStream => _userPublishSubject.stream;
  Observable<HttpResponse<User>> get userUpdateStream => _userUpdatePublishSubject.stream;

  dispose() {
    _userPublishSubject.close();
    _userUpdatePublishSubject.close();
  }

  loadUserFromPrefs() async {
    try {
      var user = await Prefs.getUser();
      _userPublishSubject.sink.add(StreamEvent<User>(data: user));
    } catch (error) {
      _userPublishSubject.sink.addError(error);
    }
  }

  updateUser(Map<String, dynamic> userUpdate) async {
    try {
      _userUpdatePublishSubject.sink.add(HttpResponse.loading());

      var response = await _userRepository.updateMe(userUpdate);

      if (response.data != null)
        await Prefs.setUser(response.data);

      _userUpdatePublishSubject.sink.add(response);
    } catch (error) {
      _userUpdatePublishSubject.sink.addError(error);
    }
  }
}