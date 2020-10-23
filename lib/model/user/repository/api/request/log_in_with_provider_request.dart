import 'package:meta/meta.dart';

class LogInWithProviderRequest {
  final String provider;
  final String accessToken;
  final String authorizationCode;
  final String userIdentifier;
  final String identityToken;
  final String givenName;
  final String familyName;
  final String email;
  final String localeString;

  LogInWithProviderRequest({
    @required this.provider,
    this.accessToken,
    this.authorizationCode,
    this.userIdentifier,
    this.identityToken,
    this.givenName,
    this.familyName,
    this.email,
    this.localeString,
  });

  Map<String, String> toHttpRequestBody() => {
        'auth_provider': provider,
        'access_token': accessToken,
        'auth_code': authorizationCode,
        'user_identifier': userIdentifier,
        'identity_token': identityToken,
        'given_name': givenName,
        'family_name': familyName,
        'email': email,
        'locale': localeString
      };

  static LogInWithProviderRequest fake() => LogInWithProviderRequest(
        provider: facebook,
        accessToken: 'qwe1234',
        localeString: 'pt_BR',
      );

  static const facebook = 'FACEBOOK';
  static const apple = 'APPLE';
}
