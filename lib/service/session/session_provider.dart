import 'package:giv_flutter/model/user/repository/api/response/log_in_response.dart';

abstract class SessionProvider {
  Future<List<bool>> logUserIn(LogInResponse logInResponse);
  Future<List<bool>> logUserOut();
  bool isAuthenticated();
}