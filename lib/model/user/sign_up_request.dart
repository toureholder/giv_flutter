class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String localeString;

  SignUpRequest({this.name, this.email, this.password, this.localeString});

  Map<String, String> toHttpPostBody() => {
    'name': name,
    'unconfirmed_email': email,
    'password': password,
    'locale': localeString
  };
}