import 'package:giv_flutter/model/user/user.dart';

class LogInResponse {
  final String firebaseAuthToken;
  final String longLivedToken;
  final User user;

  LogInResponse(this.firebaseAuthToken, this.longLivedToken, this.user);

  LogInResponse.fromJson(Map<String, dynamic> json)
      : firebaseAuthToken = json['firebse_auth_token'],
        longLivedToken = json['long_lived_token'],
        user = User.fromJson(json['user']);

  LogInResponse.fake()
      : firebaseAuthToken = 'd393n39dn',
        longLivedToken = 'j9d3nf4fn',
        user = User.newUser();
}
