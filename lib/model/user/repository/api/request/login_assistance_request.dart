import 'package:meta/meta.dart';

class LoginAssistanceRequest {
  final String email;

  LoginAssistanceRequest({@required this.email});

  Map<String, String> toHttpRequestBody() => {
    'email': email,
  };
}