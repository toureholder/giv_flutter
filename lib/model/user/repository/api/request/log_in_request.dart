class LogInRequest {
  final String email;
  final String password;

  LogInRequest({this.email, this.password});

  LogInRequest.fake()
      : email = 'test@test.com',
        password = '123456';

  Map<String, String> toHttpRequestBody() => {
        'email': email,
        'password': password,
      };
}
