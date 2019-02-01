class LogInRequest {
  final String email;
  final String password;

  LogInRequest({this.email, this.password});

  Map<String, String> toHttpRequestBody() => {
    'email': email,
    'password': password,
  };
}