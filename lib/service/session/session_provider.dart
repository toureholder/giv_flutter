import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';
import 'package:giv_flutter/model/user/user.dart';

abstract class SessionProvider {
  Future<List<bool>> logUserIn(LogInResponse logInResponse);
  Future<List<bool>> logUserOut();
  bool isAuthenticated();
  User getUser();
}