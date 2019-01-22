import 'package:giv_flutter/config/preferences/prefs.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _userPublishSubject = PublishSubject<StreamEvent<User>>();
  final _userRepository = UserRepository();

  Observable<StreamEvent<User>> get userStream => _userPublishSubject.stream;

  dispose() {
    _userPublishSubject.close();
  }

  loadUser() async {
    try {
      var user = await Prefs.getUser();
      _userPublishSubject.sink.add(StreamEvent<User>(data: user));
    } catch (error) {
      _userPublishSubject.sink.addError(error);
    }
  }

  updateUser(User user) async {
    try {
      _userPublishSubject.sink.add(StreamEvent.loading());

      var userResponse = await _userRepository.updateMe(user);

      await Prefs.setUser(userResponse);

      _userPublishSubject.sink.add(StreamEvent<User>(data: userResponse));
    } catch (error) {
      _userPublishSubject.sink.addError(error);
    }
  }
}