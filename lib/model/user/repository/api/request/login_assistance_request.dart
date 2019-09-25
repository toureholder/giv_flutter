import 'package:meta/meta.dart';

class LoginAssistanceRequest {
  final String email;

  LoginAssistanceRequest({@required this.email});

  LoginAssistanceRequest.fake() : email = 'test@test.com';

  Map<String, String> toHttpRequestBody() => {
    'email': email,
  };
}
