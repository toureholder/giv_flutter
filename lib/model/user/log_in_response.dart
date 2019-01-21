import 'package:giv_flutter/model/user/user.dart';

class LogInResponse {
  final String firebaseAuthToken;
  final String longLivedToken;
  final User user;

  LogInResponse(this.firebaseAuthToken, this.longLivedToken, this.user);

  LogInResponse.mock()
      : firebaseAuthToken = 'd393n39dn',
        longLivedToken = 'j9d3nf4fn',
        user = User.mock();
}
