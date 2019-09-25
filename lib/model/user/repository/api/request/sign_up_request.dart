class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String localeString;

  SignUpRequest({this.name, this.email, this.password, this.localeString});

  SignUpRequest.fake()
      : name = 'Test',
        email = 'test@test.com',
        password = '123456',
        localeString = 'pt_BR';

  Map<String, String> toHttpRequestBody() => {
        'name': name,
        'unconfirmed_email': email,
        'password': password,
        'locale': localeString
      };
}
